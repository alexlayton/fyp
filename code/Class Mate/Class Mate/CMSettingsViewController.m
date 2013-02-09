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
#import "CMAppDelegate.h"
#import "CMPair.h"

@implementation CMSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    UIImage *patternImage = [UIImage imageNamed:@"pattern.png"];
//    UIColor *pattern = [UIColor colorWithPatternImage:patternImage];
//    CGRect backgroundRect = [[UIScreen mainScreen] applicationFrame];
//    UIView *backgroundView = [[UIView alloc] initWithFrame:backgroundRect];
//    [backgroundView setBackgroundColor:pattern];
//    self.tableView.backgroundView = backgroundView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _distanceLabel.text = [[defaults objectForKey:@"distance"] capitalizedString];
    _transportLabel.text = [[defaults objectForKey:@"transport"] capitalizedString];
    _reminderLabel.text = [NSString stringWithFormat:@"%@ Minutes", [defaults objectForKey:@"minutes"]];
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
    [CMAppDelegate customiseAppearance];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CMSettingsDetailViewController *sdvc = segue.destinationViewController;
    NSArray *options;
    if ([segue.identifier isEqualToString:@"Reminder"]) {
        NSLog(@"Reminder");
        sdvc.settingsType = @"Remind Me";
        sdvc.defaultsKey = @"minutes";
        options = @[[CMPair pairWithObj:@"5" description:@"5 Minutes"], [CMPair pairWithObj:@"10" description:@"10 Minutes"], [CMPair pairWithObj:@"15" description:@"15 Minutes"]];
    } else if ([segue.identifier isEqualToString:@"Transport"]) {
        NSLog(@"Transport");
        sdvc.settingsType = @"Transport Method";
        sdvc.defaultsKey = @"transport";
        options = @[[CMPair pairWithObj:kALLocationRemindersTransportTypeDriving description:@"Driving"], [CMPair pairWithObj:kALLocationRemindersTransportTypeWalking description:@"Walking"], [CMPair pairWithObj:kALLocationRemindersTransportTypeCycling description:@"Cycling"]];
    } else if ([segue.identifier isEqualToString:@"Distance"]) {
        NSLog(@"Distance");
        sdvc.settingsType = @"Distance Unit";
        sdvc.defaultsKey = @"distance";
        options = @[[CMPair pairWithObj:@"meters" description:@"Meters"], [CMPair pairWithObj:@"kilometers" description:@"Kilometers"], [CMPair pairWithObj:@"miles" description:@"Miles"]];
    }
    sdvc.options = options;
}

@end
