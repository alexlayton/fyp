//
//  CMAddReminderViewController.m
//  Class Mate
//
//  Created by Alex Layton on 28/11/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "CMAddReminderViewController.h"

@implementation CMAddReminderViewController

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

- (IBAction)donePressed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelPressed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
