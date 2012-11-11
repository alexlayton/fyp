//
//  ALLocationReminderManager.m
//  ALLocationReminders
//
//  Created by Alex Layton on 23/10/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "ALLocationReminderManager.h"
#import "ALLocationReminderStore.h"
#import "ALLocationReminder.h"

@implementation ALLocationReminderManager

@synthesize store = _store;
@synthesize delegate = _delegate;
@synthesize lastLocation = _lastLocation;
@synthesize locationManager = _locationManager;

# pragma mark - initialisers

- (id)initWithStore:(ALLocationReminderStore *)store
{
    self = [super init];
    if (self) {
        _store = store;
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _locationManager.distanceFilter = 10;
        NSLog(@"Designated Initialiser...");
    }
    return self;
}

- (id)init
{
    return [self initWithStore:[ALLocationReminderStore sharedStore]];
}

- (void)startLocationReminders
{
    NSLog(@"Starting reminders");
    [_locationManager startUpdatingLocation];
}

- (void)stopLocationReminders
{
    [_locationManager stopUpdatingLocation];
}

- (void)addPreemptiveReminderAtCurrentLocationWithPayload:(NSString *)payload date:(NSDate *)date
{
    ALLocationReminder *reminder = [ALLocationReminder reminderWithLocation:_lastLocation payload:payload date:date];
    [_store pushPreemptiveReminder:reminder]; //change later...
}

- (void)addPreemptiveReminderAtLocation:(CLLocation *)location payload:(NSString *)payload date:(NSDate *)date
{
    ALLocationReminder *reminder = [ALLocationReminder reminderWithLocation:location payload:payload date:date];
    [_store pushPreemptiveReminder:reminder];
}

- (void)addLocationReminderAtCurrentLocationWithPayload:(NSString *)payload date:(NSDate *)date
{
    ALLocationReminder *reminder = [ALLocationReminder reminderWithLocation:_lastLocation payload:payload date:date];
    [_store pushReminder:reminder type:kALLocationReminderTypeLocation];
}

- (void)addLocationReminderAtLocation:(CLLocation *)location payload:(NSString *)payload date:(NSDate *)date
{
    ALLocationReminder *reminder = [ALLocationReminder reminderWithLocation:location payload:payload date:date];
    [_store pushReminder:reminder type:kALLocationReminderTypeLocation];
}

- (void)addDateBasedReminderWithPayload:(NSString *)payload date:(NSDate *)date
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = payload;
    notification.fireDate = date;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

# pragma mark - CLLocation Delegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"Updated location");
    CLLocation *currentLocation = [locations lastObject];
//    if ([_store peekReminder]) {
//        ALLocationReminder *reminder = [_store peekReminder];
//        CLLocationDistance distance = [reminder.location distanceFromLocation:currentLocation];
//        NSDate *today = [[NSDate alloc] init];
//        NSInteger days = [self daysBetweensDate:reminder.date andDate:today];
//        if (distance < 50 && days == 0) {
//            //within 50 metres and on the same day
//            NSLog(@"Reminder should be fired");
//            //pop reminder
//        }
//    }
    
    ALLocationReminder *reminder = [_store peekPreemptiveReminder];
    if (reminder) {
        int time = [self timeBetweenLocationFrom:currentLocation to:reminder.location];
        //if not -tive call this delegate method
        [_delegate locationReminderManager:self timeFromPreemptiveLocationDidChange:time];
    }
    
    _lastLocation = currentLocation;
    [_delegate locationReminderManager:self locationDidChange:currentLocation];
}

# pragma mark - Date Stuff

- (NSInteger)daysBetweensDate:(NSDate *)date1 andDate:(NSDate *)date2
{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *components = [calender components:NSDayCalendarUnit fromDate:date1 toDate:date2 options:0];
    return [components day];
}

- (NSInteger)timeBetweenLocationFrom:(CLLocation *)from to:(CLLocation *)to
{
    //time (seconds) = distance (metres) / speed (metres per second)
    double speed = from.speed;
    double distance = [to distanceFromLocation:from];
    int time = (int) distance / speed;
    NSLog(@"Distance: %f / Speed: %f = Time: %d", distance, speed, time);
    return time;
    
}

@end
