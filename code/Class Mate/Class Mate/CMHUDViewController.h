//
//  CMHUDViewController.h
//  Class Mate
//
//  Created by Alex Layton on 04/02/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALLocationReminders.h"

@interface CMHUDViewController : UIViewController <ALLocationReminderDelegate>

@property (strong, nonatomic) IBOutlet UILabel *fromLabel;
@property (strong, nonatomic) IBOutlet UILabel *toLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondsLabel;


@end
