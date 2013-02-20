//
//  CMGeocodeViewController.h
//  Class Mate
//
//  Created by Alex Layton on 13/02/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMGeocodeViewController, CMGeocodePlace;

@protocol CMGecodeViewDelegate <NSObject>

- (void)geocodeViewController:(CMGeocodeViewController *)gvc didSelectPlace:(CMGeocodePlace *)place;

@end

@interface CMGeocodeViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *places;
@property (nonatomic, strong) NSArray *searchPlaces;
@property (nonatomic, weak) id<CMGecodeViewDelegate> delegate;

@end
