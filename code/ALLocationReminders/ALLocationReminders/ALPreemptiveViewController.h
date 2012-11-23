//
//  ALPreemptiveViewController.h
//  ALLocationReminders
//
//  Created by Alex Layton on 12/11/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class ALLocationReminderManager;

@interface ALPreemptiveViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UITextField *minutesTextField;
@property (strong, nonatomic) IBOutlet UILabel *searchLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) ALLocationReminderManager *reminderManager;
@property (strong, nonatomic) CLPlacemark *placemark;

- (IBAction)searchPressed:(UIButton *)sender;
- (IBAction)addLocationPressed:(UIButton *)sender;

@end
