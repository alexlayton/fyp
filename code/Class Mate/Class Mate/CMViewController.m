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
	//ALLocationReminderManager *lrm = [ALLocationReminderManager sharedManager];
    //[lrm startLocationReminders];
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
        rvc.reminders = lrm.store.preemptiveReminders;
    } else if ([segue.identifier isEqualToString:@"Location"]) {
        NSLog(@"Location");
        rvc.reminders = lrm.store.locationReminders;
    } else if ([segue.identifier isEqualToString:@"Date"]) {
        NSLog(@"Date");
        rvc.reminders = lrm.store.dateReminders;
    }
}

@end
