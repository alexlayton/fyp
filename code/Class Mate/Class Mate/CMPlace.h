//
//  CMPlace.h
//  Class Mate
//
//  Created by Alex Layton on 28/01/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;

@interface CMPlace : NSObject <NSCoding>

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) CLLocation *location;

@end
