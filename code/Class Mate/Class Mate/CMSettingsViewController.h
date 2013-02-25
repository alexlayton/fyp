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
@property (strong, nonatomic) IBOutlet UILabel *transportLabel;
@property (strong, nonatomic) IBOutlet UILabel *reminderLabel;
@property (strong, nonatomic) IBOutlet UILabel *reminderTypeLabel;

- (IBAction)donePressed:(UIBarButtonItem *)sender;

@end
