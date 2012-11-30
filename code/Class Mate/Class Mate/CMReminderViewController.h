//
//  CMReminderViewController.h
//  Class Mate
//
//  Created by Alex Layton on 28/11/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALLocationReminder;

@interface CMReminderViewController : UITableViewController

@property (nonatomic, weak) ALLocationReminder *reminder;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *payloadLabel;

- (IBAction)deletePressed:(UIBarButtonItem *)sender;

@end
