//
//  CMReminderAnnotation.m
//  Class Mate
//
//  Created by Alex Layton on 19/12/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "CMReminderAnnotation.h"
#import "ALLocationReminders.h"

@implementation CMReminderAnnotation

@synthesize coordinate = _coordinate;
@synthesize title = _title;
@synthesize subtitle = _subtitle;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:(NSString *)placeName description:(NSString *)description
{
    self = [super init];
    if (self) {
        _coordinate = location;
        _title = placeName;
        _subtitle = description;
    }
    return self;
}

@end
