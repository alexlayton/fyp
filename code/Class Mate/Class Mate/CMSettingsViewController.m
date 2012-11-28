//
//  CMSettingsViewController.m
//  Class Mate
//
//  Created by Alex Layton on 26/11/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "CMSettingsViewController.h"

@implementation CMSettingsViewController

- (void)viewDidLoad
{
    _distanceLabel.text = @"10 Minutes";
    _methodLabel.text = @"Meters";
    _reminderLabel.text= @"Car";
}

- (IBAction)donePressed:(UIBarButtonItem *)sender
{
    NSLog(@"Done Pressed!");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
