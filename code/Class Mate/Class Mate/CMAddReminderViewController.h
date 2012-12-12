//
//  CMAddReminderViewController.h
//  Class Mate
//
//  Created by Alex Layton on 28/11/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSTextView;

@interface CMAddReminderViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic, strong) SSTextView *textView;

- (IBAction)donePressed:(UIBarButtonItem *)sender;
- (IBAction)cancelPressed:(UIBarButtonItem *)sender;

@end
