//
//  ALLocationReminders.m
//  ALLocationReminders
//
//  Created by Alex Layton on 19/10/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "ALLocationReminderStore.h"
#import "ALLocationReminder.h"

@implementation ALLocationReminderStore

@synthesize reminders = _reminders;

+ (ALLocationReminderStore *)sharedStore
{
    static ALLocationReminderStore *sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[ALLocationReminderStore alloc] init]; //change the designated initialiser later
    });
    return sharedStore;
}

- (id)init
{
    self = [super init];
    if (self) {
        _reminders = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)pushReminder:(ALLocationReminder *)reminder
{
    //add reminder to the array in its postion sorted by date not first position
    [_reminders addObject:reminder];
    [self sort];
}

- (ALLocationReminder *)popReminder
{
    ALLocationReminder *reminder =  [_reminders objectAtIndex:0];
    [_reminders removeObjectAtIndex:0];
    return reminder;
}

- (ALLocationReminder *)peekReminder
{
    return [_reminders objectAtIndex:0];
}

- (void)stateOfReminders //this is for me
{
    NSLog(@"Prepare to print reminders!");
    for (ALLocationReminder *reminder in _reminders) {
        NSLog(@"%@", reminder.payload); //reminder.reminder??????!!!!
    }
    [self popReminder];
    for (ALLocationReminder *reminder in _reminders) {
        NSLog(@"%@", reminder.payload); //reminder.reminder??????!!!!
    }
}

- (void)sort
{
    [_reminders sortUsingComparator:^NSComparisonResult(ALLocationReminder *first, ALLocationReminder *second) {
        return [first.date compare:second.date];
    }];
}

@end
