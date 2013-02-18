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
#import <Crashlytics/Crashlytics.h>

#define kTestFlighTeamToken @"5a7b90d8-72ea-4e37-803a-bf93d42a3b99"
#define kTesting 1

@implementation CMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Crashlytics startWithAPIKey:@"3d0645f271b14f649463785d7edcbf17df2e837e"];
    
    #ifdef kTesting
        [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
        [TestFlight takeOff:kTestFlighTeamToken];
    #endif
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"firstRun"]) {
        NSLog(@"Loading user defaults");
        [self setupUserDefaults];
    }
    
    [CMAppDelegate customiseAppearance];
    return YES;
}

- (void)setupUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSDate date] forKey:@"firstRun"];
    //other defaults here...
    [defaults synchronize];
}

+ (void)customiseAppearance
{
    UIImage *navbar = [UIImage imageNamed:@"navbar-test.png"];
    [[UINavigationBar appearance] setBackgroundImage:navbar forBarMetrics:UIBarMetricsDefault];
    
    UIImage *backButton = [[UIImage imageNamed:@"backbutton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 5)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIImage *barButton = [[UIImage imageNamed:@"barbutton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [[UIBarButtonItem appearance] setBackgroundImage:barButton forState:UIControlStateNormal style:UIBarButtonItemStyleBordered barMetrics:UIBarMetricsDefault];
    
    //done buttons
    UIImage *barButtonBlue = [[UIImage imageNamed:@"barbuttonblue.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [[UIBarButtonItem appearance] setBackgroundImage:barButtonBlue forState:UIControlStateNormal style:UIBarButtonItemStyleDone barMetrics:UIBarMetricsDefault];
    
    //toolbar
    UIImage *toolbar = [UIImage imageNamed:@"toolbar-test.png"];
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
    [lrm stopLocation]; //if necessary
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    ALLocationReminderManager *lrm = [ALLocationReminderManager sharedManager];
    [lrm saveData];
    [lrm startLocation]; //if necessary
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    ALLocationReminderManager *lrm = [ALLocationReminderManager sharedManager];
    [lrm saveData];
    if (lrm.remindersAreRunning) {
        [lrm stopLocationReminders];
    }
}

@end
