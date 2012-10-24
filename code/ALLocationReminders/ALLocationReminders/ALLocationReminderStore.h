//
//  ALLocationReminders.h
//  ALLocationReminders
//
//  Created by Alex Layton on 19/10/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h> 

@class ALLocationReminder;

@interface ALLocationReminderStore : NSObject

@property (nonatomic, strong) NSMutableArray *reminders;

+ (ALLocationReminderStore *)sharedStore;

- (void)pushReminder:(ALLocationReminder *)reminder;
- (ALLocationReminder *)popReminder;
- (ALLocationReminder *)peekReminder;
- (void)stateOfReminders; //get rid!

@end
