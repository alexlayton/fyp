//
//  CMSettingsDetailViewController.m
//  Class Mate
//
//  Created by Alex Layton on 03/12/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "CMSettingsDetailViewController.h"

@interface CMSettingsDetailViewController ()

@property (nonatomic, strong) NSIndexPath *currentValuePostion;

@end

@implementation CMSettingsDetailViewController

@synthesize defaultsKey = _defaultsKey;
@synthesize currentValue = _currentValue;
@synthesize options = _options;
@synthesize currentValuePostion = _currentValuePostion;
@synthesize settingsType = _settingsType;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UIImage *patternImage = [UIImage imageNamed:@"pattern.png"];
//    UIColor *pattern = [UIColor colorWithPatternImage:patternImage];
//    CGRect backgroundRect = [[UIScreen mainScreen] applicationFrame];
//    UIView *backgroundView = [[UIView alloc] initWithFrame:backgroundRect];
//    [backgroundView setBackgroundColor:pattern];
//    self.tableView.backgroundView = backgroundView;
    
    UINavigationItem *nav = self.navigationItem;
    nav.title = _settingsType;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _currentValue = [defaults objectForKey:_defaultsKey];
}

- (void)saveSelection:(id)value
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:_defaultsKey];
    [defaults synchronize];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _options.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    NSString *key = [_options.allKeys objectAtIndex:indexPath.row];

    cell.textLabel.text = key;
    
    id obj = [_options objectForKey:key];
    if ([obj isEqual:_currentValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        _currentValuePostion = indexPath;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    UITableViewCell *currentValueCell = [self.tableView cellForRowAtIndexPath:_currentValuePostion];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        currentValueCell.accessoryType = UITableViewCellAccessoryNone;
        [self saveSelection:[_options objectForKey:[_options.allKeys objectAtIndex:indexPath.row]]];
        _currentValuePostion = indexPath;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Rotation

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
