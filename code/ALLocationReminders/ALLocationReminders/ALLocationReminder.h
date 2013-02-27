//
//  ALLocationReminder.h
//  ALLocationReminders
//
//  Created by Alex Layton on 19/10/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NSString *ALLocationReminderType;
extern const ALLocationReminderType kALLocationReminderTypeLocation;
extern const ALLocationReminderType kALLocationReminderTypeDate;
extern const ALLocationReminderType kALLocationReminderTypePreemptive;

typedef NSString *ALLocationRemindersTransportType;
extern const ALLocationRemindersTransportType kALLocationRemindersTransportTypeWalking;
extern const ALLocationRemindersTransportType kALLocationRemindersTransportTypeCycling;
extern const ALLocationRemindersTransportType kALLocationRemindersTransportTypeDriving;

typedef int ALLocationRemindersRepeatType;
extern const ALLocationRemindersRepeatType kALRepeatTypeNever;
extern const ALLocationRemindersRepeatType kALRepeatTypeHour;
extern const ALLocationRemindersRepeatType kALRepeatTypeDay;
extern const ALLocationRemindersRepeatType kALRepeatTypeWeek;
extern const ALLocationRemindersRepeatType kALRepeatTypeMonth;

@interface ALLocationReminder : NSObject <NSCoding>

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *payload;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic) int minutesBefore;
@property (nonatomic) ALLocationRemindersRepeatType repeat;
@property (nonatomic) ALLocationReminderType reminderType;
@property (nonatomic) ALLocationRemindersTransportType transport;
@property (nonatomic, strong) NSString *locationString;

+ (ALLocationReminder *)reminderWithLocation:(CLLocation *)location payload:(NSString *)payload date:(NSDate *)date;
- (id)initWithLocation:(CLLocation *)location payload:(NSString *)payload date:(NSDate *)date;

@end
