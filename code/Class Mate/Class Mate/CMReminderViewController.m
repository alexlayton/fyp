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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CLLocation *location = _reminder.location;
    _dateLabel.text = [NSString stringWithFormat:@"%@", _reminder.date];
    _locationLabel.text = [NSString stringWithFormat:@"Lat: %f, Lon: %f", location.coordinate.latitude, location.coordinate.longitude];
    _payloadLabel.text = _reminder.payload;
    
    CMReminderAnnotation *annotation = [[CMReminderAnnotation alloc] initWithCoordinates:location.coordinate placeName:@"Place!" description:_reminder.payload];
    [_mapView addAnnotation:annotation];
}

- (IBAction)deletePressed:(UIBarButtonItem *)sender
{
    NSLog(@"Delete Pressed");
}

@end
