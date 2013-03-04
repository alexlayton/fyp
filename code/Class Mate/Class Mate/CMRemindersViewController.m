//
//  CMRemindersViewController.m
//  Class Mate
//
//  Created by Alex Layton on 28/11/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "CMRemindersViewController.h"
#import "ALLocationReminders.h"
#import "CMAppDelegate.h"
#import "CMAddReminderViewController.h"
#import "CMAddReminderTestViewController.h"

@interface CMRemindersViewController ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation CMRemindersViewController

@synthesize reminders = _reminders;
@synthesize reminderType = _reminderType;
@synthesize dateFormatter = _dateFormatter;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Title: %@", _reminderType);
    UINavigationItem *nav = self.navigationItem;
    nav.title = _reminderType;
    
    //date formatter
    _dateFormatter = [[NSDateFormatter alloc] init];
    _dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    _dateFormatter.timeStyle = ([_reminderType isEqualToString:kALLocationReminderTypeLocation]) ? NSDateFormatterNoStyle : NSDateFormatterShortStyle;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self.navigationController setToolbarHidden:NO animated:animated];
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
    cell.detailTextLabel.text = [_dateFormatter stringFromDate:reminder.date];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteReminder:[_reminders objectAtIndex:indexPath.row] indexPath:indexPath];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Add"]) {
        [CMAppDelegate resetAppearance];
        UINavigationController *addNav = segue.destinationViewController;
        CMAddReminderTestViewController *arvc = [addNav.viewControllers objectAtIndex:0];
        arvc.reminderType = _reminderType;
    } else {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        ALLocationReminder *reminder = [_reminders objectAtIndex:indexPath.row];
        CMReminderViewController *rvc = segue.destinationViewController;
        rvc.delegate = self;
        rvc.reminder = reminder;
        rvc.dateLabel.text = [_dateFormatter stringFromDate:reminder.date];
    }
}

- (IBAction)editPressed:(UIBarButtonItem *)sender
{
    if (!self.tableView.editing) {
        [self.tableView setEditing:YES animated:YES];
        sender.title = @"Done";
        sender.style = UIBarButtonItemStyleDone;
    } else if ([sender.title isEqualToString:@"Done"]) {
        [self.tableView setEditing:NO animated:YES];
        sender.title = @"Edit";
        sender.style = UIBarButtonItemStyleBordered;
    }
}

- (void)deleteReminder:(ALLocationReminder *)reminder indexPath:(NSIndexPath *)indexPath
{
    if ([reminder.reminderType isEqualToString:kALLocationReminderTypeDate]) {
        //delete notification too!
        NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
        NSDate *newDate = [reminder.date dateByAddingTimeInterval:-60 * reminder.minutesBefore];
        for (UILocalNotification *notification in notifications) {
            if ([notification.fireDate isEqualToDate:newDate]) {
                NSLog(@"Removed Local Notification!");
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
            }
        }
        [_reminders removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else if ([reminder.reminderType isEqualToString:kALLocationReminderTypePreemptive]) {
        [_reminders removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [[ALLocationReminderManager sharedManager] updatePreemptiveReminders];
    } else {
        [_reminders removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Reminder View Delegate

- (void)reminderViewController:(CMReminderViewController *)rvc didDeleteReminder:(ALLocationReminder *)reminder
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [self deleteReminder:reminder indexPath:indexPath];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
