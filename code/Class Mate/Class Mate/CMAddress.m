//
//  CMAddress.m
//  Class Mate
//
//  Created by Alex Layton on 22/01/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import "CMAddress.h"
#import <AddressBook/AddressBook.h>
#import <CoreLocation/CoreLocation.h>

@implementation CMAddress

@synthesize name = _name;
@synthesize location = _location;
@synthesize street = _street;
@synthesize city = _city;
@synthesize state = _state;
@synthesize zip = _zip;
@synthesize country = _country;

- (void)geocodeAddress
{
    CLGeocoder *gc = [[CLGeocoder alloc] init];
    [gc geocodeAddressString:[self address] completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            _location = placemark.location;
            NSLog(@"location: %@", _location);
        }
    }];
}

- (id)initWithAddressReference:(CFDictionaryRef)addressRef
{
    self = [super init];
    if (self) {
        [self setAddressWithReference:addressRef];
        [self geocodeAddress];
    }
    return self;
}

- (id)initWithName:(NSString *)name addressReference:(CFDictionaryRef)addressRef
{
    self = [super init];
    if (self) {
        _name = name;
        [self setAddressWithReference:addressRef];
        [self geocodeAddress];
    }
    return self;
}

- (void)setAddressWithReference:(CFDictionaryRef)addressRef
{
    _street = (NSString *)CFDictionaryGetValue(addressRef, kABPersonAddressStreetKey);
    _city = (NSString *)CFDictionaryGetValue(addressRef, kABPersonAddressCityKey);
    _state = (NSString *)CFDictionaryGetValue(addressRef, kABPersonAddressStateKey);
    _zip = (NSString *)CFDictionaryGetValue(addressRef, kABPersonAddressZIPKey);
    _country = (NSString *)CFDictionaryGetValue(addressRef, kABPersonAddressCountryKey);
}

- (NSString *)formattedAddress
{
    NSMutableString *address = [[NSMutableString alloc] init];
    if (_street) [address appendFormat:@"%@\n", _street];
    if (_city) [address appendFormat:@"%@\n", _city];
    if (_state) [address appendFormat:@"%@\n", _state];
    if (_zip) [address appendFormat:@"%@\n", _zip];
    if (_country) [address appendFormat:@"%@\n", _country];
    return [address copy];
}

- (NSString *)address
{
    NSMutableString *address = [[NSMutableString alloc] init];
    if (_street) [address appendFormat:@"%@,", _street];
    if (_city) [address appendFormat:@"%@,", _city];
    if (_state) [address appendFormat:@"%@,", _state];
    if (_zip) [address appendFormat:@"%@,", _zip];
    if (_country) [address appendFormat:@"%@\n", _country];
    return [address copy];
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _location = [aDecoder decodeObjectForKey:@"location"];
        _street = [aDecoder decodeObjectForKey:@"street"];
        _city = [aDecoder decodeObjectForKey:@"city"];
        _state = [aDecoder decodeObjectForKey:@"state"];
        _zip = [aDecoder decodeObjectForKey:@"zip"];
        _country = [aDecoder decodeObjectForKey:@"country"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_location forKey:@"location"];
    [aCoder encodeObject:_street forKey:@"street"];
    [aCoder encodeObject:_city forKey:@"city"];
    [aCoder encodeObject:_state forKey:@"state"];
    [aCoder encodeObject:_zip forKey:@"zip"];
    [aCoder encodeObject:_country forKey:@"country"];
}

@end
