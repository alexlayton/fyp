//
//  CMAddReminderViewController.h
//  Class Mate
//
//  Created by Alex Layton on 28/11/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSTextView;

@interface CMAddReminderViewController : UITableViewController <UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic, strong) SSTextView *textView;

- (IBAction)donePressed:(UIBarButtonItem *)sender;
- (IBAction)cancelPressed:(UIBarButtonItem *)sender;

- (IBAction)pickerPressed:(UIButton *)sender;

@end
