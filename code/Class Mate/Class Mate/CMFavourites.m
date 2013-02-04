//
//  CMFavourites.m
//  Class Mate
//
//  Created by Alex Layton on 29/01/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import "CMFavourites.h"
#import "CMPlace.h"

@implementation CMFavourites

@synthesize favourites = _favourites;

+ (CMFavourites *)sharedFavourites
{
    static CMFavourites *sharedFavourites = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFavourites = [[CMFavourites alloc] init];
    });
    return sharedFavourites;
}

- (void)saveData
{
    NSLog(@"Saving Store");
    NSString *path = [self archivePath];
    [NSKeyedArchiver archiveRootObject:_favourites toFile:path];
}


- (id)init
{
    self = [super init];
    if (self) {
        _favourites = [NSKeyedUnarchiver unarchiveObjectWithFile:[self archivePath]];
        if (!_favourites) {
            _favourites = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (NSString *)archivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"favourites.data"];
}

@end
