//
//  CMAddReminderTestViewController.m
//  Class Mate
//
//  Created by Alex Layton on 17/12/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "CMAddReminderViewController.h"
#import "CMPlacesViewController.h"
#import "ALLocationReminders.h"
#import "CMAppDelegate.h"
#import "CMAddress.h"
#import "CMPlace.h"

@implementation CMAddReminderViewController

@synthesize date = _date;
@synthesize minutesTextField = _minutesTextField;
@synthesize payloadTextField = _payloadTextField;
@synthesize locationLabel = _locationLabel;
@synthesize place = _place;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UIImage *patternImage = [UIImage imageNamed:@"pattern.png"];
//    UIColor *pattern = [UIColor colorWithPatternImage:patternImage];
//    CGRect backgroundRect = [[UIScreen mainScreen] applicationFrame];
//    UIView *backgroundView = [[UIView alloc] initWithFrame:backgroundRect];
//    [backgroundView setBackgroundColor:pattern];
//    self.tableView.backgroundView = backgroundView;
    
    _minutesTextField.delegate = self;
    _payloadTextField.delegate = self;
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    _minutesTextField.inputAccessoryView = numberToolbar;
}

-(void)cancelNumberPad{
    [_minutesTextField resignFirstResponder];
    _minutesTextField.text = @"";
}

-(void)doneWithNumberPad{
    //NSString *numberFromTheKeyboard = numberTextField.text;
    [_minutesTextField resignFirstResponder];
}
    
#pragma mark - TableView


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        [_minutesTextField becomeFirstResponder];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - TextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - IBActions

- (IBAction)donePressed:(UIBarButtonItem *)sender
{
    ALLocationReminderManager *lrm = [ALLocationReminderManager sharedManager];
    
    int minutes = [_minutesTextField.text integerValue];
    int seconds = minutes * 60;
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:seconds];
    
    CLLocation *location = _place.location;
    
    NSString *payload = _payloadTextField.text;
    [lrm addPreemptiveReminderAtLocation:location payload:payload date:date];
    
    [CMAppDelegate customiseAppearance];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelPressed:(UIBarButtonItem *)sender
{
    [CMAppDelegate customiseAppearance];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Places"]) {
        CMPlacesViewController *pvc = segue.destinationViewController;
        pvc.delegate = self;
    } else if ([segue.identifier isEqualToString:@"Tab Bar"]) {
        UITabBarController *tbc = segue.destinationViewController;
        NSArray *vcs = tbc.viewControllers;
        for (id vc in vcs) {
            if ([vc isKindOfClass:[CMAddressViewController class]]) {
                CMAddressViewController *avc = vc;
                avc.delegate = self;
            } else if ([vc isKindOfClass:[CMPlacesViewController class]]) {
                CMPlacesViewController *pvc = vc;
                pvc.delegate = self;
            } else if ([vc isKindOfClass:[CMFavouritesViewController class]]) {
                CMFavouritesViewController *fvc = vc;
                fvc.delegate = self;
            }
        }
    }
}

#pragma mark - Address Delegate

- (void)addressView:(CMAddressViewController *)avc didSelectAddress:(CMAddress *)address
{
    _place = address;
    _locationLabel.text = address.street;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Places Delegate

- (void)placeView:(CMPlacesViewController *)pvc didSelectPlaceDictionary:(NSDictionary *)dict
{
    //fill this in
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Favourites Delegate

- (void)favouritesView:(CMFavouritesViewController *)fvc didSelectFavourite:(CMPlace *)place
{
    //fill this in
    [self.navigationController popViewControllerAnimated:YES];
}

@end
