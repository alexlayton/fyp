//
//  CMViewController.m
//  Class Mate
//
//  Created by Alex Layton on 26/11/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "CMViewController.h"
#import "ALLocationReminders.h"
#import "CMRemindersViewController.h"
#import "CMAppDelegate.h"

@implementation CMViewController

@synthesize feedbackCell = _feedbackCell;

- (void)launchFeedback
{
    [TestFlight openFeedbackView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    
    [CMAppDelegate customiseAppearance];
    
    //Load toolbar image
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
    [lrm startLocation];
    
    //testflight stuff...
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(launchFeedback)];
    [_feedbackCell addGestureRecognizer:tgr];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    BOOL locationIsEnabled = [CLLocationManager locationServicesEnabled];
    NSLog(@"enabled? %d", locationIsEnabled);
    if (!locationIsEnabled) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Need Location" message:@"Allow access to location to use this app" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
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
    NSLog(@"Start Pressed");
    //ALLocationReminderManager *lrm = [ALLocationReminderManager sharedManager];
    if ([sender.title isEqualToString:@"Start"]) {
        //[lrm startLocationReminders];
        [sender setTitle:@"Stop"];
    } else if ([sender.title isEqualToString:@"Stop"]) {
        //[lrm stopLocationReminders];
        [sender setTitle:@"Start"];
    }

}

@end
