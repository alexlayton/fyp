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

typedef NSString *ALLocationRemindersTransportType;
extern const ALLocationRemindersTransportType kALLocationRemindersTransportTypeWalking;
extern const ALLocationRemindersTransportType kALLocationRemindersTransportTypeCycling;
extern const ALLocationRemindersTransportType kALLocationRemindersTransportTypeDriving;

@protocol ALLocationReminderDelegate <NSObject>

@optional
- (void)locationReminderManager:(ALLocationReminderManager *)locationReminderManager locationDidChange:(CLLocation *)location;
- (void)locationReminderManager:(ALLocationReminderManager *)locationReminderManager reminderFired:(ALLocationReminder *)reminder;
- (void)locationReminderManager:(ALLocationReminderManager *)locationReminderManager timeFromPreemptiveLocationDidChange:(NSInteger)time;

@end

@interface ALLocationReminderManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) ALLocationReminderStore *store;
@property (nonatomic, weak) id<ALLocationReminderDelegate> delegate;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) double speed;
@property (nonatomic) BOOL remindersAreRunning;
@property (nonatomic) ALLocationRemindersTransportType transport;
@property (nonatomic) int minutesBeforeReminderTime;

+ (ALLocationReminderManager *)sharedManager;
- (void)saveData;
- (void)startLocationReminders;
- (void)stopLocationReminders;
- (void)startBackgroundLocationReminders;
- (void)stopBackgroundLocationReminders;
- (void)transitionToBackgroundLocationReminders;
- (void)transitionToForegroundLocationReminders;
- (BOOL)areRemindersRunning;
- (void)addPreemptiveReminderAtCurrentLocationWithPayload:(NSString *)payload date:(NSDate *)date;
- (void)addPreemptiveReminderAtLocation:(CLLocation *)location payload:(NSString *)payload date:(NSDate *)date;
- (void)addLocationReminderAtCurrentLocationWithPayload:(NSString *)payload date:(NSDate *)date;
- (void)addLocationReminderAtLocation:(CLLocation *)location payload:(NSString *)payload date:(NSDate *)date;
- (void)addDateBasedReminderWithPayload:(NSString *)payload date:(NSDate *)date;
- (void)fireReminder:(ALLocationReminder *)reminder;

@end
