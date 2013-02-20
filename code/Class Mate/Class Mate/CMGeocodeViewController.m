//
//  CMGeocodeViewController.m
//  Class Mate
//
//  Created by Alex Layton on 13/02/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import "CMGeocodeViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AFNetworking/AFNetworking.h>
#import "CMGeocodePlace.h"
#import "CMPlaceViewController.h"

@implementation CMGeocodeViewController

@synthesize places = _places;
@synthesize searchPlaces = _searchPlaces;
@synthesize delegate = _delegate;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _places = [NSKeyedUnarchiver unarchiveObjectWithFile:[self archivePath]];
    if (!_places) {
        _places = [[NSMutableArray alloc] initWithCapacity:10];
    } else {
        NSLog(@"Reloading!");
    }
    [self.tableView reloadData];
}

- (void)saveData
{
    NSLog(@"Saving Store");
    NSString *path = [self archivePath];
    [NSKeyedArchiver archiveRootObject:_places toFile:path];
}

- (NSString *)archivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"recentPlaces.data"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self saveData];
}

- (void)geocodeAddressWithGoogleMaps:(NSString *)address
{
    NSString *baseURL = @"https://maps.googleapis.com/maps/api/geocode/json";
    NSString *newAddress = [address stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *urlString = [NSString stringWithFormat:@"%@?address=%@&sensor=true", baseURL, newAddress];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"String: %@, url: %@", urlString, url);
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSArray *results = [JSON objectForKey:@"results"];
        NSMutableArray *output = [[NSMutableArray alloc] initWithCapacity:results.count];
        for (NSDictionary *dict in results) {
            //coords
            NSDictionary *geometry = [dict objectForKey:@"geometry"];
            NSDictionary *locationDict = [geometry objectForKey:@"location"];
            double lat = [[locationDict objectForKey:@"lat"] doubleValue];
            double lon = [[locationDict objectForKey:@"lng"] doubleValue];
            CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
            
            //formatted address for titleLabel
            NSString *address = [dict objectForKey:@"formatted_address"];
            
            //country for detail label
            NSString *country;
            NSArray *addressComponents = [dict objectForKey:@"address_components"];
            for (NSDictionary *addressComponent in addressComponents) {
                BOOL found = NO;
                NSArray *types = [addressComponent objectForKey:@"types"];
                for (NSString *type in types) {
                    if ([type isEqualToString:@"country"]) {
                        found = YES;
                        break;
                    }
                }
                if (found) {
                    country = [addressComponent objectForKey:@"long_name"];
                    break;
                }
            }
            
            CMGeocodePlace *geocodePlace = [[CMGeocodePlace alloc] initWithAddress:address country:country location:location];
            [output addObject:geocodePlace];
        }
        _searchPlaces = [NSArray arrayWithArray:output];
        [self.searchDisplayController.searchResultsTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    } failure:nil];
    [operation start];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = (tableView == self.searchDisplayController.searchResultsTableView) ? _searchPlaces.count : _places.count;
    NSLog(@"%d", num);
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    CMGeocodePlace *place = (tableView == self.searchDisplayController.searchResultsTableView) ? [_searchPlaces objectAtIndex:indexPath.row] : [_places objectAtIndex:indexPath.row];

    NSLog(@"Place: %@, Location: %@", place.name, place.location);
    
    cell.textLabel.text = place.name;
    cell.detailTextLabel.text = place.country;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    CMGeocodePlace *place;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        place = [_searchPlaces objectAtIndex:indexPath.row];
        [_places insertObject:place atIndex:0];
        NSLog(@"Places: %@", _places);
    } else {
        place = [_places objectAtIndex:indexPath.row];
    }
    [_delegate geocodeViewController:self didSelectPlace:place];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    CMGeocodePlace *place = (tableView == self.searchDisplayController.searchResultsTableView) ? [_searchPlaces objectAtIndex:indexPath.row] : [_places objectAtIndex:indexPath.row];
    CMPlaceViewController *pvc = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaceViewController"];
    pvc.place = place;
    [self.navigationController pushViewController:pvc animated:YES];
}

#pragma mark - Search

- (void)filterContentForSearchString:(NSString *)searchString scope:(NSString *)scope
{
    NSLog(@"Should filter...");
    [self geocodeAddressWithGoogleMaps:searchString];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
//    [self filterContentForSearchString:searchString scope:[self.searchDisplayController.searchBar.scopeButtonTitles objectAtIndex:self.searchDisplayController.searchBar.selectedScopeButtonIndex]];
    return NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
//    [self filterContentForSearchString:self.searchDisplayController.searchBar.text scope:[self.searchDisplayController.searchBar.scopeButtonTitles objectAtIndex:self.searchDisplayController.searchBar.selectedScopeButtonIndex]];
    return NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"Searching...|");
    [self filterContentForSearchString:searchBar.text scope:[self.searchDisplayController.searchBar.scopeButtonTitles objectAtIndex:self.searchDisplayController.searchBar.selectedScopeButtonIndex]];
}

@end
