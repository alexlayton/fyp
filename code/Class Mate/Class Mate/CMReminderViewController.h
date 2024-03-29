//
//  CMReminderViewController.h
//  Class Mate
//
//  Created by Alex Layton on 28/11/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALLocationReminder, MKMapView, CMReminderViewController;

@protocol CMReminderViewControllerDelegate <NSObject>

- (void)reminderViewController:(CMReminderViewController *)rvc didDeleteReminder:(ALLocationReminder *)reminder;

@end

@interface CMReminderViewController : UITableViewController <UIAlertViewDelegate>

@property (nonatomic, strong) ALLocationReminder *reminder;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *payloadLabel;
@property (nonatomic, weak) id<CMReminderViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *navigateButton;
@property (nonatomic) BOOL hideNavigation;

- (IBAction)deletePressed:(UIBarButtonItem *)sender;
- (IBAction)navigatePressed:(UIButton *)sender;
- (IBAction)doneButton:(UIBarButtonItem *)sender;

@end
