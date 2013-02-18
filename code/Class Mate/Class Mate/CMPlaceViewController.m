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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self checkFavourites];
}

- (void)checkFavourites
{
    CMFavourites *favourites = [CMFavourites sharedFavourites];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(name == %@)", _place.name];
    NSArray *filteredArray = [favourites.favourites filteredArrayUsingPredicate:predicate];
    if (filteredArray.count > 0) {
        //change to an image;
        self.navigationItem.rightBarButtonItem.title = @"Unfav";
    }
}

- (IBAction)favouritePressed:(UIBarButtonItem *)sender {
    CMFavourites *favourites = [CMFavourites sharedFavourites];
    if ([sender.title isEqualToString:@"Fav"]) {
        [favourites.favourites addObject:_place];
        sender.title = @"Unfav";
    } else if ([sender.title isEqualToString:@"Unfav"]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(name != %@)", _place.name];
        [favourites.favourites filterUsingPredicate:predicate];
        sender.title = @"Fav";
    }
    [favourites saveData];
}

@end
