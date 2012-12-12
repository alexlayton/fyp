//
//  CMAddReminderViewController.m
//  Class Mate
//
//  Created by Alex Layton on 28/11/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "CMAddReminderViewController.h"
#import "SSTextView.h"

@implementation CMAddReminderViewController

@synthesize textView = _textView;
@synthesize doneButton = _doneButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _textView.placeholder = @"Notes";
    _doneButton.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)donePressed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelPressed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
