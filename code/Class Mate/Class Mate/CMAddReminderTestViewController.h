//
//  CMAddReminderTestViewController.h
//  Class Mate
//
//  Created by Alex Layton on 01/03/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPlacesViewController.h"
#import "CMAddressViewController.h"
#import "CMFavouritesViewController.h"
#import "CMGeocodeViewController.h"
#import "CMOptionViewController.h"
#import "ALLocationReminders.h"

@interface CMAddReminderTestViewController : UITableViewController <UITextFieldDelegate, CMPlacesViewDelegate, CMAddressViewDelegate, CMPlacesViewDelegate, CMFavouritesViewDelegate, CMOptionDelegate, CMGecodeViewDelegate>

@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) CMPlace *place;
@property (strong, nonatomic) NSString *reminderTitle;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) ALLocationReminderType reminderType;

- (IBAction)donePressed:(UIBarButtonItem *)sender;
- (IBAction)cancelPressed:(UIBarButtonItem *)sender;

@end
