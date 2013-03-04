//
//  CMPlace.m
//  Class Mate
//
//  Created by Alex Layton on 28/01/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import "CMPlace.h"
#import <CoreLocation/CoreLocation.h>

@implementation CMPlace

@synthesize name = _name;
@synthesize location = _location;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _location = [aDecoder decodeObjectForKey:@"location"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_location forKey:@"location"];
}

@end
