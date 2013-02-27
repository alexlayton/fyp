//
//  CMPlaceViewController.m
//  Class Mate
//
//  Created by Alex Layton on 13/01/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import "CMPlaceViewController.h"
#import "CMAddress.h"
#import "CMGooglePlace.h"
#import "CMFavourites.h"
#import "CMGeocodePlace.h"
#import <MapKit/MapKit.h>
#import "CMReminderAnnotation.h"
#import "ALLocationReminders.h"

@implementation CMPlaceViewController

@synthesize place = _place;
@synthesize addressLabel = _addressLabel;
@synthesize nameLabel = _nameLabel;
@synthesize mapView = _mapView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = _place.name;
    _nameLabel.text = _place.name;
	if ([_place isKindOfClass:[CMAddress class]]) {
        _addressLabel.text = [(CMAddress *)_place formattedAddress];
    } else if ([_place isKindOfClass:[CMGooglePlace class]]) { //google place
        _addressLabel.text = [(CMGooglePlace *)_place vicinity];
    } else if ([_place isKindOfClass:[CMGeocodePlace class]]) {
        //change this later!
        _addressLabel.text = [(CMGeocodePlace *)_place country];
    }
    
    CGRect mapRect = CGRectMake(0, 0, 320, 200);
    _mapView = [[MKMapView alloc] initWithFrame:mapRect];
    
    CMReminderAnnotation *annotation = [[CMReminderAnnotation alloc] initWithCoordinates:_place.location.coordinate placeName:_nameLabel.text description:_addressLabel.text];
    [_mapView addAnnotation:annotation];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    [self.tableView.tableHeaderView addSubview:_mapView];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 320, 1)];
    line.backgroundColor = [UIColor colorWithRed:0.67f green:0.67f blue:0.67f alpha:1.00f];
    [self.tableView.tableHeaderView addSubview:line];
    
    [self zoomMap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self checkFavourites];
    //[_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:NO];
}

- (void)zoomMap
{
    NSArray *annotations = _mapView.annotations;
    if (annotations.count == 0) return;
    
    MKMapPoint points[annotations.count]; //add 1 for current location
    for (int i = 0; i < annotations.count; i++) {
        CLLocationCoordinate2D coord = [(id<MKAnnotation>)[annotations objectAtIndex:i] coordinate];
        points[i] =  MKMapPointForCoordinate(coord);
    }
    
    MKPolygon *polygon = [MKPolygon polygonWithPoints:points count:annotations.count];
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

- (void)checkFavourites
{
    CMFavourites *favourites = [CMFavourites sharedFavourites];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(name == %@)", _place.name];
    NSArray *filteredArray = [favourites.favourites filteredArrayUsingPredicate:predicate];
    if (filteredArray.count > 0) {
        //change to an image;
        self.navigationItem.rightBarButtonItem.title = @"Unfav";
    }
}

- (IBAction)favouritePressed:(UIBarButtonItem *)sender {
    CMFavourites *favourites = [CMFavourites sharedFavourites];
    if ([sender.title isEqualToString:@"Fav"]) {
        [favourites.favourites addObject:_place];
        sender.title = @"Unfav";
    } else if ([sender.title isEqualToString:@"Unfav"]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(name != %@)", _place.name];
        [favourites.favourites filterUsingPredicate:predicate];
        sender.title = @"Fav";
    }
    [favourites saveData];
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
