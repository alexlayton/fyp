//
//  ALLocationReminderManager.h
//  ALLocationReminders
//
//  Created by Alex Layton on 23/10/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class ALLocationReminderManager, ALLocationReminderStore, ALLocationReminder;

@protocol ALLocationReminderDelegate <NSObject>

- (void)locationReminderManager:(ALLocationReminderManager *)locationReminderManager locationDidChange:(CLLocation *)location;
- (void)locationReminderManager:(ALLocationReminderManager *)locationReminderManager reminderFired:(ALLocationReminder *)reminder;
- (void)locationReminderManager:(ALLocationReminderManager *)locationReminderManager timeFromPreemptiveLocationDidChange:(NSInteger)time;

@end

@interface ALLocationReminderManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, weak) ALLocationReminderStore *store;
@property (nonatomic, weak) id<ALLocationReminderDelegate> delegate;
@property (nonatomic, strong) CLLocation *lastLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) double *speed;
@property (nonatomic) BOOL remindersAreRunning;

+ (ALLocationReminderManager *)sharedManager;
- (id)initWithStore:(ALLocationReminderStore *)store;
- (void)startLocationReminders;
- (void)stopLocationReminders;
- (void)startBackgroundLocationReminders;
- (void)stopBackgroundLocationReminders;
- (BOOL)areRemindersRunning;
- (void)addPreemptiveReminderAtCurrentLocationWithPayload:(NSString *)payload date:(NSDate *)date;
- (void)addPreemptiveReminderAtLocation:(CLLocation *)location payload:(NSString *)payload date:(NSDate *)date;
- (void)addLocationReminderAtCurrentLocationWithPayload:(NSString *)payload date:(NSDate *)date;
- (void)addLocationReminderAtLocation:(CLLocation *)location payload:(NSString *)payload date:(NSDate *)date;
- (void)addDateBasedReminderWithPayload:(NSString *)payload date:(NSDate *)date;
- (void)fireReminder:(ALLocationReminder *)reminder;

@end
