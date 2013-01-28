//
//  CMPlace.m
//  Class Mate
//
//  Created by Alex Layton on 25/01/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import "CMGooglePlace.h"
#import <CoreLocation/CoreLocation.h>

@implementation CMGooglePlace

@synthesize name = _name;
@synthesize vicinity = _vicinity;
@synthesize location = _location;

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _name = [dict objectForKey:@"name"];
        _vicinity = [dict objectForKey:@"vicinity"];
        NSDictionary *geometry = [dict objectForKey:@"geometry"];
        double lat = [[geometry objectForKey:@"lat"] doubleValue];
        double lon = [[geometry objectForKey:@"lon"] doubleValue];
        _location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    }
    return self;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _vicinity = [aDecoder decodeObjectForKey:@"vicinity"];
        _location = [aDecoder decodeObjectForKey:@"location"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_vicinity forKey:@"vicinity"];
    [aCoder encodeObject:_location forKey:@"location"];
}

@end
