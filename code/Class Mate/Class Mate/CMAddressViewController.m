//
//  CMAddressTestViewController.m
//  Class Mate
//
//  Created by Alex Layton on 17/01/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import "CMAddressViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import "CMAddress.h"

@implementation CMAddressViewController

@synthesize addresses = _addresses;
@synthesize results = _results;
@synthesize previousSelectedIndex = _previousSelectedIndex;
@synthesize delegate = _delegate;

- (void)loadAddresses
{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusDenied) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            NSLog(@"Requesting Access to Address Book");
            if (granted) {
                NSLog(@"Access Granted!");
                CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
                CFIndex count = ABAddressBookGetPersonCount(addressBook);
                _addresses = [[NSMutableArray alloc] initWithCapacity:count];
                
                NSLog(@"Count: %ld", count);
                for (int i = 0; i < count; i++) {
                    ABRecordRef record = CFArrayGetValueAtIndex(people, i);
                    NSString *first = (__bridge NSString *)ABRecordCopyValue(record, kABPersonFirstNameProperty);
                    NSString *last = (__bridge NSString *)ABRecordCopyValue(record, kABPersonLastNameProperty);
                    NSString *name = [NSString stringWithFormat:@"%@ %@", first, last];
                    
                    ABMultiValueRef addressesRef = ABRecordCopyValue(record, kABPersonAddressProperty);
                    for (int j = 0; j < ABMultiValueGetCount(addressesRef); j++) {
                        CFDictionaryRef dictRef = ABMultiValueCopyValueAtIndex(addressesRef, j);
                        if (first) {
                            CMAddress *address = [[CMAddress alloc] initWithName:name addressReference:dictRef];
                            if (address.street) [_addresses addObject:address];
                        }
                    }
                }
                NSLog(@"About to reload");
                [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            } else {
                NSLog(@"Access Denied!");
                [self accessDenied];
                //notify user and pop off view controller

            }
        });
    } else { //access denied
        NSLog(@"Access Denied! %ld", ABAddressBookGetAuthorizationStatus());
        [self accessDenied];
    }
}

- (void)accessDenied
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Access Denied!" message:@"Could not access Address Book" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alert show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchDisplayController.searchBar.delegate = self;
    self.tableView.contentOffset = CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadAddresses];
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"dismissed alertview");
    //[self.navigationController popViewControllerAnimated:YES];
    NSLog(@"%d", _previousSelectedIndex);
    self.tabBarController.selectedIndex = _previousSelectedIndex;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (tableView == self.searchDisplayController.searchResultsTableView) ? _results.count : _addresses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    CMAddress *address = (tableView == self.searchDisplayController.searchResultsTableView) ? [_results objectAtIndex:indexPath.row] : [_addresses objectAtIndex:indexPath.row];
    
    cell.textLabel.text = address.name;
    cell.detailTextLabel.text = address.street;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_delegate addressView:self didSelectAddress:[_addresses objectAtIndex:indexPath.row]];
}

#pragma mark - Search

- (void)filterContentForSearchString:(NSString *)searchString scope:(NSString *)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@", searchString];
    _results = [NSArray arrayWithArray:[_addresses filteredArrayUsingPredicate:resultPredicate]];
    NSLog(@"Results: %@", _results);
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchString:searchString scope:[self.searchDisplayController.searchBar.scopeButtonTitles objectAtIndex:self.searchDisplayController.searchBar.selectedScopeButtonIndex]];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchString:self.searchDisplayController.searchBar.text scope:[self.searchDisplayController.searchBar.scopeButtonTitles objectAtIndex:self.searchDisplayController.searchBar.selectedScopeButtonIndex]];
    return YES;
}

@end
