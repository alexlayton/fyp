//
//  ALAppDelegate.m
//  ALLocationReminders
//
//  Created by Alex Layton on 19/10/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "ALAppDelegate.h"
#import "ALLocationReminders.h"
#import "ALLocationReminderViewController.h"

@implementation ALAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"Entering Background");
    ALLocationReminderManager *manager = [ALLocationReminderManager sharedManager];
        NSLog(@"Moving to significant change");
        [manager stopLocationReminders];
        [manager startBackgroundLocationReminders];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"Entering Foreground");
    ALLocationReminderManager *manager = [ALLocationReminderManager sharedManager];
    NSLog(@"Back to foreground location");
    [manager stopBackgroundLocationReminders];
    [manager startLocationReminders]; //use normal location
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

//- (void)test
//{
//    ALLocationReminderStore *store = [ALLocationReminderStore sharedStore];
//    
//    //add some reminders
//    NSDate *past = [NSDate distantPast];
//    NSDate *present = [[NSDate alloc] init];
//    NSDate *future = [NSDate distantFuture];
//    
//    ALLocationReminder *reminder2 = [[ALLocationReminder alloc] initWithLocation:nil payload:@"Future" date:future];
//    [store pushReminder:reminder2];
//    ALLocationReminder *reminder = [[ALLocationReminder alloc] initWithLocation:nil payload:@"Present" date:present];
//    [store pushReminder:reminder];
//    ALLocationReminder *reminder1 = [[ALLocationReminder alloc] initWithLocation:nil payload:@"Past" date:past];
//    [store pushReminder:reminder1];
//    
//    [store stateOfReminders];
//}

@end
