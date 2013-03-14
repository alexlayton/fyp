//
//  CMMapViewController.m
//  Class Mate
//
//  Created by Alex Layton on 30/11/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "CMMapViewController.h"
#import "CMReminderAnnotation.h"
#import "ALLocationReminders.h"
#import <CoreLocation/CoreLocation.h>
#import "CMReminderViewController.h"

@interface CMMapViewController ()

@property (nonatomic, strong) CMReminderAnnotation *lastSelectedAnnotation;

@end

@implementation CMMapViewController

@synthesize mapView = _mapView;
@synthesize lastSelectedAnnotation = _lastSelectedAnnotation;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _mapView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:animated];
    [self.navigationController setToolbarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:NO];
    [self performSelectorInBackground:@selector(loadMapAnnotations) withObject:nil];
}

- (void)dealloc
{
    _mapView.delegate = nil;
}

- (void)loadMapAnnotations
{
    ALLocationReminderManager *lrm = [ALLocationReminderManager sharedManager];
    NSArray *preemptive = lrm.store.preemptiveReminders;
    NSArray *location = lrm.store.locationReminders;
    NSArray *date = lrm.store.dateReminders;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    
    for (ALLocationReminder *reminder in preemptive) {
        NSString *title = [NSString stringWithFormat:@"Preemptive - %@", reminder.payload];
        NSString *dateString = [dateFormatter stringFromDate:reminder.date];
        CMReminderAnnotation *annotation = [[CMReminderAnnotation alloc] initWithCoordinates:reminder.location.coordinate placeName:title description:dateString];
        annotation.reminder = reminder;
        [_mapView addAnnotation:annotation];
    }
    
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    for (ALLocationReminder *reminder in location) {
        NSString *title = [NSString stringWithFormat:@"Location - %@", reminder.payload];
        NSString *dateString = [dateFormatter stringFromDate:reminder.date];
        CMReminderAnnotation *annotation = [[CMReminderAnnotation alloc] initWithCoordinates:reminder.location.coordinate placeName:title description:dateString];
        annotation.reminder = reminder;
        [_mapView addAnnotation:annotation];
    }
    
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    for (ALLocationReminder *reminder in date) {
        NSString *title = [NSString stringWithFormat:@"Date - %@", reminder.payload];
        NSString *dateString = [dateFormatter stringFromDate:reminder.date];
        CMReminderAnnotation *annotation = [[CMReminderAnnotation alloc] initWithCoordinates:reminder.location.coordinate placeName:title description:dateString];
        annotation.reminder = reminder;
        [_mapView addAnnotation:annotation];
    }
    
    [self performSelectorOnMainThread:@selector(zoomMap) withObject:nil waitUntilDone:NO];
    
}

- (void)zoomMap
{
    //taken from http://brianreiter.org/2012/03/02/size-an-mkmapview-to-fit-its-annotations-in-ios-without-futzing-with-coordinate-systems/
    
    CLLocation *currentLocation = [[ALLocationReminderManager sharedManager] currentLocation];
    
    NSArray *annotations = _mapView.annotations;
    if (annotations.count == 0) return;
    
    MKMapPoint points[annotations.count + 1]; //add 1 for current location
    for (int i = 0; i < annotations.count; i++) {
        CLLocationCoordinate2D coord = [(id<MKAnnotation>)[annotations objectAtIndex:i] coordinate];
        points[i] =  MKMapPointForCoordinate(coord);
    }
    
    //add current location to zoom level!
    points[annotations.count] = MKMapPointForCoordinate(currentLocation.coordinate);
    
    MKPolygon *polygon = [MKPolygon polygonWithPoints:points count:annotations.count + 1];
    MKMapRect mapRect = [polygon boundingMapRect];
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    //region.center = currentLocation.coordinate;
    
    double latDelta = region.span.latitudeDelta * 1.15;
    double lonDelta = region.span.longitudeDelta * 1.15;
    region.span.latitudeDelta = (latDelta > 360) ? 360 : latDelta;
    region.span.longitudeDelta = (lonDelta > 360) ? 360 : lonDelta;
    
    if (region.span.latitudeDelta < 0.014) region.span.latitudeDelta = 0.014;
    if (region.span.longitudeDelta < 0.014) region.span.longitudeDelta = 0.014;
    
    if (annotations.count == 1) {
        region.span.latitudeDelta = 0.014;
        region.span.longitudeDelta = 0.014;
    }
    
    NSLog(@"Map View: %@", _mapView);
    [_mapView setRegion:region animated:YES];
}

#pragma mark - Map Delegate

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    for (MKAnnotationView *view in views) {
        if ([view.annotation isKindOfClass:[CMReminderAnnotation class]]) {
            view.rightCalloutAccessoryView = button;
        }
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    CMReminderAnnotation *annotation = view.annotation;
    _lastSelectedAnnotation = annotation;
    CMReminderViewController *rvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ReminderViewController"];
    rvc.reminder = annotation.reminder;
    rvc.delegate = self;
    [self.navigationController pushViewController:rvc animated:YES];
}

#pragma mark - Reminder View Delegate

- (void)reminderViewController:(CMReminderViewController *)rvc didDeleteReminder:(ALLocationReminder *)reminder
{
    [_mapView removeAnnotation:_lastSelectedAnnotation];
    ALLocationReminderManager *lrm = [ALLocationReminderManager sharedManager];
    if ([_lastSelectedAnnotation.title hasPrefix:@"Preemptive"]) {
        [lrm.store.preemptiveReminders removeObject:_lastSelectedAnnotation.reminder];
        [[ALLocationReminderManager sharedManager] updatePreemptiveReminders];
    } else if ([_lastSelectedAnnotation.title hasPrefix:@"Location"]) {
        [lrm.store.locationReminders removeObject:_lastSelectedAnnotation.reminder];
    } else if ([_lastSelectedAnnotation.title hasPrefix:@"Date"]) {
        [lrm.store.dateReminders removeObject:_lastSelectedAnnotation.reminder];
        NSDate *newDate = [_lastSelectedAnnotation.reminder.date dateByAddingTimeInterval:-60 * _lastSelectedAnnotation.reminder.minutesBefore];
        NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
        for (UILocalNotification *notification in notifications) {
            if ([notification.fireDate isEqualToDate:newDate]) {
                NSLog(@"Removed Local Notification!");
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
