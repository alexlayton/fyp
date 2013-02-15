//
//  CMApplePlacesViewController.m
//  Class Mate
//
//  Created by Alex Layton on 13/02/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import "CMApplePlacesViewController.h"
#import <MapKit/MapKit.h>
#import "ALLocationReminders.h"

@implementation CMApplePlacesViewController

@synthesize places = _places;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self localSearchForQuery:@" "];
}

- (void)localSearchForQuery:(NSString *)query
{
    ALLocationReminderManager *manager = [ALLocationReminderManager sharedManager];
    CLLocation *location = manager.currentLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 5000, 5000);
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = query;
    request.region = region;
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (error) NSLog(@"Error!: %@", error.localizedDescription);
        _places = response.mapItems;
        if (self.tableView == self.searchDisplayController.searchResultsTableView) {
            [self.searchDisplayController.searchResultsTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        } else {
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    }];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _places.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    MKMapItem *mapItem = [_places objectAtIndex:indexPath.row];
    cell.textLabel.text = mapItem.name;
    cell.detailTextLabel.text = mapItem.placemark.postalCode;
    return cell;
}

#pragma mark - Search

- (void)filterContentForSearchString:(NSString *)searchString scope:(NSString *)scope
{
    NSLog(@"Should filter...");
    [self localSearchForQuery:searchString];
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
