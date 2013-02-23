//
//  ALLocationReminderManager.m
//  ALLocationReminders
//
//  Created by Alex Layton on 23/10/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "ALLocationReminderManager.h"
#import "ALLocationReminderStore.h"
#import "ALLocationReminder.h"
#import <AFNetworking/AFNetworking.h>

@interface ALLocationReminderManager ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) int interval;

@end

@implementation ALLocationReminderManager

@synthesize store = _store;
@synthesize delegate = _delegate;
@synthesize currentLocation = _currentLocation;
@synthesize locationManager = _locationManager;
@synthesize remindersAreRunning = _remindersAreRunning;
@synthesize speed = _speed;
@synthesize transport = _transport;
@synthesize seconds = _seconds;
@synthesize timer = _timer;
@synthesize interval = _interval; //timer interval in minutes
@synthesize minutesBeforeReminderTime = _minutesBeforeReminderTime;

# pragma mark - initialisers

+ (ALLocationReminderManager *)sharedManager
{
    static ALLocationReminderManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[ALLocationReminderManager alloc] init];
    });
    return sharedManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setupDefaults]; //add defaults if dont exist
        _store = [NSKeyedUnarchiver unarchiveObjectWithFile:[self archivePath]];
        [self removeOldReminders];
        
        if (!_store) {
            _store = [[ALLocationReminderStore alloc] init];
        }
        
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        _locationManager.distanceFilter = 100;
        _interval = 1;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _transport = [defaults objectForKey:@"transport"];
        _minutesBeforeReminderTime = [[defaults objectForKey:@"minutes"] intValue];
        
        if (_store.preemptiveReminders.count > 0 || _store.locationReminders.count > 0) {
            [self startLocationReminders];
        }
    }
    return self;
}

- (void)saveData
{
    NSLog(@"Saving Store");
    NSString *path = [self archivePath];
    [NSKeyedArchiver archiveRootObject:_store toFile:path];
}

- (NSString *)archivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

- (void)setupDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"transport"]) {
        //setup defaults
        NSLog(@"setting up defaults...");
        [defaults setObject:kALLocationRemindersTransportTypeDriving forKey:@"transport"];
        [defaults setObject:@"5" forKey:@"minutes"]; //5 minutes before
    }
}

- (void)loadDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _transport = [defaults objectForKey:@"transport"];
    _minutesBeforeReminderTime = [[defaults objectForKey:@"minutes"] intValue];
}

- (void)startLocationReminders
{
    _remindersAreRunning = YES;
    [_locationManager startUpdatingLocation];
}

- (void)stopLocationReminders
{
    _remindersAreRunning = NO;
    [_locationManager stopUpdatingLocation];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)startLocation
{
    if (!_remindersAreRunning) {
        [_locationManager startUpdatingLocation];
    }
}

- (void)stopLocation
{
    if (!_remindersAreRunning) {
        [_locationManager stopUpdatingLocation];
    }
}

- (void)addDateBasedReminderWithPayload:(NSString *)payload date:(NSDate *)date
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = payload;
    notification.fireDate = date;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)addReminder:(ALLocationReminder *)reminder
{
    if (![reminder.reminderType isEqualToString:kALLocationReminderTypeDate]) {
        [_store pushReminder:reminder type:reminder.reminderType];
        if (!_remindersAreRunning) {
            [self startLocationReminders];
        }
    } else {
        //for now
        [_store pushReminder:reminder type:reminder.reminderType];
        NSDate *newDate = [reminder.date dateByAddingTimeInterval:-60 * reminder.minutesBefore];
        [self addDateBasedReminderWithPayload:reminder.payload date:newDate];
    }
}

- (void)addReminder:(ALLocationReminder *)reminder success:(void (^)(void))successBlock failure:(void (^)(void))failureBlock
{
    if ([reminder.reminderType isEqualToString:kALLocationReminderTypePreemptive]) {
        
        NSString *locationString = [NSString stringWithFormat:@"origins=%f,%f&destinations=%f,%f", _currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude, reminder.location.coordinate.latitude, reminder.location.coordinate.longitude];
        NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/distancematrix/json?%@&sensor=true&mode=%@", locationString, reminder.reminderType];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            NSDictionary *dict = JSON;
            NSArray *rows = [dict objectForKey:@"rows"];
            
            NSDictionary *element = [[[rows objectAtIndex:0] objectForKey:@"elements"] objectAtIndex:0]; //inception
            
            NSString *secondString = [[element valueForKey:@"duration"] valueForKey:@"value"];
            int seconds = [secondString intValue];
            
            NSDate *projected = [NSDate dateWithTimeIntervalSinceNow:seconds + reminder.minutesBefore];
            
            if ([projected compare:reminder.date] == NSOrderedAscending) {
                //add reminder
                [self addReminder:reminder];
                if (successBlock) successBlock();
            } else {
                if (failureBlock) failureBlock();
            }
        } failure:nil];
        [operation start];
        
    } else if ([reminder.reminderType isEqualToString:kALLocationReminderTypeLocation]) {
        
        CLRegion *region = [self makeRegionFromLocation:reminder.location];
        if ([region containsCoordinate:_currentLocation.coordinate]) {
            if (failureBlock) failureBlock();
        } else {
            [self addReminder:reminder];
            if (successBlock) successBlock();
        }
        
    } else {
        [self addReminder:reminder];
        if (successBlock) successBlock();
    }
}


