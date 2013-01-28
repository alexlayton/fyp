//
//  CMFavouritesViewController.h
//  Class Mate
//
//  Created by Alex Layton on 24/01/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMFavouritesViewController, CMAddress;

@protocol CMFavouritesViewDelegate <NSObject>

- (void)favouritesView:(CMFavouritesViewController *)fvc didSelectFavourite:(CMAddress *)address;

@end

@interface CMFavouritesViewController : UITableViewController <UITabBarControllerDelegate>

@property (nonatomic, strong) NSArray *favourites;
@property (nonatomic, weak) id<CMFavouritesViewDelegate> delegate;

@end
