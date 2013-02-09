//
//  CMViewController.h
//  Class Mate
//
//  Created by Alex Layton on 26/11/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableViewCell *feedbackCell;

- (IBAction)startPressed:(UIBarButtonItem *)sender;

@end
