//
//  CMAppDelegate.m
//  Class Mate
//
//  Created by Alex Layton on 26/11/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "CMAppDelegate.h"
#import "ALLocationReminders.h"
#import <QuartzCore/QuartzCore.h>

@implementation CMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        //load iPad UI here...
    }
    [CMAppDelegate customiseAppearance];
    return YES;
}

+ (void)customiseAppearance
{
    UIImage *navbar = [UIImage imageNamed:@"navbar.png"];
    [[UINavigationBar appearance] setBackgroundImage:navbar forBarMetrics:UIBarMetricsDefault];
    
    UIImage *backButton = [[UIImage imageNamed:@"backbutton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 5)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIImage *barButton = [[UIImage imageNamed:@"barbutton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [[UIBarButtonItem appearance] setBackgroundImage:barButton forState:UIControlStateNormal style:UIBarButtonItemStyleBordered barMetrics:UIBarMetricsDefault];
    
    //done buttons
    UIImage *barButtonBlue = [[UIImage imageNamed:@"barbuttonblue.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [[UIBarButtonItem appearance] setBackgroundImage:barButtonBlue forState:UIControlStateNormal style:UIBarButtonItemStyleDone barMetrics:UIBarMetricsDefault];
    
    //toolbar
    UIImage *toolbar = [UIImage imageNamed:@"toolbar.png"];
    [[UIToolbar appearance] setBackgroundImage:toolbar forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
}

+ (void)resetAppearance
{
    [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:nil forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    [[UIBarButtonItem appearance] setBackgroundImage:nil forState:UIControlStateNormal style:UIBarButtonItemStyleBordered barMetrics:UIBarMetricsDefault];
    
    //done buttons
    [[UIBarButtonItem appearance] setBackgroundImage:nil forState:UIControlStateNormal style:UIBarButtonItemStyleDone barMetrics:UIBarMetricsDefault];
    
    //toolbar
    [[UIToolbar appearance] setBackgroundImage:nil forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    ALLocationReminderManager *lrm = [ALLocationReminderManager sharedManager];
    [lrm saveData];
    [lrm stopLocationReminders];
    [lrm startBackgroundLocationReminders];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    ALLocationReminderManager *lrm = [ALLocationReminderManager sharedManager];
    [lrm saveData];
    [lrm stopBackgroundLocationReminders];
    [lrm startLocationReminders];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[ALLocationReminderManager sharedManager] saveData];
}

@end
