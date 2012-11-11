//
//  ALLocationReminders.h
//  ALLocationReminders
//
//  Created by Alex Layton on 19/10/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h> 

typedef int ALLocationReminderType;
extern const ALLocationReminderType kALLocationReminderTypeLocation;
extern const ALLocationReminderType kALLocationReminderTypeDate;
extern const ALLocationReminderType kALLocationReminderTypePreemptive;

@class ALLocationReminder;

@interface ALLocationReminderStore : NSObject

@property (nonatomic, strong) NSMutableArray *locationReminders;
@property (nonatomic, strong) NSMutableArray *dateReminders;
@property (nonatomic, strong) NSMutableArray *preemptiveReminders;

+ (ALLocationReminderStore *)sharedStore;
- (void)pushReminder:(ALLocationReminder *)reminder type:(ALLocationReminderType)reminderType;
- (ALLocationReminder *)popReminderWithType:(ALLocationReminderType)reminderType;
- (ALLocationReminder *)peekReminderWithType:(ALLocationReminderType)reminderType;

//hack
- (void)pushPreemptiveReminder:(ALLocationReminder *)reminder;
- (ALLocationReminder *)peekPreemptiveReminder;
- (ALLocationReminder *)popPreemptiveReminder;

@end
