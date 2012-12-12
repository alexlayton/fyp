//
//  CMRemindersViewController.m
//  Class Mate
//
//  Created by Alex Layton on 28/11/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "CMRemindersViewController.h"
#import "ALLocationReminders.h"
#import "CMReminderViewController.h"

@implementation CMRemindersViewController

@synthesize reminders = _reminders;
@synthesize reminderType = _reminderType;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Title: %@", _reminderType);
    UINavigationItem *nav = self.navigationItem;
    nav.title = _reminderType;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _reminders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Reminder Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
   
    ALLocationReminder *reminder = [_reminders objectAtIndex:indexPath.row];
    cell.textLabel.text = reminder.payload;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", reminder.date];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_reminders removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    ALLocationReminder *reminder = [_reminders objectAtIndex:indexPath.row];
    CMReminderViewController *rvc = segue.destinationViewController;
    rvc.reminder = reminder;
}

- (IBAction)editPressed:(UIBarButtonItem *)sender
{
    NSLog(@"%@", sender.title);
    if ([sender.title isEqualToString:@"Edit"]) {
        NSLog(@"edit");
        [self.tableView setEditing:YES animated:YES];
        [sender setTitle:@"Done"];
    } else if ([sender.title isEqualToString:@"Done"]) {
        NSLog(@"done");
        [self.tableView setEditing:NO animated:YES];
        [sender setTitle:@"Edit"];
    }
}

- (IBAction)addPressed:(UIBarButtonItem *)sender {
}

@end
