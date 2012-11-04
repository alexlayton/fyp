//
//  ALAnnotation.m
//  ALLocationReminders
//
//  Created by Alex Layton on 04/11/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "ALAnnotation.h"

@implementation ALAnnotation

@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize coordinate = _coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title subtitle:(NSString *)subtitle
{
    self = [super init];
    if (self) {
        _coordinate = coordinate;
        _title = title;
        _subtitle = subtitle;
    }
    return self;
}

@end
