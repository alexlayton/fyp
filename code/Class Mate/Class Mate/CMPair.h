//
//  CMPair.h
//  Class Mate
//
//  Created by Alex Layton on 08/02/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMPair : NSObject

@property (nonatomic, strong) NSString *obj;
@property (nonatomic, strong) NSString *objDescription;

+ (CMPair *)pairWithObj:(NSString *)obj description:(NSString *)objDescription;

@end
