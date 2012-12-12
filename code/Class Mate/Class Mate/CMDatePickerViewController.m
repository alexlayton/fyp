//
//  CMDatePickerViewController.m
//  Class Mate
//
//  Created by Alex Layton on 12/12/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "CMDatePickerViewController.h"

@implementation CMDatePickerViewController

@synthesize dateLabel = _dateLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Identifier: %@", segue.identifier);
}

- (IBAction)pickerValueChanged:(UIDatePicker *)sender
{
    _dateLabel.text = [NSString stringWithFormat:@"%@", sender.date];
    [self.tableView reloadData];
}

@end
