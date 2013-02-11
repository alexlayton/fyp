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

@interface CMViewController ()

@property (nonatomic) BOOL showingHUD;

@end

@implementation CMViewController

@synthesize feedbackCell = _feedbackCell;
@synthesize HUDButton = _HUDButton;
@synthesize HUDView = _HUDView;
@synthesize showingHUD = _showingHUD;

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
    
    ALLocationReminderManager *lrm = [ALLocationReminderManager sharedManager];
    lrm.delegate = self;
    [lrm startLocation];
    
    //testflight stuff...
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(launchFeedback)];
    [_feedbackCell addGestureRecognizer:tgr];
    
    UIPanGestureRecognizer *pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    pgr.minimumNumberOfTouches = 1;
    pgr.maximumNumberOfTouches = 1;
    [self.navigationController.toolbar addGestureRecognizer:pgr];
    
    _HUDView = [[[NSBundle mainBundle] loadNibNamed:@"CMHUDView" owner:self options:nil] objectAtIndex:0];
    NSString *message = [NSString stringWithFormat:@"%@ is %d Seconds Away", [lrm.store peekReminderWithType:kALLocationReminderTypePreemptive].payload, lrm.seconds];
    _HUDView.HUDLabel.text = message;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIWindow *window = self.view.window;
    CGRect windowRect = window.frame;
    
    CGRect HUDRect = CGRectMake(windowRect.origin.x, windowRect.size.height, windowRect.size.width, 100);
    _HUDView.frame = HUDRect;
    [window addSubview:_HUDView];
    
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
    [_HUDView removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

- (IBAction)startPressed:(UIBarButtonItem *)sender
{
    if ([sender.title isEqualToString:@"Show"]) {

        if (!_showingHUD) [self showHUD];
        
        
        [sender setTitle:@"Hide"];
    } else if ([sender.title isEqualToString:@"Hide"]) {
        
        if (_showingHUD) [self hideHUD];
    
        [sender setTitle:@"Show"];
    }
}

- (void)didPan:(id)sender
{
    UIPanGestureRecognizer *pgr = sender;
    CGPoint location = [pgr locationInView:self.view];
    NSLog(@"location: %f, %f", location.x, location.y);
//    UIWindow* window = [UIApplication sharedApplication].keyWindow;
//    if (pgr.state == UIGestureRecognizerStateBegan || pgr.state == UIGestureRecognizerStateChanged) {
//        //move
//    } else if (pgr.state == UIGestureRecognizerStateEnded) {
//        //dont move and go back if not moved enough
//    }
}

- (void)showHUD
{
    _showingHUD = YES;
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    CGRect windowRect = window.frame;
    CGRect newWindowRect = CGRectMake(windowRect.origin.x, windowRect.origin.y - 100, windowRect.size.width, windowRect.size.height);
    CGRect HUDRect = self.view.frame;
    NSLog(@"hud: %f, %f, %f, %f", HUDRect.origin.x, HUDRect.origin.y, HUDRect.size.width, HUDRect.size.height);
    [UIView animateWithDuration:0.3f animations:^{
        window.frame = newWindowRect;
        //_HUDView.frame = newHUDRect;
    }];
}

- (void)hideHUD
{
    _showingHUD = NO;
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    CGRect windowRect = window.frame;
    CGRect newWindowRect = CGRectMake(windowRect.origin.x, windowRect.origin.y + 100, windowRect.size.width, windowRect.size.height);
    CGRect HUDRect = _HUDView.frame;
    NSLog(@"hud: %f, %f, %f, %f", HUDRect.origin.x, HUDRect.origin.y, HUDRect.size.width, HUDRect.size.height);
    [UIView animateWithDuration:0.3f animations:^{
        window.frame = newWindowRect;
        //_HUDView.frame = newHUDRect;
    }];
}

#pragma mark - Location Reminders Delegate

- (void)locationReminderManager:(ALLocationReminderManager *)lrm timeFromPreemptiveLocationDidChange:(NSInteger)time
{
    NSString *message = [NSString stringWithFormat:@"%@ is %d Seconds Away", [lrm.store peekReminderWithType:kALLocationReminderTypePreemptive].payload, time];
    _HUDView.HUDLabel.text = message;
}

@end
