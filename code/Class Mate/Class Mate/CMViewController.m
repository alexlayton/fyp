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
@property (nonatomic, strong) UITapGestureRecognizer *hideHUDGesture;
@property (nonatomic, strong) UIImageView *shadowView;

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
@synthesize hideHUDGesture = _hideHUDGesture;
@synthesize settingsButton = _settingsButton;
@synthesize addButton = _addButton;
@synthesize shadowView = _shadowView;

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
    UITapGestureRecognizer *testFlightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(launchFeedback)];
    [_feedbackCell addGestureRecognizer:testFlightTap];
    
    _hideHUDGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideHUD)];
    
    _HUDView = [CMHUDView hudView];
    NSLog(@"%@", [_HUDView class]);
    //NSString *message = [NSString stringWithFormat:@"%@ is %d Seconds Away", [lrm.store peekReminderWithType:kALLocationReminderTypePreemptive].payload, lrm.seconds];
    //_HUDView.HUDLabel.text = message;
    
    UIImage *shadow = [UIImage imageNamed:@"hud-shadow.png"];
    _shadowView = [[UIImageView alloc] initWithImage:shadow];
    
    CGRect navRect = self.navigationController.view.frame;
    NSLog(@"nav: %f, %f, %f, %f", navRect.origin.x, navRect.origin.y, navRect.size.width, navRect.size.height);
    NSLog(@"nav super view: %@", self.navigationController.view.superview);
    
    _showingHUD = NO;
}

- (void)updateHUD
{
    ALLocationReminderManager *lrm = [ALLocationReminderManager sharedManager];
    ALLocationReminder *preemptive = [lrm.store peekReminderWithType:kALLocationReminderTypePreemptive];
    ALLocationReminder *location = [lrm.store peekReminderWithType:kALLocationReminderTypeLocation];
    ALLocationReminder *date = [lrm.store peekReminderWithType:kALLocationReminderTypeDate];
    NSArray *reminders = @[(preemptive) ? preemptive : [NSNull null], (location) ? location : [NSNull null], (date) ? date : [NSNull null]];
    NSArray *labels = _HUDView.labels;
    NSLog(@"Labels %@", labels);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    
    int labelPosition = 0;
    for (int i = 0; i < reminders.count; i++) {
        if ([reminders objectAtIndex:i] != [NSNull null]) {
            ALLocationReminder *reminder = [reminders objectAtIndex:i];
            dateFormatter.timeStyle = ([reminder.reminderType isEqualToString:kALLocationReminderTypeLocation]) ? NSDateFormatterNoStyle : NSDateFormatterShortStyle;
            NSString *dateString = [dateFormatter stringFromDate:reminder.date];
            NSString *header = [NSString stringWithFormat:@"%@ - %@", reminder.payload, reminder.locationString];
            NSString *subHeader = [NSString stringWithFormat:@"%@ - %@", reminder.reminderType, dateString];
            
            UILabel *headerLabel = [labels objectAtIndex:labelPosition];
            UILabel *subLabel = [labels objectAtIndex:labelPosition + 1];
            
            headerLabel.text = header;
            subLabel.text = subHeader;
            
            labelPosition += 2;
        }
    }
    //no reminders
    if (labelPosition == 0) {
        UILabel *headerLabel = [labels objectAtIndex:0];
        UILabel *subLabel = [labels objectAtIndex:1];
        headerLabel.text = @"No Reminders";
        subLabel.text = @"Try adding one.";
        labelPosition += 2;
    }
    if (labelPosition < labels.count) {
        for (int i = labelPosition; i < labels.count; i += 2) {
            UILabel *headerLabel = [labels objectAtIndex:i];
            UILabel *subLabel = [labels objectAtIndex:i + 1];
            headerLabel.text = @"";
            subLabel.text = @"";
        }
    }
}

