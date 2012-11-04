//
//  ALLocationReminderViewController.h
//  ALLocationReminders
//
//  Created by Alex Layton on 04/11/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALLocationReminderManager.h"

@class MKMapView;

@interface ALLocationReminderViewController : UIViewController <ALLocationReminderDelegate>

@property (strong, nonatomic) ALLocationReminderManager *reminderManager;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

- (id)initWithReminderManager:(ALLocationReminderManager *)reminderManager;
- (IBAction)trackingButtonPressed:(UIButton *)sender;

@end
