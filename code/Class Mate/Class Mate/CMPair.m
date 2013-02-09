//
//  CMPair.m
//  Class Mate
//
//  Created by Alex Layton on 08/02/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import "CMPair.h"

@implementation CMPair

+ (CMPair *)pairWithObj:(NSString *)obj description:(NSString *)objDescription
{
    CMPair *pair = [[CMPair alloc] init];
    pair.obj = obj;
    pair.objDescription = objDescription;
    return pair;
}

@end
