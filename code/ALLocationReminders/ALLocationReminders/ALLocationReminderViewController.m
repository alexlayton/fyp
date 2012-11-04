//
//  ALLocationReminderViewController.m
//  ALLocationReminders
//
//  Created by Alex Layton on 04/11/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "ALLocationReminderViewController.h"
#import <MapKit/MapKit.h>
#import "ALAnnotation.h"

@implementation ALLocationReminderViewController

@synthesize reminderManager = _reminderManager;
@synthesize locationLabel = _locationLabel;
@synthesize mapView = _mapView;

- (id)initWithReminderManager:(ALLocationReminderManager *)reminderManager
{
    self = [super init];
    if (self) {
        _reminderManager = reminderManager;
        _reminderManager.delegate = self;
        _mapView.delegate = self;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


@end
