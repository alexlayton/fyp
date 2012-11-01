//
//  ALLocationRemindersViewController.h
//  ALLocationReminders
//
//  Created by Alex Layton on 30/10/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALLocationReminderManager;

@interface ALLocationRemindersViewController : UIViewController

@property (nonatomic, strong) ALLocationReminderManager *reminderManager;

- (IBAction)buttonPressed:(UIButton *)sender;

@end