- (void)processLocalNotification:(UILocalNotification *)notification
{
    ALLocationReminder *reminder = [_store peekReminderWithType:kALLocationReminderTypeDate];
    NSDate *newDate = [reminder.date dateByAddingTimeInterval:-60 * reminder.minutesBefore];
    if ([newDate isEqualToDate:notification.fireDate]) {
        [_store popReminderWithType:kALLocationReminderTypeDate];
        if (reminder.repeat != kALRepeatTypeNever) {
            NSDate *newDate;
            if (reminder.repeat == kALRepeatTypeMonth) {
                newDate = [self addMonthToDate:reminder.date];
            } else {
                newDate = [NSDate dateWithTimeInterval:reminder.repeat sinceDate:reminder.date];
            }
            reminder.date = newDate;
            [self addReminder:reminder];
        }
    }
}

# pragma mark - CLLocation Delegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"Updated location");
    _currentLocation = [locations lastObject];
    if (_currentLocation.speed > 0) _speed = _currentLocation.speed;
    
    if (_remindersAreRunning) {
        NSLog(@"location update reminder count: %d", _store.preemptiveReminders.count);
        if (_timer) {
            NSLog(@"Timer fired premature");
            [_timer fire]; //if there is a timer active now fire it
        } else {
            [self processReminders];
        }
    }
    
    if ([_delegate respondsToSelector:@selector(locationReminderManager:locationDidChange:)]) {
            [_delegate locationReminderManager:self locationDidChange:_currentLocation];
    }
}

- (void)processReminders
{
    NSLog(@"Processing Reminders");
    
    //reminder logic in here
    //process location reminders
    [self processLocationReminder:_currentLocation];
    
    
    //process current preemptive reminder
    //[self processPreemptiveReminder:_currentLocation];
    //    [self printPreempriveReminders];
    [self ProcessPreemptiveReminderWithMaps:_currentLocation];
    
    if (_store.preemptiveReminders.count == 0 && _store.locationReminders.count == 0) {
        [self stopLocationReminders];
    } else if (_store.preemptiveReminders.count > 0) {
        //start timer again after processing reminders
        NSLog(@"Starting timer");
        _timer = [NSTimer scheduledTimerWithTimeInterval:_interval * 60 target:self selector:@selector(processReminders) userInfo:nil repeats:NO];
    }
}

- (void)processPreemptiveReminder:(CLLocation *)currentLocation
{
    ALLocationReminder *reminder = [_store peekReminderWithType:kALLocationReminderTypePreemptive];
    if (reminder) {
        int time = [self timeBetweenLocationFrom:currentLocation to:reminder.location];
        NSLog(@"Seconds away: %d", time);
        NSDate *projectedDate = [NSDate dateWithTimeIntervalSinceNow:time]; //projected time
        NSDate *goalDate = [reminder.date dateByAddingTimeInterval:-60 * reminder.minutesBefore];
        
        if ([projectedDate compare:goalDate] == NSOrderedDescending) {
            NSLog(@"Fire the reminder");
            [_store popReminderWithType:kALLocationReminderTypePreemptive];
            [self fireReminder:reminder];
        }
        //if time has changed call this delegate method
        if ([_delegate respondsToSelector:@selector(locationReminderManager:timeFromPreemptiveLocationDidChange:)]) {
                    [_delegate locationReminderManager:self timeFromPreemptiveLocationDidChange:time];
        }
    }
}

- (void)ProcessPreemptiveReminderWithMaps:(CLLocation *)from
{
    ALLocationReminder *reminder = [_store peekReminderWithType:kALLocationReminderTypePreemptive];
    NSLog(@"Is reminder nil? %@", reminder);
    if (reminder) {
        NSString *fromString = [NSString stringWithFormat:@"origins=%f,%f", from.coordinate.latitude, from.coordinate.longitude];
        NSString *toString = [NSString stringWithFormat:@"destinations=%f,%f", reminder.location.coordinate.latitude, reminder.location.coordinate.longitude];
        NSString *baseUrlString = @"http://maps.googleapis.com/maps/api/distancematrix/json?";
        NSString *urlString = [NSString stringWithFormat:@"%@%@&%@&sensor=true&mode=%@", baseUrlString, fromString, toString, reminder.transport];
        
        NSLog(@"%@", urlString);
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            @synchronized(reminder) {
            
                NSLog(@"Response: %@", JSON);
                
                NSDictionary *dict = JSON;
                NSArray *rows = [dict objectForKey:@"rows"];
                
                NSDictionary *element = [[[rows objectAtIndex:0] objectForKey:@"elements"] objectAtIndex:0]; //inception
                
                NSString *status = [element valueForKey:@"status"]; //if not okay fallback to no maps
                NSLog(@"status: %@", status);
                
                NSString *secondString = [[element valueForKey:@"duration"] valueForKey:@"value"];
                int seconds = [secondString intValue];
                _seconds = seconds;
                
                NSDate *projectedDate = [NSDate dateWithTimeIntervalSinceNow:seconds]; //projected time
                NSDate *goalDate = [reminder.date dateByAddingTimeInterval:-60 * reminder.minutesBefore]; //remove 5 minutes for now
                
                NSLog(@"seconds: %d", seconds);
                if ([_delegate respondsToSelector:@selector(locationReminderManager:timeFromPreemptiveLocationDidChange:)]) {
                    [_delegate locationReminderManager:self timeFromPreemptiveLocationDidChange:seconds];
                }
                
                if ([projectedDate compare:goalDate] == NSOrderedDescending) {
                    NSLog(@"Fire the reminder");
                    [_store popReminderWithType:kALLocationReminderTypePreemptive];
                    [self fireReminder:reminder];
                    NSLog(@"Store: %@", _store.preemptiveReminders);
                } else {
                    NSLog(@"Don't fire reminder yet");
                }
            }
        } failure:nil];
        
        [operation start];
    }
}

