//
//  CMPlace.h
//  Class Mate
//
//  Created by Alex Layton on 25/01/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPlace.h"

@class CLLocation;

@interface CMGooglePlace : CMPlace

@property (nonatomic, strong) NSString *vicinity;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
