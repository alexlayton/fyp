//
//  ALLocationRemindersViewController.m
//  ALLocationReminders
//
//  Created by Alex Layton on 30/10/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "ALLocationRemindersViewController.h"
#import "ALLocationReminderManager.h"

@implementation ALLocationRemindersViewController

@synthesize reminderManager = _reminderManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ALLocationReminderManager *)reminderManager
{
    if (!_reminderManager) {
        _reminderManager = [[ALLocationReminderManager alloc] init];
    }
    return _reminderManager;
}

- (IBAction)buttonPressed:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"Start"]) {
        [_reminderManager startLocationReminders];
        [sender setTitle:@"Stop" forState:UIControlStateNormal];
    } else {
        [_reminderManager stopLocationReminders];
        [sender setTitle:@"Start" forState:UIControlStateNormal];
    }
}

@end