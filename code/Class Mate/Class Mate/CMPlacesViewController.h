//
//  CMPlaceViewController.h
//  Class Mate
//
//  Created by Alex Layton on 17/12/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMPlacesViewController, CLLocation, CMGooglePlace;

@protocol CMPlacesViewDelegate <NSObject>

- (void)placeView:(CMPlacesViewController *)pvc didSelectPlace:(CMGooglePlace *)place;

@end

@interface CMPlacesViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *nearbyPlaces;
@property (nonatomic, strong) NSArray *filteredPlaces;
@property (nonatomic, weak) id<CMPlacesViewDelegate> delegate;

@end
