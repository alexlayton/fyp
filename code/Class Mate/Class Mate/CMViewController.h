//
//  CMViewController.h
//  Class Mate
//
//  Created by Alex Layton on 26/11/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALLocationReminders.h"

@class CMHUDView;

@interface CMViewController : UITableViewController <ALLocationReminderDelegate>

@property (strong, nonatomic) IBOutlet UITableViewCell *feedbackCell;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *HUDButton;
@property (strong, nonatomic) CMHUDView *HUDView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;

@end
