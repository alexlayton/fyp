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

+ (ALLocationReminderStore *)sharedStore
{
    static ALLocationReminderStore *sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[ALLocationReminderStore alloc] init];
    });
    return sharedStore;
}

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

# pragma mark - hacks!

- (void)pushPreemptiveReminder:(ALLocationReminder *)reminder
{
    [_preemptiveReminders addObject:reminder];
    [self sortArray:_preemptiveReminders];
}

- (ALLocationReminder *)peekPreemptiveReminder
{
    if (_preemptiveReminders.count == 0) return nil;
    return [_preemptiveReminders objectAtIndex:0];
}

- (ALLocationReminder *)popPreemptiveReminder
{
    if (_preemptiveReminders.count == 0) return nil;
    ALLocationReminder *reminder = [_preemptiveReminders objectAtIndex:0];
    [_preemptiveReminders removeObjectAtIndex:0];
    return reminder;
}

@end
