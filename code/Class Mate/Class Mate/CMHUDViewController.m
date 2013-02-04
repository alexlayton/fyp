//
//  CMHUDViewController.m
//  Class Mate
//
//  Created by Alex Layton on 04/02/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import "CMHUDViewController.h"


@implementation CMHUDViewController

@synthesize fromLabel = _fromLabel;
@synthesize toLabel = _toLabel;
@synthesize secondsLabel = _secondsLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    ALLocationReminderManager *lrm = [ALLocationReminderManager sharedManager];
    lrm.delegate = self;
    ALLocationReminder *reminder = [lrm.store peekReminderWithType:kALLocationReminderTypePreemptive];
    _toLabel.text = reminder.location.description;
    //_secondsLabel.text = [NSString stringWithFormat:@"%d Seconds", ]; //some seconds property
}

#pragma mark - Location Reminder Delegate

- (void)locationReminderManager:(ALLocationReminderManager *)locationReminderManager timeFromPreemptiveLocationDidChange:(NSInteger)seconds
{
    _secondsLabel.text = [NSString stringWithFormat:@"%d Seconds", seconds];
}

@end
