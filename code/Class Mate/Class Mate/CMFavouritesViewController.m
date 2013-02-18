//
//  CMFavouritesViewController.m
//  Class Mate
//
//  Created by Alex Layton on 24/01/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import "CMFavouritesViewController.h"
#import "CMAddressViewController.h"
#import "CMFavourites.h"
#import "CMPlace.h"
#import "CMAddress.h"
#import "CMGooglePlace.h"
#import "CMPlaceViewController.h"

@implementation CMFavouritesViewController

@synthesize favourites = _favourites;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarController.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editPressed:)];
    self.tabBarController.navigationItem.rightBarButtonItem = edit;
    self.tableView.contentOffset = CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);
    
    _favourites = [CMFavourites sharedFavourites];
    [self.tableView reloadData];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:self.tabBarController.selectedIndex forKey:@"selectedTab"];
    [defaults synchronize];
}

- (void)editPressed:(UIBarButtonItem *)button
{
    if (!self.tableView.editing) {
        button.style = UIBarButtonItemStyleDone;
        button.title = @"Done";
        [self.tableView setEditing:YES animated:YES];
    } else { //not editing
        button.style = UIBarButtonItemStyleBordered;
        button.title = @"Edit";
        [self.tableView setEditing:NO animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _favourites.favourites.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    CMPlace *place = [_favourites.favourites objectAtIndex:indexPath.row];
    cell.textLabel.text = place.name;
    if ([place isKindOfClass:[CMAddress class]]) {
        cell.detailTextLabel.text = [(CMAddress *)place street];
    } else if ([place isKindOfClass:[CMGooglePlace class]]) {
        cell.detailTextLabel.text = [(CMGooglePlace *)place vicinity];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [_favourites.favourites removeObjectAtIndex:indexPath.row];
        [_favourites saveData];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSUInteger from = fromIndexPath.row;
    NSUInteger to = toIndexPath.row;
    CMPlace *fromPlace = [_favourites.favourites objectAtIndex:from];
    [_favourites.favourites removeObjectAtIndex:from];
    [_favourites.favourites insertObject:fromPlace atIndex:to];
    [_favourites saveData];
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //change delegates to CMPlace not address!
    CMPlace *place = [_favourites.favourites objectAtIndex:indexPath.row];
    [_delegate favouritesView:self didSelectFavourite:place];
}

#pragma mark - Tab Bar Delegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[CMAddressViewController class]]) {
        CMAddressViewController *avc = (CMAddressViewController *)viewController;
        NSLog(@"Setting Previous!");
        avc.previousSelectedIndex = self.tabBarController.selectedIndex;
    }
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    CMPlace *place = [_favourites.favourites objectAtIndex:indexPath.row];
    CMPlaceViewController *pvc = segue.destinationViewController;
    pvc.place = place;
}

@end
