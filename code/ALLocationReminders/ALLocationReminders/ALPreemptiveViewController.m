//
//  ALPreemptiveViewController.m
//  ALLocationReminders
//
//  Created by Alex Layton on 12/11/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "ALPreemptiveViewController.h"
#import "ALLocationReminderManager.h"
#import "ALLocationReminderStore.h"
#import "ALLocationReminder.h"

@implementation ALPreemptiveViewController

@synthesize searchTextField = _searchTextField;
@synthesize minutesTextField = _minutesTextField;
@synthesize searchLabel = _searchLabel;
@synthesize timeLabel = _timeLabel;
@synthesize reminderManager = _reminderManager;
@synthesize placemark = _placemark;

- (void)viewDidLoad
{
    [super viewDidLoad];
	_reminderManager = [ALLocationReminderManager sharedManager];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchPressed:(UIButton *)sender
{
    [_searchTextField resignFirstResponder];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:_searchTextField.text completionHandler:^(NSArray* placemarks, NSError* error){
        _placemark = [placemarks objectAtIndex:0];
        _searchLabel.text = _placemark.postalCode;
    }];
}

- (IBAction)addLocationPressed:(UIButton *)sender
{
    CLLocation *location = _placemark.location;
    NSDate *date = [[NSDate alloc] init];
    int minutes = [_minutesTextField.text integerValue];
    NSDate *newDate = [date dateByAddingTimeInterval:minutes * 60]; //20 minutes
    NSLog(@"Destination Lat: %f, Lon: %f", location.coordinate.latitude, location.coordinate.longitude);
    [_reminderManager addPreemptiveReminderAtLocation:location payload:[NSString stringWithFormat:@"Go to Destination at %@", newDate] date:newDate];
}

@end
