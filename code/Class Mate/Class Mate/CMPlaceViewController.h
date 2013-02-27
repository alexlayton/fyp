//
//  CMPlaceViewController.h
//  Class Mate
//
//  Created by Alex Layton on 13/01/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CMPlace.h>

@class MKMapView;

@interface CMPlaceViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (nonatomic, weak) CMPlace *place;
@property (nonatomic, strong) MKMapView *mapView;

- (IBAction)favouritePressed:(UIBarButtonItem *)sender;

@end
