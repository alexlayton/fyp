//
//  CMReminderViewController.m
//  Class Mate
//
//  Created by Alex Layton on 28/11/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "CMReminderViewController.h"
#import "ALLocationReminders.h"

@implementation CMReminderViewController

@synthesize reminder = _reminder;
@synthesize dateLabel = _dateLabel;
@synthesize locationLabel = _locationLabel;
@synthesize payloadLabel = _payloadLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dateLabel.text = [NSString stringWithFormat:@"%@", _reminder.date];
    _locationLabel.text = [NSString stringWithFormat:@"Lat: %f, Lon: %f", _reminder.location.coordinate.latitude, _reminder.location.coordinate.longitude];
    _payloadLabel.text = _reminder.payload;
}

- (IBAction)deletePressed:(UIBarButtonItem *)sender
{
    NSLog(@"Delete Pressed");
}
@end
