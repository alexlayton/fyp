---
layout: post
root: "../"
title: Data Structures
author: Alex Layton
date: 2012-11-11 16:56:49
---

Data structures are important, so for my project I have tried to come up with a data structure that stores all the data I need in both an efficient and intuitive way. The first thing I did was to creating objects for the data I was going to store - Reminders. At it's core, a reminder has a location, a date when the reminder needs to be fired and a payload - the message the reminder is to display. Here's the header file;

{% highlight objc %}

@interface ALLocationReminder : NSObject

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *payload;
@property (nonatomic, strong) NSDate *date;

+ (ALLocationReminder *)reminderWithLocation:(CLLocation *)location payload:(NSString *)payload date:(NSDate *)date;
- (id)initWithLocation:(CLLocation *)location payload:(NSString *)payload date:(NSDate *)date;

@end

{% endhighlight %}

As you can see, at the moment it just contains the three properties mentioned above, but this can be added to later if a reminder is to store other things, such as; notes or whether its a repeat reminder. Now we have our reminders, we need to have an somewhere to store them all. There are lots of ways the reminders could be stored - arrays, dictionaries, Whatever. I opted for something slightly more clever, which has helped me a lot when managing the reminders. Here's the header file for the reminder store;

{% highlight objc %}

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

@end

{% endhighlight %}

Since I'm working with three types of reminders I could have store them all in the same place along with the type of each reminder. Instead, I've created an array for each type of reminder. These are conceptually used as a stack with push, peek and pop methods. When any of these methods are called the type of reminder is passed in and it is stored or fetched from the corresponding stack. This means I don't have to differentiate between adding different reminders and keeps reminders separate so the arrays can be easily used to implement table views. This class has a private sorting method which keeps the stacks in order sorted by date. This means when you peek or pop you get the reminder with the nearest date. By keeping the reminders in this order I only ever have to care about the reminder at the top, hence the stack. The method declaration with a '+' is a class method. This method returns a singleton which provides a central store throughout the app. This can easily be saved and loaded using something like NSCoder.

Next I'll look at some of the objective-c @-sign stuff.