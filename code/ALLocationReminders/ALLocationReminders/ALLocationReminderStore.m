//
//  ALLocationReminders.m
//  ALLocationReminders
//
//  Created by Alex Layton on 19/10/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "ALLocationReminderStore.h"
#import "ALLocationReminder.h"

const ALLocationReminderType kALLocationReminderTypeLocation = 1;
const ALLocationReminderType kALLocationReminderTypeDate = 2;
const ALLocationReminderType kALLocationReminderTypePreemptive = 3;

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
    ALLocationReminder *reminder;
    if (reminderType == kALLocationReminderTypeDate) {
        reminder = [_dateReminders objectAtIndex:0];
        [_dateReminders removeObjectAtIndex:0];
    } else if (reminderType == kALLocationReminderTypeLocation) {
        reminder = [_locationReminders objectAtIndex:0];
        [_locationReminders removeObjectAtIndex:0];
    } else if (reminderType == kALLocationReminderTypePreemptive) {
        reminder = [_preemptiveReminders objectAtIndex:0];
        [_preemptiveReminders removeObjectAtIndex:0];
    }
    return reminder;
}

- (ALLocationReminder *)peekReminderWithtype:(ALLocationReminderType)reminderType
{
    ALLocationReminder *reminder;
    if (reminderType == kALLocationReminderTypeDate) {
        reminder = [_dateReminders objectAtIndex:0];
    } else if (reminderType == kALLocationReminderTypeLocation) {
        reminder = [_locationReminders objectAtIndex:0];
    } else if (reminderType == kALLocationReminderTypePreemptive) {
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
    return [_preemptiveReminders objectAtIndex:0];
}

- (ALLocationReminder *)popPreemptiveReminder
{
    ALLocationReminder *reminder = [_preemptiveReminders objectAtIndex:0];
    [_preemptiveReminders removeObjectAtIndex:0];
    return reminder;
}

@end
