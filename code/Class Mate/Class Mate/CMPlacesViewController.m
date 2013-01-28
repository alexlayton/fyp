//
//  CMPlaceViewController.m
//  Class Mate
//
//  Created by Alex Layton on 17/12/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "CMPlacesViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "ALLocationReminders.h"
#import "CMAddressViewController.h"

@interface CMPlacesViewController ()

@property (nonatomic) NSUInteger selectedIndex;

@end

@implementation CMPlacesViewController

@synthesize searchBar = _searchBar;
@synthesize nearbyPlaces = _nearbyPlaces;
@synthesize filteredPlaces = _filteredPlaces;
@synthesize delegate = _delegate;
@synthesize selectedIndex = _selectedIndex;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //delegates
    self.tabBarController.delegate = self;
    self.searchDisplayController.searchBar.delegate = self;
    
    _selectedIndex = self.tabBarController.selectedIndex;
    self.tableView.contentOffset = CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);
//    _searchBar.backgroundImage = [UIImage imageNamed:@"searchbar.png"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showNearbyPlaces];
}

- (void)showNearbyPlaces
{
    NSLog(@"About to show nearby places...");
    ALLocationReminderManager *manager = [ALLocationReminderManager sharedManager];
    CLLocation *location = manager.currentLocation;
    NSLog(@"Location: %@", location);
    
    NSString *key = @"AIzaSyAH954WQQrY1AzZhQV-axqcybV6LWAvayQ";
    NSString *ll = [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude]; //last location
    NSString *baseURL = @"https://maps.googleapis.com/maps/api/place/nearbysearch/json";
    
    NSString *urlString = [NSString stringWithFormat:@"%@?location=%@&radius=500&sensor=true&key=%@", baseURL, ll, key];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"Date: %@", JSON);
        _nearbyPlaces = [JSON valueForKey:@"results"];
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    } failure:nil];
    [operation start];
}

- (void)showNearbyPlacesForSearchString:(NSString *)searchString
{
    NSLog(@"About to show filtered places...");
    ALLocationReminderManager *manager = [ALLocationReminderManager sharedManager];
    CLLocation *location = manager.currentLocation;
    NSLog(@"Location: %@", location);
    
    NSString *key = @"AIzaSyAH954WQQrY1AzZhQV-axqcybV6LWAvayQ";
    NSString *ll = [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude]; //last location
    NSString *baseURL = @"https://maps.googleapis.com/maps/api/place/nearbysearch/json";
    
    NSString *urlString = [NSString stringWithFormat:@"%@?location=%@&radius=500&sensor=true&key=%@&keyword=%@", baseURL, ll, key, searchString];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        _filteredPlaces = [JSON valueForKey:@"results"];
        for (NSDictionary *place in _filteredPlaces) {
            NSLog(@"%@", [place objectForKey:@"name"]);
        }
        //[self.searchDisplayController.searchResultsTableView reloadData];
        //this should work...
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    } failure:nil];
    [operation start];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (tableView == self.searchDisplayController.searchResultsTableView) ? _filteredPlaces.count : _nearbyPlaces.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *place = (tableView == self.searchDisplayController.searchResultsTableView) ? [_filteredPlaces objectAtIndex:indexPath.row] : [_nearbyPlaces objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [place valueForKey:@"name"];
    cell.detailTextLabel.text = [place valueForKey:@"vicinity"];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    [_delegate placeView:self didSelectPlaceDictionary:[_nearbyPlaces objectAtIndex:indexPath.row]];
}

#pragma mark - Search

- (void)filterContentForSearchString:(NSString *)searchString scope:(NSString *)scope
{
    NSLog(@"Should filter...");
    [self showNearbyPlacesForSearchString:searchString];
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

#pragma mark - Tab Bar Delegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[CMAddressViewController class]]) {
        NSLog(@"CMAddress!");
        CMAddressViewController *avc = (CMAddressViewController *)viewController;
        NSLog(@"%d", _selectedIndex);
        avc.previousSelectedIndex = _selectedIndex;
    }
}

@end
