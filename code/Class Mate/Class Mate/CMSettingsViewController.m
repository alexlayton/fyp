//
//  CMSettingsViewController.m
//  Class Mate
//
//  Created by Alex Layton on 26/11/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "CMSettingsViewController.h"
#import "CMSettingsDetailViewController.h"
#import "ALLocationReminders.h"

@implementation CMSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *patternImage = [UIImage imageNamed:@"pattern.png"];
    UIColor *pattern = [UIColor colorWithPatternImage:patternImage];
    CGRect backgroundRect = [[UIScreen mainScreen] applicationFrame];
    UIView *backgroundView = [[UIView alloc] initWithFrame:backgroundRect];
    [backgroundView setBackgroundColor:pattern];
    self.tableView.backgroundView = backgroundView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _distanceLabel.text = [NSString stringWithFormat:@"%@", [defaults objectForKey:@"distance"]];
    _transportLabel.text = [NSString stringWithFormat:@"%@", [defaults objectForKey:@"transport"]];
    _reminderLabel.text= [NSString stringWithFormat:@"%@ Minutes", [defaults objectForKey:@"minutes"]];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *footer;
    if (section == self.tableView.numberOfSections - 1) {
        NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
        NSString *build = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
        footer = [NSString stringWithFormat:@"Class Mate %@ (%@) \n Copyright © Alex Layton 2012. \n All Rights Reserved.", version, build];
    }
    return footer;
}

- (IBAction)donePressed:(UIBarButtonItem *)sender
{
    NSLog(@"Done Pressed!");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CMSettingsDetailViewController *sdvc = segue.destinationViewController;
    NSDictionary *dictionary;
    if ([segue.identifier isEqualToString:@"Reminder"]) {
        NSLog(@"Reminder");
        sdvc.settingsType = @"Remind Me";
        sdvc.defaultsKey = @"minutes";
        dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@5, @"5 Minutes", @10, @"10 Minutes", @15, @"15 Minutes", nil];
    } else if ([segue.identifier isEqualToString:@"Transport"]) {
        NSLog(@"Transport");
        sdvc.settingsType = @"Transport Method";
        sdvc.defaultsKey = @"transport";
        dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"Car", @"Car", @"Walking", @"Walking", @"Cycling", @"Cycling", nil];
    } else if ([segue.identifier isEqualToString:@"Distance"]) {
        NSLog(@"Distance");
        sdvc.settingsType = @"Distance Unit";
        sdvc.defaultsKey = @"distance";
        dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"meters", @"Meters", @"Kilometers", @"Kilometers", @"Miles", @"Miles", nil];
    }
    sdvc.options = dictionary;
}

#pragma mark - Rotation

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
