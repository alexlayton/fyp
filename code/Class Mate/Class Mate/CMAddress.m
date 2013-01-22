//
//  CMAddress.m
//  Class Mate
//
//  Created by Alex Layton on 22/01/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import "CMAddress.h"
#import <AddressBook/AddressBook.h>

@implementation CMAddress

@synthesize street = _street;
@synthesize city = _city;
@synthesize state = _state;
@synthesize zip = _zip;
@synthesize country = _country;

- (id)initWithAddressReference:(CFDictionaryRef)addressRef
{
    self = [super init];
    if (self) {
        _street = (NSString *)CFDictionaryGetValue(addressRef, kABPersonAddressStreetKey);
        _city = (NSString *)CFDictionaryGetValue(addressRef, kABPersonAddressCityKey);
        _state = (NSString *)CFDictionaryGetValue(addressRef, kABPersonAddressStateKey);
        _zip = (NSString *)CFDictionaryGetValue(addressRef, kABPersonAddressZIPKey);
        _country = (NSString *)CFDictionaryGetValue(addressRef, kABPersonAddressCountryKey);
    }
    return self;
}

- (NSString *)address
{
    NSMutableString *address = [[NSMutableString alloc] init];
    if (_street) [address appendFormat:@"%@\n", _street];
    if (_city) [address appendFormat:@"%@\n", _city];
    if (_state) [address appendFormat:@"%@\n", _state];
    if (_zip) [address appendFormat:@"%@\n", _zip];
    if (_country) [address appendFormat:@"%@\n", _country];
    return [address copy];
}

@end
