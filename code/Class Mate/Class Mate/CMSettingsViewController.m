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
#import "CMAcknowledgementsViewController.h"

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
    [self.tableView reloadData];
}

- (BOOL)hasGoogleMaps
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ([self hasGoogleMaps]) ? 3 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger sections = tableView.numberOfSections;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Reminder Type";
            cell.detailTextLabel.text = [[defaults objectForKey:@"reminderType"] capitalizedString];
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Transport";
            cell.detailTextLabel.text = [[defaults objectForKey:@"transport"] capitalizedString];
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"Alert";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ Minutes Before", [defaults objectForKey:@"minutes"]];
        }
    } else if (indexPath.section == 1 && sections == 3) {
        cell.textLabel.text = @"Navigation";
        cell.detailTextLabel.text = [defaults objectForKey:@"navigation"];
    } else {
        cell.textLabel.text = @"Acknowledgements";
        cell.detailTextLabel.text = nil;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header;
    if (section == 0) {
        header = @"Reminders";
    } else if (section == 1 && tableView.numberOfSections == 3) {
        header = @"Maps";
    }
    return header;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *footer;
    if (section == self.tableView.numberOfSections - 1) {
        NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
        NSString *build = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
        footer = [NSString stringWithFormat:@"Class Mate %@ (%@) \n Copyright © Alex Layton 2013. \n All Rights Reserved.", version, build];
    }
    return footer;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CMSettingsDetailViewController *sdvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsDetailViewController"];
        NSArray *options;
        if (indexPath.row == 0) { //type
            sdvc.settingsType = @"Reminder Type";
            sdvc.defaultsKey = @"reminderType";
            options = @[[CMPair pairWithObj:kALLocationReminderTypePreemptive description:@"Preemptive"], [CMPair pairWithObj:kALLocationReminderTypeLocation description:@"Location"], [CMPair pairWithObj:kALLocationReminderTypeDate description:@"Date"]];
        } else if (indexPath.row == 1) { //transport
            sdvc.settingsType = @"Transport Method";
            sdvc.defaultsKey = @"transport";
            options = @[[CMPair pairWithObj:kALLocationRemindersTransportTypeDriving description:@"Driving"], [CMPair pairWithObj:kALLocationRemindersTransportTypeWalking description:@"Walking"], [CMPair pairWithObj:kALLocationRemindersTransportTypeCycling description:@"Cycling"]];
        } else if (indexPath.row == 2) { //alert
            sdvc.settingsType = @"Alert";
            sdvc.defaultsKey = @"minutes";
            options = @[[CMPair pairWithObj:@"0" description:@"On Time"], [CMPair pairWithObj:@"5" description:@"5 Minutes Before"], [CMPair pairWithObj:@"10" description:@"10 Minutes Before"], [CMPair pairWithObj:@"15" description:@"15 Minutes Before"]];
        }
        sdvc.options = options;
        [self.navigationController pushViewController:sdvc animated:YES];
    } else if (indexPath.section == 1 && tableView.numberOfSections == 3) { //navigation
        CMSettingsDetailViewController *sdvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsDetailViewController"];
        sdvc.settingsType = @"Navigation";
        sdvc.defaultsKey = @"navigation";
        sdvc.options = @[[CMPair pairWithObj:@"Apple Maps" description:@"Apple Maps"], [CMPair pairWithObj:@"Google Maps" description:@"Google Maps"]];
        [self.navigationController pushViewController:sdvc animated:YES];
    } else { //acknowledgements
        CMAcknowledgementsViewController *avc = [self.storyboard instantiateViewControllerWithIdentifier:@"AcknowledgementsViewController"];
        [self.navigationController pushViewController:avc animated:YES];
    }
}

- (IBAction)donePressed:(UIBarButtonItem *)sender
{
    NSLog(@"Done Pressed!");
    [CMAppDelegate customiseAppearance];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
