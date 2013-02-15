//
//  CMReminderViewController.m
//  Class Mate
//
//  Created by Alex Layton on 28/11/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "CMReminderViewController.h"
#import "ALLocationReminders.h"
#import "CMReminderAnnotation.h"

@implementation CMReminderViewController

@synthesize reminder = _reminder;
@synthesize dateLabel = _dateLabel;
@synthesize locationLabel = _locationLabel;
@synthesize payloadLabel = _payloadLabel;
@synthesize mapView = _mapView;
@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CLLocation *location = _reminder.location;
    _dateLabel.text = [NSString stringWithFormat:@"%@", _reminder.date];
    _locationLabel.text = [NSString stringWithFormat:@"Lat: %f, Lon: %f", location.coordinate.latitude, location.coordinate.longitude];
    _payloadLabel.text = _reminder.payload;
    
    CMReminderAnnotation *annotation = [[CMReminderAnnotation alloc] initWithCoordinates:location.coordinate placeName:@"Place!" description:_reminder.payload];
    [_mapView addAnnotation:annotation];
    
    //change background pattern
    UIImage *patternImage = [UIImage imageNamed:@"pattern.png"];
    UIColor *pattern = [UIColor colorWithPatternImage:patternImage];
    CGRect backgroundRect = [[UIScreen mainScreen] applicationFrame];
    UIView *backgroundView = [[UIView alloc] initWithFrame:backgroundRect];
    [backgroundView setBackgroundColor:pattern];
    self.tableView.backgroundView = backgroundView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:animated];
}

- (IBAction)deletePressed:(UIBarButtonItem *)sender
{
    NSLog(@"Delete Pressed");
    if ([_delegate respondsToSelector:@selector(reminderViewController:didDeleteReminder:)]) {
        [_delegate reminderViewController:self didDeleteReminder:_reminder];
    }
}

@end
