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
{
    BOOL update;
}

@synthesize store = _store;
@synthesize delegate = _delegate;
@synthesize lastLocation = _lastLocation;

- (id)initWithStore:(ALLocationReminderStore *)store
{
    self = [super init];
    if (self) {
        _store = store;
    }
    return self;
}

- (id)init
{
    return [self initWithStore:[ALLocationReminderStore sharedStore]];
}

- (void)addReminderAtCurrentLocationWithPayload:(NSString *)payload date:(NSDate *)date
{
    if (_lastLocation) {
        ALLocationReminder *reminder = [[ALLocationReminder alloc] initWithLocation:_lastLocation payload:payload date:date];
        [_store pushReminder:reminder];
    }
}

# pragma mark - CLLocation Delegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"Updated location");
    CLLocation *currentLocation = [locations lastObject];
    if ([_store peekReminder]) {
        ALLocationReminder *reminder = [_store peekReminder];
        CLLocationDistance distance = [reminder.location distanceFromLocation:currentLocation];
        NSDate *today = [[NSDate alloc] init];
        NSInteger days = [self daysBetweensDate:reminder.date andDate:today];
        
        if (distance < 50 && days == 0) {
            //within 50 metres and on the same day
            NSLog(@"Reminder should be fired");
            //pop reminder
        }
    }
    _lastLocation = currentLocation;
}

# pragma mark - Date Stuff

- (NSInteger)daysBetweensDate:(NSDate *)date1 andDate:(NSDate *)date2
{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *components = [calender components:NSDayCalendarUnit fromDate:date1 toDate:date2 options:0];
    return [components day];
}

@end
