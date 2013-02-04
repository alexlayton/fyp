//
//  CMAddTestViewController.h
//  Class Mate
//
//  Created by Alex Layton on 01/02/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPlacesViewController.h"
#import "CMAddressViewController.h"
#import "CMFavouritesViewController.h"
#import "CMOptionViewController.h"

@class CMPlace;

@interface CMAddTestViewController : UITableViewController <UITextFieldDelegate, CMPlacesViewDelegate, CMAddressViewDelegate, CMPlacesViewDelegate, CMFavouritesViewDelegate, CMOptionDelegate>

@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) CMPlace *place;
@property (strong, nonatomic) IBOutlet UITableViewCell *timeCell;
@property (strong, nonatomic) IBOutlet UILabel *repeatLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;

- (IBAction)donePressed:(UIBarButtonItem *)sender;
- (IBAction)cancelPressed:(UIBarButtonItem *)sender;

@end