- (void)hideCells
{
    for (int i = 0; i < [self.tableView numberOfRowsInSection:0]; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.hidden = YES;
    }
    for (int i = 0; i < [self.tableView numberOfRowsInSection:1]; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.hidden = YES;
    }
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
    
    //add shadow to navigation view
    CGRect shadowFrame = _shadowView.frame;
    shadowFrame.origin.y = self.navigationController.view.frame.size.height;
    _shadowView.frame = shadowFrame;
    [self.navigationController.view addSubview:_shadowView];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIWindow *window = self.view.window;
    CGRect windowRect = window.frame;
    
    CGRect HUDRect = CGRectMake(windowRect.origin.x, windowRect.size.height - 150, windowRect.size.width, 150);
    _HUDView.frame = HUDRect;
    [window insertSubview:_HUDView belowSubview:self.navigationController.view];
    [self updateHUD];
    
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
    [_shadowView removeFromSuperview];
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
    CGFloat diffY = toY - fromY;
    CGFloat newY = navRect.origin.y + diffY;
    
    if (pgr.state == UIGestureRecognizerStateBegan) {
        fromY = toY;
    } else if (pgr.state == UIGestureRecognizerStateChanged) {
        if (newY <= 0.0f && newY >= -150.0f) {
            CGRect newNavRect = CGRectMake(navRect.origin.x, newY, navRect.size.width, navRect.size.height);
            [UIView animateWithDuration:0.001f animations:^{
                nav.view.frame = newNavRect;
            }];
        }
    } else if (pgr.state == UIGestureRecognizerStateEnded) {
        NSLog(@"New Y: %f", newY);
        (newY <= 0.0f && newY >= -75.0f) ? [self hideHUD] : [self showHUD];
    }
}

- (void)showHUD
{
    _showingHUD = YES;
    
    self.tableView.userInteractionEnabled = NO;
    _settingsButton.enabled = NO;
    
    //add gesture recognizer
    [self.navigationController.view addGestureRecognizer:_hideHUDGesture];
    
    CGRect navRect = self.navigationController.view.frame;
    CGRect newNavRect = CGRectMake(navRect.origin.x, -150.0f, navRect.size.width, navRect.size.height);
    
    CGFloat diffY = newNavRect.origin.y - navRect.origin.y;
    CGFloat duration = ABS(diffY) * 0.005;
    
    [UIView animateWithDuration:duration animations:^{
        //window.frame = newWindowRect;
        self.navigationController.view.frame = newNavRect;
    }];
}

- (void)hideHUD
{
    _showingHUD = NO;

    self.tableView.userInteractionEnabled = YES;
    _settingsButton.enabled = YES;
    
    //remove gesture recognizer
    [self.navigationController.view removeGestureRecognizer:_hideHUDGesture];
    
    CGRect navRect = self.navigationController.view.frame;
    CGRect newNavRect = CGRectMake(navRect.origin.x, 0.0f, navRect.size.width, navRect.size.height);
    
    CGFloat diffY = newNavRect.origin.y - navRect.origin.y;
    NSLog(@"Abs DiffY: %f", ABS(diffY));
    CGFloat duration = ABS(diffY) * 0.005;
    
    [UIView animateWithDuration:duration animations:^{
        self.navigationController.view.frame = newNavRect;
    }];
}



- (CAKeyframeAnimation *)bounceAnimation:(CGFloat)height
{
    //taken from; http://www.cocoanetics.com/2012/06/lets-bounce/

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
//    NSString *message = [NSString stringWithFormat:@"%@ is %d Seconds Away", [lrm.store peekReminderWithType:kALLocationReminderTypePreemptive].payload, time];
//    ALLocationReminder *reminder = [lrm.store peekReminderWithType:kALLocationReminderTypePreemptive];
//    _HUDView.PreemptiveHeaderLabel = [NSString stringWithFormat:@"%@, %@", reminder.payload, reminder.locationString];
//    _HUDView.preemptiveSubLabel.text = message;
 }

- (IBAction)testPressed:(UIBarButtonItem *)sender
{
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in notifications) {
        NSLog(@"Notification: %@, Date: %@", notification.alertBody, notification.fireDate);
    }
}

@end
