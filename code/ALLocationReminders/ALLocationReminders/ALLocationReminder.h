//
//  ALLocationReminder.h
//  ALLocationReminders
//
//  Created by Alex Layton on 19/10/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ALLocationReminder : NSObject

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *payload;
@property (nonatomic, strong) NSDate *date;

+ (ALLocationReminder *)reminderWithLocation:(CLLocation *)location payload:(NSString *)payload date:(NSDate *)date;
- (id)initWithLocation:(CLLocation *)location payload:(NSString *)payload date:(NSDate *)date;

@end
