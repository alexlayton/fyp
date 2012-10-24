//
//  ALAppDelegate.m
//  ALLocationReminders
//
//  Created by Alex Layton on 19/10/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "ALAppDelegate.h"
#import "ALLocationReminderManager.h"
#import "ALLocationReminderStore.h"
#import "ALLocationReminder.h"

@implementation ALAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //[self test];
    ALLocationReminderManager *reminderManager = [[ALLocationReminderManager alloc] init];
    CLLocationManager *locationManager;
    if ([CLLocationManager locationServicesEnabled]) {
        locationManager.delegate = reminderManager;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; //play with this
        locationManager.distanceFilter = 10; //10 metres
        [locationManager startUpdatingLocation];
    }
    [reminderManager addReminderAtCurrentLocationWithPayload:@"Testing" date:[[NSDate alloc] init]];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

# pragma mark - Tests

- (void)test
{
    ALLocationReminderStore *store = [ALLocationReminderStore sharedStore];
    
    //add some reminders
    NSDate *past = [NSDate distantPast];
    NSDate *present = [[NSDate alloc] init];
    NSDate *future = [NSDate distantFuture];
    
    ALLocationReminder *reminder2 = [[ALLocationReminder alloc] initWithLocation:nil payload:@"Future" date:future];
    [store pushReminder:reminder2];
    ALLocationReminder *reminder = [[ALLocationReminder alloc] initWithLocation:nil payload:@"Present" date:present];
    [store pushReminder:reminder];
    ALLocationReminder *reminder1 = [[ALLocationReminder alloc] initWithLocation:nil payload:@"Past" date:past];
    [store pushReminder:reminder1];
    
    [store stateOfReminders];
}

@end
