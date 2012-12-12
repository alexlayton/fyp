//
//  CMRemindersViewController.h
//  Class Mate
//
//  Created by Alex Layton on 28/11/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMRemindersViewController : UITableViewController

@property (nonatomic, weak) NSMutableArray *reminders;
@property (nonatomic, strong) NSString *reminderType;

- (IBAction)editPressed:(UIBarButtonItem *)sender;

@end
