//
//  CMFavourites.h
//  Class Mate
//
//  Created by Alex Layton on 29/01/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CMPlace;

@interface CMFavourites : NSObject

@property (nonatomic, strong) NSMutableArray *favourites;

+ (CMFavourites *)sharedFavourites;
- (void)saveData;

@end
