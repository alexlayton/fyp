//
//  CMRemindersViewController.m
//  Class Mate
//
//  Created by Alex Layton on 28/11/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "CMRemindersViewController.h"
#import "ALLocationReminders.h"

@implementation CMRemindersViewController

@synthesize reminders = _reminders;

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


@end
