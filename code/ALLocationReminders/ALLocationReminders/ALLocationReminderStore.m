//
//  ALLocationReminders.m
//  ALLocationReminders
//
//  Created by Alex Layton on 19/10/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "ALLocationReminderStore.h"
#import "ALLocationReminder.h"

const ALLocationReminderType kALLocationReminderTypeLocation = @"Location";
const ALLocationReminderType kALLocationReminderTypeDate = @"Date";
const ALLocationReminderType kALLocationReminderTypePreemptive = @"Preemptive";

@implementation ALLocationReminderStore

@synthesize locationReminders = _locationReminders;
@synthesize dateReminders = _dateReminders;
@synthesize preemptiveReminders = _preemptiveReminders;

- (id)init
{
    self = [super init];
    if (self) {
        _locationReminders = [[NSMutableArray alloc] init];
        _dateReminders = [[NSMutableArray alloc] init];
        _preemptiveReminders = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _locationReminders = [aDecoder decodeObjectForKey:@"locationReminders"];
        _dateReminders = [aDecoder decodeObjectForKey:@"dateReminders"];
        _preemptiveReminders = [aDecoder decodeObjectForKey:@"preemptiveReminders"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_locationReminders forKey:@"locationReminders"];
    [aCoder encodeObject:_dateReminders forKey:@"dateReminders"];
    [aCoder encodeObject:_preemptiveReminders forKey:@"preemptiveReminders"];
}

- (void)pushReminder:(ALLocationReminder *)reminder type:(ALLocationReminderType)reminderType
{
    //add reminder to the array in its postion sorted by date not first position
    if (reminderType == kALLocationReminderTypeDate) {
        [_dateReminders addObject:reminder];
        [self sortArray:_dateReminders];
    } else if (reminderType == kALLocationReminderTypeLocation) {
        [_locationReminders addObject:reminder];
        [self sortArray:_locationReminders];
    } else if (reminderType == kALLocationReminderTypePreemptive) {
        [_preemptiveReminders addObject:reminder];
        [self sortArray:_preemptiveReminders];
        NSLog(@"Preemptive count: %d", _preemptiveReminders.count);
    }
}

- (ALLocationReminder *)popReminderWithType:(ALLocationReminderType)reminderType
{
    ALLocationReminder *reminder = nil;
    if (reminderType == kALLocationReminderTypeDate && _dateReminders.count > 0) {
        reminder = [_dateReminders objectAtIndex:0];
        [_dateReminders removeObjectAtIndex:0];
    } else if (reminderType == kALLocationReminderTypeLocation && _locationReminders.count > 0) {
        reminder = [_locationReminders objectAtIndex:0];
        [_locationReminders removeObjectAtIndex:0];
    } else if (reminderType == kALLocationReminderTypePreemptive && _preemptiveReminders.count > 0) {
        reminder = [_preemptiveReminders objectAtIndex:0];
        [_preemptiveReminders removeObjectAtIndex:0];
    }
    return reminder;
}

- (ALLocationReminder *)peekReminderWithType:(ALLocationReminderType)reminderType
{

    ALLocationReminder *reminder = nil;
    if (reminderType == kALLocationReminderTypeDate && _dateReminders.count > 0) {
        reminder = [_dateReminders objectAtIndex:0];
    } else if (reminderType == kALLocationReminderTypeLocation && _locationReminders.count > 0) {
        reminder = [_locationReminders objectAtIndex:0];
    } else if (reminderType == kALLocationReminderTypePreemptive && _preemptiveReminders.count > 0) {
        reminder = [_preemptiveReminders objectAtIndex:0];
    }
    return reminder;
}

- (void)sortArray:(NSMutableArray *)array;
{
    [array sortUsingComparator:^NSComparisonResult(ALLocationReminder *first, ALLocationReminder *second) {
        return [first.date compare:second.date];
    }];
}

@end
