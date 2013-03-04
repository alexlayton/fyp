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
@synthesize navigateButton = _navigateButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CLLocation *location = _reminder.location;
    _locationLabel.text = _reminder.locationString;
    _payloadLabel.text = _reminder.payload;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = ([_reminder.reminderType isEqualToString:kALLocationReminderTypeLocation]) ? NSDateFormatterNoStyle : NSDateFormatterShortStyle;
    _dateLabel.text = [dateFormatter stringFromDate:_reminder.date];
    
    //change background pattern
    UIImage *patternImage = [UIImage imageNamed:@"pattern.png"];
    UIColor *pattern = [UIColor colorWithPatternImage:patternImage];
    CGRect backgroundRect = [[UIScreen mainScreen] applicationFrame];
    UIView *backgroundView = [[UIView alloc] initWithFrame:backgroundRect];
    [backgroundView setBackgroundColor:pattern];
    self.tableView.backgroundView = backgroundView;
    
    CGRect mapRect = CGRectMake(0, 0, 320, 200);
    _mapView = [[MKMapView alloc] initWithFrame:mapRect];
    
    NSString *title = [NSString stringWithFormat:@"%@ - %@", [_reminder.reminderType capitalizedString], _reminder.payload];
    NSString *dateString = [dateFormatter stringFromDate:_reminder.date];
    CMReminderAnnotation *annotation = [[CMReminderAnnotation alloc] initWithCoordinates:location.coordinate placeName:title description:dateString];
    [_mapView addAnnotation:annotation];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    [self.tableView.tableHeaderView addSubview:_mapView];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 320, 1)];
    line.backgroundColor = [UIColor colorWithRed:0.67f green:0.67f blue:0.67f alpha:1.00f];
    [self.tableView.tableHeaderView addSubview:line];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:animated];
    [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self zoomMap];
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

- (IBAction)deletePressed:(UIBarButtonItem *)sender
{
    NSLog(@"Delete Pressed");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Reminder" message:@"Are you sure you want to delete the reminder?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    [alert show];
}

- (IBAction)navigatePressed:(UIButton *)sender
{
    ALLocationReminderManager *lrm = [ALLocationReminderManager sharedManager];
    CLLocation *currentLocation = lrm.currentLocation;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"navigation"] isEqualToString:@"Google Maps"]) {
        [self loadGoogleMapsWithLocation:currentLocation];
    } else {
        [self loadAppleMapsWithLocation:currentLocation];
    }
}

- (void)loadGoogleMapsWithLocation:(CLLocation *)currentLocation;
{
    NSString *startAddress = [NSString stringWithFormat:@"%f,%f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude];
    NSString *destinationAddress = [NSString stringWithFormat:@"%f,%f", _reminder.location.coordinate.latitude, _reminder.location.coordinate.longitude];
    NSString *transport = ([_reminder.transport isEqualToString:kALLocationRemindersTransportTypeCycling]) ? @"walking" : _reminder.transport;
    NSString *urlString = [NSString stringWithFormat:@"comgooglemaps://?saddr=%@&daddr=%@&directionsmode=%@", startAddress, destinationAddress, transport];
    NSLog(@"UrlString: %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)loadAppleMapsWithLocation:(CLLocation *)currentLocation;
{
    NSString *startAddress = [NSString stringWithFormat:@"%f,%f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude];
    NSString *destinationAddress = [NSString stringWithFormat:@"%f,%f", _reminder.location.coordinate.latitude, _reminder.location.coordinate.longitude];
    NSString *urlString = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=%@&daddr=%@&", startAddress, destinationAddress];
    NSLog(@"UrlString: %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Delete"]) {
        if ([_delegate respondsToSelector:@selector(reminderViewController:didDeleteReminder:)]) {
            [_delegate reminderViewController:self didDeleteReminder:_reminder];
        }
    }
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
    CGRect headerRect = self.tableView.tableHeaderView.frame;
    headerRect.origin.y += offset;
    headerRect.size.height -= offset;
    _mapView.frame = headerRect;
}

@end
