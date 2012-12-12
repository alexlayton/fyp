//
//  CMMapViewController.m
//  Class Mate
//
//  Created by Alex Layton on 30/11/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "CMMapViewController.h"

@implementation CMMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)donePressed:(UIBarButtonItem *)sender
{
    NSLog(@"Done Pressed!");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
