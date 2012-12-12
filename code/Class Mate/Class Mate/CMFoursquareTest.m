//
//  CMFoursquareTest.m
//  Class Mate
//
//  Created by Alex Layton on 12/12/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "CMFoursquareTest.h"
#import <AFNetworking/AFNetworking.h>

@implementation CMFoursquareTest

@synthesize places = _places;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self foursquare];
}

- (void)foursquare
{
    NSString *key = @"AIzaSyAH954WQQrY1AzZhQV-axqcybV6LWAvayQ";
    NSString *ll = @"52.442320,-2.066276";
    NSString *baseURL = @"https://maps.googleapis.com/maps/api/place/nearbysearch/json";
    
    NSString *urlString = [NSString stringWithFormat:@"%@?location=%@&radius=500&sensor=true&key=%@", baseURL, ll, key];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        _places = [JSON valueForKey:@"results"];
        [self.tableView reloadData];
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
    return _places.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    NSDictionary *place = [_places objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [place valueForKey:@"name"];
    cell.detailTextLabel.text = [place valueForKey:@"vicinity"];
    
    return cell;
}

- (IBAction)donePressed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
