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

@end

@interface ALLocationReminderManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, weak) ALLocationReminderStore *store;
@property (nonatomic, weak) id<ALLocationReminderDelegate> delegate;
@property (nonatomic, strong) CLLocation *lastLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;

- (id)initWithStore:(ALLocationReminderStore *)store;
- (void)startLocationReminders;
- (void)stopLocationReminders;
- (void)addReminderAtCurrentLocationWithPayload:(NSString *)payload date:(NSDate *)date;

@end
