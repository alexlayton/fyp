//
//  CMMasterViewController.h
//  test
//
//  Created by Alex Layton on 26/01/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMDetailViewController;

@interface CMMasterViewController : UITableViewController

@property (strong, nonatomic) CMDetailViewController *detailViewController;

@end
