//
//  CMGeocodePlace.h
//  Class Mate
//
//  Created by Alex Layton on 19/02/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import "CMPlace.h"

@class CLLocation;

@interface CMGeocodePlace : CMPlace

@property (nonatomic, readonly) NSString *country;

- (id)initWithAddress:(NSString *)address country:(NSString *)country location:(CLLocation *)location;

@end
