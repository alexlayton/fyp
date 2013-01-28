//
//  CMAddress.h
//  Class Mate
//
//  Created by Alex Layton on 22/01/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPlace.h"

@class CLLocation;

@interface CMAddress : CMPlace

@property (nonatomic, readonly) NSString *street;
@property (nonatomic, readonly) NSString *city;
@property (nonatomic, readonly) NSString *state;
@property (nonatomic, readonly) NSString *zip;
@property (nonatomic, readonly) NSString *country;

- (id)initWithAddressReference:(CFDictionaryRef)addressRef;
- (id)initWithName:(NSString *)name addressReference:(CFDictionaryRef)addressRef;
- (NSString *)formattedAddress;
- (NSString *)address;

@end
