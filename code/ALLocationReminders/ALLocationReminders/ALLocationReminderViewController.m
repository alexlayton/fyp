//
//  ALLocationReminderViewController.m
//  ALLocationReminders
//
//  Created by Alex Layton on 04/11/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "ALLocationReminderViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ALAnnotation.h"
#import "ALLocationReminderStore.h"
#import "ALLocationReminder.h"


@implementation ALLocationReminderViewController

@synthesize reminderManager = _reminderManager;
@synthesize locationLabel = _locationLabel;
@synthesize mapView = _mapView;
@synthesize timeLabel = _timeLabel;

- (id)initWithReminderManager:(ALLocationReminderManager *)reminderManager
{
    self = [super init];
    if (self) {
        _reminderManager = reminderManager;
        _reminderManager.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!_reminderManager) {
        _reminderManager = [[ALLocationReminderManager alloc] init];
        _reminderManager.delegate = self;
    }
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//
//    [geocoder geocodeAddressString:@"B62 8JW" completionHandler:^(NSArray* placemarks, NSError* error){
//        CLPlacemark *placemark = [placemarks objectAtIndex:0];
//        CLLocation *location = placemark.location;
//        NSDate *date = [[NSDate alloc] init];
//        NSDate *newDate = [date dateByAddingTimeInterval:20 * 60]; //20 minutes
//        NSLog(@"Destination Lat: %f, Lon: %f", location.coordinate.latitude, location.coordinate.longitude);
//        [_reminderManager addPreemptiveReminderAtLocation:location payload:@"Yea Bitch" date:newDate];
//        NSLog(@"Reminder: %@", [_reminderManager.store peekPreemptiveReminder]);
//    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    //maybe have an if here
    NSLog(@"Stop updating location");
    //[_reminderManager stopLocationReminders];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    _reminderManager = nil;
}

- (IBAction)trackingButtonPressed:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"Start Tracking"]) {
        _mapView.showsUserLocation = YES;
        [_reminderManager startLocationReminders];
        [sender setTitle:@"Stop Tracking" forState:UIControlStateNormal];
    } else {
        _mapView.showsUserLocation = NO;
        [_reminderManager stopLocationReminders];
        [sender setTitle:@"Start Tracking" forState:UIControlStateNormal];
    }
}

- (IBAction)notifyPressed:(UIButton *)sender
{
    NSDate *date = [[NSDate alloc] init];
    NSDate *newDate = [date dateByAddingTimeInterval:60];
    [_reminderManager addDateBasedReminderWithPayload:@"Yea Bitch" date:newDate];
}

# pragma mark - ALLocationReminderDelegate Methods

- (void)locationReminderManager:(ALLocationReminderManager *)locationReminderManager locationDidChange:(CLLocation *)location
{
    MKMapPoint point = MKMapPointForCoordinate(location.coordinate);
    double pointsPerMeter = MKMapPointsPerMeterAtLatitude(location.coordinate.latitude);
    double visibleDistance = pointsPerMeter * 500.0;
    MKMapRect rect = MKMapRectMake(point.x - visibleDistance, point.y - visibleDistance, visibleDistance * 2,visibleDistance * 2);
    [_mapView setVisibleMapRect:rect animated:YES];
//    ALAnnotation *annotation = [[ALAnnotation alloc] initWithCoordinate:location.coordinate title:@"Yea," subtitle:@"Bitch!"];
//    [_mapView addAnnotation:annotation];
    
    _locationLabel.text = [NSString stringWithFormat:@"Lat: %f, Lon: %f", location.coordinate.latitude, location.coordinate.longitude];
}

- (void)locationReminderManager:(ALLocationReminderManager *)locationReminderManager reminderFired:(ALLocationReminder *)reminder
{
    NSLog(@"Reminder Fired! Payload: %@", reminder.payload);
}

- (void)locationReminderManager:(ALLocationReminderManager *)locationReminderManager timeFromPreemptiveLocationDidChange:(NSInteger)time
{
    if (time > 0) {
        _timeLabel.text = [NSString stringWithFormat:@"%d", time];
    } else {
        _timeLabel.text = @"Not Moving";
    }
}


@end
