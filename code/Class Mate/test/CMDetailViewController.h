//
//  CMDetailViewController.h
//  test
//
//  Created by Alex Layton on 26/01/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
