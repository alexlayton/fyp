//
//  CMSettingsViewController.h
//  Class Mate
//
//  Created by Alex Layton on 26/11/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMSettingsViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *methodLabel;
@property (strong, nonatomic) IBOutlet UILabel *reminderLabel;

- (IBAction)donePressed:(UIBarButtonItem *)sender;

@end
