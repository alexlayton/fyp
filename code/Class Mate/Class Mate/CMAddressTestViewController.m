//
//  CMAddressTestViewController.m
//  Class Mate
//
//  Created by Alex Layton on 17/01/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import "CMAddressTestViewController.h"
#import <AddressBookUI/AddressBookUI.h>

@implementation CMAddressTestViewController

@synthesize addresses = _addresses;

- (void)viewDidLoad
{
    [super viewDidLoad];

    //load addresses here...
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusDenied) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (granted) {
                CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
                CFIndex count = ABAddressBookGetPersonCount(addressBook);
                _addresses = [[NSMutableArray alloc] initWithCapacity:count];
                
                
                NSLog(@"Count: %ld", count);
                for (int i = 0; i < count; i++) {
                    ABRecordRef record = CFArrayGetValueAtIndex(people, i);
                    NSString *first = (__bridge NSString *)ABRecordCopyValue(record, kABPersonFirstNameProperty);
                    NSString *last = (__bridge NSString *)ABRecordCopyValue(record, kABPersonLastNameProperty);
                    NSString *name = [NSString stringWithFormat:@"%@ %@", first, last];
                    if (name) {
                        [_addresses addObject:name];
                    }
                    ABMultiValueRef addressesRef = ABRecordCopyValue(record, kABPersonAddressProperty);
                    for (int j = 0; j < ABMultiValueGetCount(addressesRef); j++) {
                        CFDictionaryRef dict = ABMultiValueCopyValueAtIndex(addressesRef, j);
                        NSString *zip = (NSString *)CFDictionaryGetValue(dict, kABPersonAddressZIPKey);
                        NSLog(@"Name: %@, Zip: %@", name, zip);
                    }
                }
                [self.tableView reloadData];
            }
        });
    } else { //access denied
        NSLog(@"Access Denied! %ld", ABAddressBookGetAuthorizationStatus());
    }
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
    
    cell.textLabel.text = [_addresses objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //nothing here
}

@end
