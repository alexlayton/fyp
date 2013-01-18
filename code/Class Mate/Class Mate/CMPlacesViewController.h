//
//  CMPlaceViewController.h
//  Class Mate
//
//  Created by Alex Layton on 17/12/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMPlacesViewController, CLLocation;

@protocol CMPlacesViewDelegate <NSObject>

- (void)placeView:(CMPlacesViewController *)pvc didSelectPlaceDictionary:(NSDictionary *)dict;

@end

@interface CMPlacesViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *nearbyPlaces;
@property (nonatomic, strong) NSMutableArray *filteredPlaces;
@property (nonatomic, weak) id<CMPlacesViewDelegate> delegate;

@end
