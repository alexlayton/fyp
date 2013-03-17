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
const ALLocationRemindersRepeatType kALRepeatTypeWeek = 60 * 60 * 24 * 7;
const ALLocationRemindersRepeatType kALRepeatTypeMonth = 1; //override this shit yo

@implementation ALLocationReminder

@synthesize location = _location;
@synthesize payload = _payload;
@synthesize date = _date;
@synthesize repeat = _repeat;
@synthesize reminderType = _reminderType;
@synthesize transport = _transport;
@synthesize minutesBefore = _minutesBefore;
@synthesize locationString = _locationString;

+ (ALLocationReminder *)reminderWithLocation:(CLLocation *)location payload:(NSString *)payload date:(NSDate *)date
{
    ALLocationReminder *reminder = [[ALLocationReminder alloc] initWithLocation:location payload:payload date:date];
    return reminder;
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

- (id)initWithUserInfo:(NSDictionary *)userInfo
{
    self = [super init];
    if (self) {
        [self loadUserInfo:userInfo];
    }
    return self;
}

- (void)loadUserInfo:(NSDictionary *)userInfo
{
    _payload = [userInfo objectForKey:@"payload"];
    _date = [userInfo objectForKey:@"date"];
    CGFloat lat = [[userInfo objectForKey:@"lat"] floatValue];
    CGFloat lon = [[userInfo objectForKey:@"lon"] floatValue];
    _location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    _repeat = [[userInfo objectForKey:@"repeat"] intValue];
    _reminderType = [userInfo objectForKey:@"reminderType"];
    _transport = [userInfo objectForKey:@"transport"];
    _minutesBefore = [[userInfo objectForKey:@"minutes"] intValue];
    _locationString = [userInfo objectForKey:@"locationString"];
}

- (NSDictionary *)userInfoForReminder
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (_date) [dict setObject:_date.copy forKey:@"date"];
    if (_payload) [dict setObject:_payload.copy forKey:@"payload"];
    if (_location) {
        NSNumber *lat = [NSNumber numberWithFloat:_location.coordinate.latitude];
        NSNumber *lon = [NSNumber numberWithFloat:_location.coordinate.longitude];
        [dict setObject:lat forKey:@"lat"];
        [dict setObject:lon forKey:@"lon"];
    }
    if (_reminderType) [dict setObject:_reminderType.copy forKey:@"reminderType"];
    if (_transport) [dict setObject:_transport.copy forKey:@"transport"];
    if (_repeat) {
        NSNumber *repeat = [NSNumber numberWithInt:_repeat];
        [dict setObject:repeat forKey:@"repeat"];
    }
    if (_minutesBefore) {
        NSNumber *minutesBefore = [NSNumber numberWithInt:_minutesBefore];
        [dict setObject:minutesBefore forKey:@"minutes"];
    }
    if (_locationString) [dict setObject:_locationString.copy forKey:@"locationString"];
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:dict];
    return userInfo;
}

- (NSString *)description
{
    NSString *description = [NSString stringWithFormat:@"Location: %@, Payload: %@, Date: %@, Type: %@", _location, _payload, _date, _reminderType];
    return description;
}

- (id)copy
{
    ALLocationReminder *reminder = [[ALLocationReminder alloc] init];
    reminder.payload = _payload.copy;
    reminder.date = _date.copy;
    reminder.location = _location.copy;
    reminder.repeat = _repeat;
    reminder.reminderType = _reminderType.copy;
    reminder.transport = _transport.copy;
    reminder.minutesBefore = _minutesBefore;
    reminder.locationString = _locationString.copy;
    return reminder;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_location forKey:@"location"];
    [aCoder encodeObject:_payload forKey:@"payload"];
    [aCoder encodeObject:_date forKey:@"date"];
    [aCoder encodeInt:_repeat forKey:@"repeat"];
    [aCoder encodeObject:_reminderType forKey:@"reminderType"];
    [aCoder encodeObject:_transport forKey:@"transport"];
    [aCoder encodeInt:_minutesBefore forKey:@"minutesBefore"];
    [aCoder encodeObject:_locationString forKey:@"locationString"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _location = [aDecoder decodeObjectForKey:@"location"];
        _payload = [aDecoder decodeObjectForKey:@"payload"];
        _date = [aDecoder decodeObjectForKey:@"date"];
        _repeat = [aDecoder decodeIntForKey:@"repeat"];
        _reminderType = [aDecoder decodeObjectForKey:@"reminderType"];
        _transport = [aDecoder decodeObjectForKey:@"transport"];
        _minutesBefore = [aDecoder decodeIntForKey:@"minutesBefore"];
        _locationString = [aDecoder decodeObjectForKey:@"locationString"];
    }
    return self;
}

@end