- (void)processLocationReminder:(CLLocation *)currentLocation
{
    NSMutableArray *reminders = _store.locationReminders;
    if (reminders) {
        CLLocationCoordinate2D currentCoord = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
        for (ALLocationReminder *reminder in reminders) {
            CLRegion *region = [self makeRegionFromLocation:reminder.location];
            if ([region containsCoordinate:currentCoord]) {
                [reminders removeObject:reminder];
                [self fireReminder:reminder]; //fire reminder for now
            }
        }
    }
}

- (void)removeOldReminders
{
    NSDate *now = [NSDate date];
    //preemptive
    for (int i = 0; i < _store.preemptiveReminders.count; i++) {
        ALLocationReminder *reminder = [_store.preemptiveReminders objectAtIndex:i];
        if ([reminder.date compare:now] != NSOrderedDescending) {
            [_store.preemptiveReminders removeObjectAtIndex:i];
        } else {
            break;
        }
    }
    //location
    for (int i = 0; i < _store.locationReminders.count; i++) {
        ALLocationReminder *reminder = [_store.locationReminders objectAtIndex:i];
        if ([reminder.date compare:now] != NSOrderedDescending) {
            [_store.locationReminders removeObjectAtIndex:i];
        } else {
            break;
        }
    }
    //date
    for (int i = 0; i < _store.dateReminders.count; i++) {
        ALLocationReminder *reminder = [_store.dateReminders objectAtIndex:i];
        if ([reminder.date compare:now] != NSOrderedDescending) {
            [_store.dateReminders removeObjectAtIndex:i];
        } else {
            break;
        }
    }
}

- (void)updateDateReminders
{
    NSDate *now = [NSDate date];
    for (int i = 0; i < _store.dateReminders.count; i++) {
        ALLocationReminder *reminder = [_store.dateReminders objectAtIndex:i];
        if ([reminder.date compare:now] != NSOrderedDescending) {
            [_store.dateReminders removeObjectAtIndex:i];
        } else {
            break;
        }
    }
}

- (CLRegion *)makeRegionFromLocation:(CLLocation *)location
{
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    CLLocationDistance radius = 300.0; //300 metres
    CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:coord radius:radius identifier:@"region"];
    return region;
}
            
- (void)fireReminder:(ALLocationReminder *)reminder
{
    if (reminder.repeat != kALRepeatTypeNever) {
        //shedule reminder here...
        NSLog(@"Reminder should repeat");
        NSDate *newDate;
        if (reminder.repeat == kALRepeatTypeMonth) {
            newDate = [self addMonthToDate:reminder.date];
        } else {
            newDate = [NSDate dateWithTimeInterval:reminder.repeat sinceDate:reminder.date];
        }
        reminder.date = newDate;
        [self addReminder:reminder];
    }
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    if (state == UIApplicationStateActive) { //alert 
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder" message:reminder.payload delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    } else { //notification
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = reminder.payload;
        notification.soundName = @"sound.wav";
        notification.fireDate = [[NSDate date] dateByAddingTimeInterval:1];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

# pragma mark - Date Stuff

- (NSInteger)daysBetweenDate:(NSDate *)date1 andDate:(NSDate *)date2
{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *components = [calender components:NSDayCalendarUnit fromDate:date1 toDate:date2 options:0];
    return [components day];
}

- (NSInteger)secondsBetweenDate:(NSDate *)date1 andDate:(NSDate *)date2
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSSecondCalendarUnit fromDate:date1 toDate:date2 options:0];
    return [components second];
}

- (NSDate *)addMonthToDate:(NSDate *)date
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = 1;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (NSInteger)timeBetweenLocationFrom:(CLLocation *)from to:(CLLocation *)to
{
    //time (seconds) = distance (metres) / speed (metres per second)
    double speed = from.speed;
    double distance = [to distanceFromLocation:from];
    if (speed <= 0) speed = _speed;
    int time = (int) distance / speed;
    NSLog(@"Distance: %f / Speed: %f = Time: %d", distance, speed, time);
    return time;
}

@end
