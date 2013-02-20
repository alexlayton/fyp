//
//  CMGeocodePlace.m
//  Class Mate
//
//  Created by Alex Layton on 19/02/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import "CMGeocodePlace.h"
#import <CoreLocation/CoreLocation.h>

@implementation CMGeocodePlace

@synthesize name = _name;
@synthesize location = _location;
@synthesize country = _country;

- (id)initWithAddress:(NSString *)address country:(NSString *)country location:(CLLocation *)location;
{
    self = [super init];
    if (self) {
        _name = address;
        _country = country;
        _location = location;
    }
    return self;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _country = [aDecoder decodeObjectForKey:@"country"];
        _location = [aDecoder decodeObjectForKey:@"location"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_country forKey:@"country"];
    [aCoder encodeObject:_location forKey:@"location"];
}

@end
