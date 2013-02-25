//
//  ALLocationReminderManager.h
//  ALLocationReminders
//
//  Created by Alex Layton on 23/10/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ALLocationReminder.h"

@class ALLocationReminderManager, ALLocationReminderStore;

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
@property (nonatomic) int seconds;

+ (ALLocationReminderManager *)sharedManager;
- (void)saveData;
- (void)startLocationReminders;
- (void)stopLocationReminders;
- (void)startLocation;
- (void)stopLocation;
- (BOOL)areRemindersRunning;
- (void)processLocalNotification:(UILocalNotification *)notification;
- (void)updatePreemptiveReminders;
- (void)addReminder:(ALLocationReminder *)reminder success:(void (^)(void))successBlock failure:(void (^)(void))failureBlock;

@end
