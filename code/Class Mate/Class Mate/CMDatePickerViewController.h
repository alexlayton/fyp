//
//  CMDatePickerViewController.h
//  Class Mate
//
//  Created by Alex Layton on 12/12/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMDatePickerViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

- (IBAction)pickerValueChanged:(UIDatePicker *)sender;

@end
