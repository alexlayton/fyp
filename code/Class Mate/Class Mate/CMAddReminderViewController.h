//
//  CMAddReminderTestViewController.h
//  Class Mate
//
//  Created by Alex Layton on 17/12/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPlacesViewController.h"
#import "CMAddressViewController.h"
#import "CMFavouritesViewController.h"

@class CMPlace;

@interface CMAddReminderViewController : UITableViewController <UITextFieldDelegate, CMPlacesViewDelegate, CMAddressViewDelegate, CMPlacesViewDelegate, CMFavouritesViewDelegate>

@property (nonatomic, strong) CMPlace *place;
@property (nonatomic, strong) NSDate *date;
@property (strong, nonatomic) IBOutlet UITextField *minutesTextField;
@property (strong, nonatomic) IBOutlet UITextField *payloadTextField;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;

- (IBAction)donePressed:(UIBarButtonItem *)sender;
- (IBAction)cancelPressed:(UIBarButtonItem *)sender;

@end
