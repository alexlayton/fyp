//
//  ALLocationReminder.m
//  ALLocationReminders
//
//  Created by Alex Layton on 19/10/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "ALLocationReminder.h"

const ALLocationReminderType kALLocationReminderTypeLocation = @"Location";
const ALLocationReminderType kALLocationReminderTypeDate = @"Date";
const ALLocationReminderType kALLocationReminderTypePreemptive = @"Preemptive";

const ALLocationRemindersTransportType kALLocationRemindersTransportTypeWalking = @"walking";
const ALLocationRemindersTransportType kALLocationRemindersTransportTypeCycling = @"bicycling";
const ALLocationRemindersTransportType kALLocationRemindersTransportTypeDriving = @"driving";

const ALLocationRemindersRepeatType kALRepeatTypeNever = -1;
const ALLocationRemindersRepeatType kALRepeatTypeHour = 60 * 60;
const ALLocationRemindersRepeatType kALRepeatTypeDay = 60 * 60 * 24;
const ALLocationRemindersRepeatType kALRepeatTypeWeek = 60 * 60 * 7;
const ALLocationRemindersRepeatType kALRepeatTypeMonth = 1; //override this shit yo

@implementation ALLocationReminder

@synthesize location = _location;
@synthesize payload = _payload;
@synthesize date = _date;
@synthesize repeat = _repeat;
@synthesize reminderType = _reminderType;
@synthesize transport = _transport;
@synthesize minutesBefore = _minutesBefore;

+ (ALLocationReminder *)reminderWithLocation:(CLLocation *)location payload:(NSString *)payload date:(NSDate *)date
{
    ALLocationReminder *reminder = [[ALLocationReminder alloc] initWithLocation:location payload:payload date:date];
    return reminder;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_location forKey:@"location"];
    [aCoder encodeObject:_payload forKey:@"payload"];
    [aCoder encodeObject:_date forKey:@"date"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    CLLocation *location = [aDecoder decodeObjectForKey:@"location"];
    NSString *payload = [aDecoder decodeObjectForKey:@"payload"];
    NSDate *date = [aDecoder decodeObjectForKey:@"date"];
    return [self initWithLocation:location payload:payload date:date];
}

- (id)initWithLocation:(CLLocation *)location payload:(NSString *)payload date:(NSDate *)date
{
    self = [super init];
    if (self) {
        _location = location;
        _payload = payload;
        _date = date;
    }
    return self;
}

- (NSString *)description
{
    NSString *description = [NSString stringWithFormat:@"Location: %@, Payload: %@, Date: %@, Type: %@", _location, _payload, _date, _reminderType];
    return description;
}

@end
