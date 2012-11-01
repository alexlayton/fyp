//
//  ALLocationTest.m
//  ALLocationReminders
//
//  Created by Alex Layton on 31/10/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "ALLocationTest.h"

@implementation ALLocationTest

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"Updated Location!");
}

@end
