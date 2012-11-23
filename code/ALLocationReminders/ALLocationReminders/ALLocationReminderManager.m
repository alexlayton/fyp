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
@synthesize remindersAreRunning = _remindersAreRunning;
@synthesize speed = _speed;

# pragma mark - initialisers

+ (ALLocationReminderManager *)sharedManager
{
    static ALLocationReminderManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[ALLocationReminderManager alloc] init];
    });
    return sharedManager;
}

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
    _remindersAreRunning = YES;
    [_locationManager startUpdatingLocation];
}

- (void)stopLocationReminders
{
    _remindersAreRunning = NO;
    [_locationManager stopUpdatingLocation];
}

- (void)startBackgroundLocationReminders
{
    _remindersAreRunning = YES;
    [_locationManager startMonitoringSignificantLocationChanges];
}

- (void)stopBackgroundLocationReminders
{
    _remindersAreRunning = NO;
    [_locationManager stopMonitoringSignificantLocationChanges];
}

- (BOOL)areRemindersRunning
{
    //fix...
    return NO;
}

- (void)addPreemptiveReminderAtCurrentLocationWithPayload:(NSString *)payload date:(NSDate *)date
{
    ALLocationReminder *reminder = [ALLocationReminder reminderWithLocation:_lastLocation payload:payload date:date];
        [_store pushReminder:reminder type:kALLocationReminderTypePreemptive];
}

- (void)addPreemptiveReminderAtLocation:(CLLocation *)location payload:(NSString *)payload date:(NSDate *)date
{
    ALLocationReminder *reminder = [ALLocationReminder reminderWithLocation:location payload:payload date:date];
    [_store pushReminder:reminder type:kALLocationReminderTypePreemptive];
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
    //if (currentLocation.speed > 0) _speed = (double) currentLocation.speed;
    
    [self processLocationReminder:currentLocation];
    
    //process current preemptive reminder
    [self processPreemptiveReminder:currentLocation];
    [self printPreempriveReminders];
    
    _lastLocation = currentLocation;
    [_delegate locationReminderManager:self locationDidChange:currentLocation];
}

- (void)processPreemptiveReminder:(CLLocation *)currentLocation
{
    ALLocationReminder *reminder = [_store peekReminderWithType:kALLocationReminderTypePreemptive];
    if (reminder) {
        int time = [self timeBetweenLocationFrom:currentLocation to:reminder.location];
        NSLog(@"Seconds away: %d", time);
        NSDate *projectedDate = [NSDate dateWithTimeIntervalSinceNow:time]; //projected time
        NSDate *goalDate = [reminder.date dateByAddingTimeInterval:-60 * 5]; //remove 5 minutes for now
        
        if ([projectedDate compare:goalDate] == NSOrderedDescending) {
            NSLog(@"Fire the reminder");
            [self fireReminder:reminder];
            [_store popReminderWithType:kALLocationReminderTypePreemptive];
        }
        //if time has changed call this delegate method
        [_delegate locationReminderManager:self timeFromPreemptiveLocationDidChange:time];
    }
}

- (void)google
{
    
}

- (void)processLocationReminder:(CLLocation *)currentLocation
{
    NSMutableArray *reminders = _store.locationReminders;
    if (reminders) {
        CLLocationCoordinate2D currentCoord = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
        for (ALLocationReminder *reminder in reminders) {
            CLRegion *region = [self makeRegionFromLocation:reminder.location];
            if ([region containsCoordinate:currentCoord]) {
                [self fireReminder:reminder]; //fire reminder for now
                [reminders removeObject:reminder];
            }
        }
    }
}

- (void)printPreempriveReminders
{
    NSMutableArray *reminders = _store.preemptiveReminders;
    if (reminders.count > 0) {
        for (int i = 0; i < reminders.count; i++) {
            ALLocationReminder *reminder = [reminders objectAtIndex:i];
            NSLog(@"Reminder %d, with Payload %@", i, reminder.payload);
        }
    }
}

- (CLRegion *)makeRegionFromLocation:(CLLocation *)location
{
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    CLLocationDistance radius = 10.0; //10 metres
    CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:coord radius:radius identifier:@"region"];
    return region;
}
            
- (void)fireReminder:(ALLocationReminder *)reminder
{
    //firing!
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    if (state == UIApplicationStateActive) { //alert
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder" message:reminder.payload delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    } else { //notification
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = reminder.payload;
        notification.fireDate = [[NSDate date] dateByAddingTimeInterval:1];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
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
    if (speed <= 0) return (int) distance / 2; //assumes 2m/s if not moving
    int time = (int) distance / speed;
    NSLog(@"Distance: %f / Speed: %f = Time: %d", distance, speed, time);
    return time;
    
}

@end
