//
//  CMViewController.m
//  Class Mate
//
//  Created by Alex Layton on 26/11/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "CMViewController.h"
#import "CMRemindersViewController.h"
#import "CMAppDelegate.h"
#import "CMHUDView.h"
#import <QuartzCore/QuartzCore.h>

@interface CMViewController ()

@property (nonatomic) BOOL showingHUD;
@property (nonatomic, strong) UIPanGestureRecognizer *pgr;

@end

@implementation CMViewController
{
    CGFloat fromY;
}

@synthesize feedbackCell = _feedbackCell;
@synthesize HUDButton = _HUDButton;
@synthesize HUDView = _HUDView;
@synthesize showingHUD = _showingHUD;
@synthesize pgr = _pgr;
@synthesize addButton = _addButton;

- (void)launchFeedback
{
    [TestFlight openFeedbackView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    
    [CMAppDelegate customiseAppearance];
    
    //Load navbarbar image
    UIImage *classMate = [UIImage imageNamed:@"class-mate.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:classMate];
    self.navigationItem.titleView = imageView;
    
    //change background pattern
    UIImage *patternImage = [UIImage imageNamed:@"pattern.png"];
    UIColor *pattern = [UIColor colorWithPatternImage:patternImage];
    CGRect backgroundRect = [[UIScreen mainScreen] applicationFrame];
    UIView *backgroundView = [[UIView alloc] initWithFrame:backgroundRect];
    [backgroundView setBackgroundColor:pattern];
    self.tableView.backgroundView = backgroundView;
    
    //turn add button blue
    UIImage *barButtonBlue = [[UIImage imageNamed:@"barbuttonblue.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [_addButton setBackgroundImage:barButtonBlue forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    //shadow
//    CALayer *layer = self.navigationController.view.layer;
//    layer.masksToBounds = NO;
//    layer.shadowOffset = CGSizeMake(0, 5);
//    layer.shadowRadius = 5;
//    layer.shadowOpacity = 0.70;
    
    ALLocationReminderManager *lrm = [ALLocationReminderManager sharedManager];
    lrm.delegate = self;
    [lrm startLocation];
    
    //testflight stuff...
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(launchFeedback)];
    [_feedbackCell addGestureRecognizer:tgr];
    
    _HUDView = [[[NSBundle mainBundle] loadNibNamed:@"CMHUDView" owner:self options:nil] objectAtIndex:0];
    NSString *message = [NSString stringWithFormat:@"%@ is %d Seconds Away", [lrm.store peekReminderWithType:kALLocationReminderTypePreemptive].payload, lrm.seconds];
    _HUDView.HUDLabel.text = message;
    
    CGRect navRect = self.navigationController.view.frame;
    NSLog(@"nav: %f, %f, %f, %f", navRect.origin.x, navRect.origin.y, navRect.size.width, navRect.size.height);
    NSLog(@"nav super view: %@", self.navigationController.view.superview);
    
    _showingHUD = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
     [self.navigationController setToolbarHidden:NO animated:animated];
    
    UIImage *gripper = [UIImage imageNamed:@"gripper.png"];
    _HUDButton.customView = [[UIImageView alloc] initWithImage:gripper];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap)];
    [_HUDButton.customView addGestureRecognizer:tgr];
    
    _pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    _pgr.minimumNumberOfTouches = 1;
    _pgr.maximumNumberOfTouches = 1;
    [_HUDButton.customView addGestureRecognizer:_pgr];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIWindow *window = self.view.window;
    CGRect windowRect = window.frame;
    
    CGRect HUDRect = CGRectMake(windowRect.origin.x, windowRect.size.height - 100, windowRect.size.width, 100);
    _HUDView.frame = HUDRect;
    [window insertSubview:_HUDView belowSubview:self.navigationController.view];
    
    BOOL locationIsEnabled = [CLLocationManager locationServicesEnabled];
    NSLog(@"enabled? %d", locationIsEnabled);
    if (!locationIsEnabled) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Need Location" message:@"Allow access to location to use this app" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_showingHUD) [self hideHUD];
    [self.navigationController.toolbar removeGestureRecognizer:_pgr];
    [_HUDView removeFromSuperview];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (_showingHUD) [self hideHUD];
    [_HUDView removeFromSuperview];
    CMRemindersViewController *rvc = segue.destinationViewController;
    ALLocationReminderManager *lrm = [ALLocationReminderManager sharedManager];
    if ([segue.identifier isEqualToString:@"Preemptive"]) {
        NSLog(@"Preemptive");
        rvc.reminderType = @"Preemptive";
        rvc.reminders = lrm.store.preemptiveReminders;
    } else if ([segue.identifier isEqualToString:@"Location"]) {
        NSLog(@"Location");
        rvc.reminderType = @"Location";
        rvc.reminders = lrm.store.locationReminders;
    } else if ([segue.identifier isEqualToString:@"Date"]) {
        NSLog(@"Date");
        rvc.reminderType = @"Date";
        rvc.reminders = lrm.store.dateReminders;
    } else if ([segue.identifier isEqualToString:@"Add"] || [segue.identifier isEqualToString:@"Settings"]) {
        [CMAppDelegate resetAppearance];
    }
}

- (void)didTap
{
    if (!_showingHUD) {
        [self bounceHUD];
    } else {
        [self hideHUD];
    }
}

- (void)didPan:(id)sender
{
    UIPanGestureRecognizer *pgr = sender;
    UINavigationController *nav = self.navigationController;
    CGRect navRect = nav.view.frame;
    CGFloat toY = [pgr locationInView:nav.view].y;
    
    if (pgr.state == UIGestureRecognizerStateBegan) {
        fromY = toY;
    } else if (pgr.state == UIGestureRecognizerStateChanged) {
        CGFloat diffY = toY - fromY;
        CGFloat newY = navRect.origin.y + diffY;
        NSLog(@"%f", newY);
        if (newY <= 0.0f && newY >= -100.0f) {
            CGRect newNavRect = CGRectMake(navRect.origin.x, newY, navRect.size.width, navRect.size.height);
            [UIView animateWithDuration:0.001f animations:^{
                nav.view.frame = newNavRect;
            }];
        }
    } else if (pgr.state == UIGestureRecognizerStateEnded) {
        CGFloat diffY = toY - fromY;
        CGFloat newY = navRect.origin.y + diffY;
        (newY <= 0.0f && newY >= -50.0f) ? [self hideHUD] : [self showHUD];
    }
}

- (void)showHUD
{
    _showingHUD = YES;
    
    self.tableView.userInteractionEnabled = NO;
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGRect navRect = self.navigationController.view.frame;
    
    NSLog(@"bounds: %f navRect: %f newNavRect: %f", bounds.origin.y, navRect.origin.y, 100 + navRect.origin.y);
    
    CGRect newNavRect = CGRectMake(navRect.origin.x, -100.0f, navRect.size.width, navRect.size.height);
    
    [UIView animateWithDuration:0.3f animations:^{
        //window.frame = newWindowRect;
        self.navigationController.view.frame = newNavRect;
    }];
}

- (void)hideHUD
{
    _showingHUD = NO;

    self.tableView.userInteractionEnabled = YES;
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGRect navRect = self.navigationController.view.frame;
    
    NSLog(@"bounds: %f navRect: %f newNavRect: %f", bounds.origin.y, navRect.origin.y, 100 + navRect.origin.y);
    
    CGRect newNavRect = CGRectMake(navRect.origin.x, 0.0f, navRect.size.width, navRect.size.height);
    
    [UIView animateWithDuration:0.3f animations:^{
        self.navigationController.view.frame = newNavRect;
    }];
}

- (CAKeyframeAnimation *)bounceAnimation:(CGFloat)height
{
    //taken from; http://www.cocoanetics.com/2012/06/lets-bounce/
//    CGFloat offset = 128.0f * height;
//    NSArray *factors = @[@0, @60, @83, @100, @114, @124, @128, @128, @124, @114, @100, @83, @60, @32, @0, @0, @18, @28, @32, @28, @18, @0];
//    NSMutableArray *transforms;
//    
//    for (NSNumber *factor in factors) {
//        CGFloat position = factor.floatValue / offset;
//        CATransform3D transform = CATransform3DMakeTranslation(0.0f, -position, 0.0f);
//        [transforms addObject:[NSValue valueWithCATransform3D:transform]];
//    }
//    
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    animation.repeatCount = 1;
//    animation.duration = factors.count * 1.0f / 30.0f;
//    animation.fillMode = kCAFillModeForwards;
//    animation.values = transforms;
//    animation.removedOnCompletion = YES;
//    animation.autoreverses = NO;
//    
//    return animation;


    NSUInteger const kNumFactors    = 22;
    CGFloat const kFactorsPerSec    = 30.0f;
    CGFloat const kFactorsMaxValue  = 128.0f;
    CGFloat factors[kNumFactors]    = {0,  60, 83, 100, 114, 124, 128, 128, 124, 114, 100, 83, 60, 32, 0, 0, 18, 28, 32, 28, 18, 0};
    
    NSMutableArray* transforms = [NSMutableArray array];
    
    for(NSUInteger i = 0; i < kNumFactors; i++)
    {
        CGFloat positionOffset  = factors[i] / kFactorsMaxValue * height;
        CATransform3D transform = CATransform3DMakeTranslation(0.0f, -positionOffset, 0.0f);
        
        [transforms addObject:[NSValue valueWithCATransform3D:transform]];
    }
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.repeatCount           = 1;
    animation.duration              = kNumFactors * 1.0f/kFactorsPerSec;
    animation.fillMode              = kCAFillModeForwards;
    animation.values                = transforms;
    animation.removedOnCompletion   = YES; // final stage is equal to starting stage
    animation.autoreverses          = NO;
    
    return animation;
}

- (void)bounceHUD
{
    if (!_showingHUD) {
        CGFloat height = 30.0f;
        CAKeyframeAnimation *animation = [self bounceAnimation:height];
        [self.navigationController.view.layer addAnimation:animation forKey:@"bounce"];
    }
}

#pragma mark - Location Reminders Delegate

- (void)locationReminderManager:(ALLocationReminderManager *)lrm timeFromPreemptiveLocationDidChange:(NSInteger)time
{
    NSString *message = [NSString stringWithFormat:@"%@ is %d Seconds Away", [lrm.store peekReminderWithType:kALLocationReminderTypePreemptive].payload, time];
    _HUDView.HUDLabel.text = message;
}

@end
