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

@implementation CMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];    
    
    UIImage *patternImage = [UIImage imageNamed:@"pattern.png"];
    UIColor *pattern = [UIColor colorWithPatternImage:patternImage];
    CGRect backgroundRect = [[UIScreen mainScreen] applicationFrame];
    UIView *backgroundView = [[UIView alloc] initWithFrame:backgroundRect];
    [backgroundView setBackgroundColor:pattern];
    self.tableView.backgroundView = backgroundView;
    
    [ALLocationReminderManager sharedManager]; //init shared manager
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
    }
}

- (IBAction)startPressed:(UIBarButtonItem *)sender
{
    NSLog(@"Start Pressed");
    ALLocationReminderManager *lrm = [ALLocationReminderManager sharedManager];
    if ([sender.title isEqualToString:@"Start"]) {
        [lrm startLocationReminders];
        [sender setTitle:@"Stop"];
    } else if ([sender.title isEqualToString:@"Stop"]) {
        [lrm stopLocationReminders];
        [sender setTitle:@"Start"];
    }

}

@end
