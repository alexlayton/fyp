//
//  ALLocationReminderManager.h
//  ALLocationReminders
//
//  Created by Alex Layton on 23/10/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class ALLocationReminderStore, ALLocationReminder;

@protocol ALLocationReminderDelegate <NSObject>

//think this is how a protocol works right?
- (void)reminderFired:(ALLocationReminder *)reminder;

@end

@interface ALLocationReminderManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, weak) ALLocationReminderStore *store;
@property (nonatomic, weak) id<ALLocationReminderDelegate> delegate;
@property (nonatomic, strong) CLLocation *lastLocation;

- (id)initWithStore:(ALLocationReminderStore *)store;
- (void)addReminderAtCurrentLocationWithPayload:(NSString *)payload date:(NSDate *)date;

@end
