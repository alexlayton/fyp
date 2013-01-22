//
//  CMAddressTestViewController.m
//  Class Mate
//
//  Created by Alex Layton on 17/01/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import "CMAddressTestViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import "CMAddress.h"

@implementation CMAddressTestViewController

@synthesize addresses = _addresses;

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
                        CMAddress *address = [[CMAddress alloc] initWithAddressReference:dictRef];
                        
                        NSLog(@"%@", [address address]);
                        
                        if (name && address.zip) {
                            NSDictionary *dict = @{ @"name": name, @"zip": address.zip };
                            [_addresses addObject:dict];
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
    [self loadAddresses];
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"dismissed alertview");
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _addresses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *dict = [_addresses objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"name"];
    cell.detailTextLabel.text = [dict objectForKey:@"zip"];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //nothing here
}

@end
