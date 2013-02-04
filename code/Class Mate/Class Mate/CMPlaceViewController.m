//
//  CMPlaceViewController.m
//  Class Mate
//
//  Created by Alex Layton on 13/01/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import "CMPlaceViewController.h"
#import "CMAddress.h"
#import "CMGooglePlace.h"
#import "CMFavourites.h"

@implementation CMPlaceViewController

@synthesize place = _place;
@synthesize addressLabel = _addressLabel;
@synthesize nameLabel = _nameLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = _place.name;
    _nameLabel.text = _place.name;
	if ([_place isKindOfClass:[CMAddress class]]) {
        _addressLabel.text = [(CMAddress *)_place formattedAddress];
    } else { //google place
        _addressLabel.text = [(CMGooglePlace *)_place vicinity];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)favouritePressed:(UIBarButtonItem *)sender {
    CMFavourites *favourites = [CMFavourites sharedFavourites];
    [favourites.favourites addObject:_place];
    [favourites saveData];
}

@end
