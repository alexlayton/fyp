//
//  CMAddReminderTestViewController.m
//  Class Mate
//
//  Created by Alex Layton on 01/03/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import "CMAddReminderTestViewController.h"
#import "CMOptionViewController.h"
#import "CMAppDelegate.h"
#import "CMPlace.h"
#import "CMAddress.h"
#import "CMGeocodePlace.h"
#import "CMGooglePlace.h"
#import "ALLocationReminders.h"
#import "CMPair.h"
#import <AFNetworking/AFJSONRequestOperation.h>

@interface CMAddReminderTestViewController ()

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, weak) UITextField *editingTextField;
@property (nonatomic, weak) UIDatePicker *editingDatePicker;
@property (nonatomic, strong) NSString *repeatString;

@end

@implementation CMAddReminderTestViewController
{
    ALLocationRemindersRepeatType _repeatType;
    ALLocationRemindersTransportType _transportType;
    int _minutes;
    BOOL _canAddReminder;
}

@synthesize date = _date;
@synthesize place = _place;
@synthesize reminderTitle = _reminderTitle;
@synthesize datePicker = _datePicker;
@synthesize toolbar = _toolbar;
@synthesize doneButton = _doneButton;
@synthesize reminderType = _reminderType;
@synthesize editingTextField = _editingTextField;
@synthesize editingDatePicker = _editingDatePicker;
@synthesize repeatString = _repeatString;

- (void)addReminder
{
    ALLocationReminderManager *lrm = [ALLocationReminderManager sharedManager];
    ALLocationReminder *reminder = [[ALLocationReminder alloc] init];
    reminder.location = _place.location;
    reminder.payload = _reminderTitle;
    reminder.date = _date;
    reminder.repeat = _repeatType;
    reminder.reminderType = _reminderType;
    reminder.transport = _transportType;
    reminder.minutesBefore = _minutes;
    reminder.locationString = _place.name;
    
    void (^successBlock)(void) = ^{
        [self performSelectorOnMainThread:@selector(reminderAdded) withObject:nil waitUntilDone:NO];
    };
    
    void (^failureBlock)(void);
    
    if ([reminder.reminderType isEqualToString:kALLocationReminderTypePreemptive]) {
        failureBlock = ^{
            NSString *message = @"Choose a later date";
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:message waitUntilDone:NO];
        };
    } else if ([reminder.reminderType isEqualToString:kALLocationReminderTypeLocation]) {
        failureBlock = ^{
            NSString *message = @"Already at location";
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:message waitUntilDone:NO];
        };
    }
    
    [lrm addReminder:reminder success:successBlock failure:failureBlock];
}

- (void)showAlert:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't add Reminder" message:message delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alert show];
}

- (void)reminderAdded
{
    _doneButton.enabled = NO;
    [CMAppDelegate customiseAppearance];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadReminderDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *defaultString = [defaults objectForKey:@"minutes"];
    _minutes = [defaultString intValue];
    
    defaultString = [defaults objectForKey:@"transport"];
    _transportType = defaultString;
    
    defaultString = (_reminderType) ? _reminderType : [defaults objectForKey:@"reminderType"];
    _reminderType = defaultString;
    
    _repeatType = kALRepeatTypeNever;
    _repeatString = @"Never";
}


#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _doneButton.enabled = NO;
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 200, 320, 216)];
    _datePicker.hidden = YES;
    _datePicker.minimumDate = [NSDate date];
    [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 156, 320, 44)];
    _toolbar.hidden = YES;
    _toolbar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pickerCancelPressed:)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDonePressed:)];
    [_toolbar setItems:@[cancel, flexibleSpace, done]];
    
    [self.view addSubview:_datePicker];
    [self.view addSubview:_toolbar];
    
    [self loadReminderDefaults];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (!_datePicker.hidden) {
        [self hidePicker];
    }
}

#pragma mark - Date Picker

- (void)showPicker
{
    if (_datePicker.hidden) {
        if ([_reminderType isEqualToString:kALLocationReminderTypeLocation]) {
            _datePicker.datePickerMode = UIDatePickerModeDate;
        } else {
            _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        }
        
        _editingDatePicker = _datePicker;
        
        _datePicker.frame = CGRectMake(0, self.view.frame.size.height, _datePicker.frame.size.width, _datePicker.frame.size.height);
        _toolbar.frame = CGRectMake(0, self.view.frame.size.height, _toolbar.frame.size.width, _toolbar.frame.size.height);
        CGRect pickerFrame = _datePicker.frame;
        CGRect toolbarFrame = _toolbar.frame;
        _datePicker.hidden = NO;
        _toolbar.hidden = NO;
        
        self.tableView.delaysContentTouches = NO;
        self.tableView.canCancelContentTouches = NO;
        
        NSLog(@"Starting Origin Y: %f", pickerFrame.origin.y);
        
        CGFloat newPickerYOrigin = self.view.frame.size.height - pickerFrame.size.height;
        CGFloat newToolbarYOrigin = newPickerYOrigin - toolbarFrame.size.height;
        
        [UIView animateWithDuration:0.3f animations:^{
            //NSLog(@"Animating");
            _datePicker.frame = CGRectMake(0, newPickerYOrigin, pickerFrame.size.width, pickerFrame.size.height);
            _toolbar.frame = CGRectMake(0, newToolbarYOrigin, toolbarFrame.size.width, toolbarFrame.size.height);
        }];
    }
}

- (void)hidePicker
{
    self.tableView.delaysContentTouches = YES;
    self.tableView.canCancelContentTouches = YES;
    
    _editingDatePicker = nil;
    
    [UIView animateWithDuration:0.3f animations:^{
        _datePicker.frame = CGRectMake(0, self.view.frame.size.height, _datePicker.frame.size.width, _datePicker.frame.size.height);
        _toolbar.frame = CGRectMake(0, self.view.frame.size.height, _toolbar.frame.size.width, _toolbar.frame.size.height);
    } completion:^(BOOL finished) {
        _datePicker.hidden = YES;
        _toolbar.hidden = YES;
    }];
}

- (void)pickerDonePressed:(id)sender
{
    _date = _datePicker.date;
    [self.tableView reloadData];
    [self hidePicker];
}

- (void)pickerCancelPressed:(id)sender
{
    [self hidePicker];
}

- (void)datePickerValueChanged:(id)sender
{
    _date = _datePicker.date;
}


#pragma mark - IBOutlets

- (IBAction)donePressed:(UIBarButtonItem *)sender
{
    [self addReminder];
}

- (IBAction)cancelPressed:(UIBarButtonItem *)sender
{
    _doneButton.enabled = NO;
    [CMAppDelegate customiseAppearance];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    if (section == 0) {
        rows = 4;
    } else {
        if ([_reminderType isEqualToString:kALLocationReminderTypePreemptive]) {
            rows = 3;
        } else {
            rows = 1;
        }
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) identifier = @"Title Cell";
        else if (indexPath.row == 2) identifier = @"Time Cell";
        else identifier = @"Cell";
    } else {
        identifier = @"Cell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSArray *views = cell.contentView.subviews;
            for (UIView *view in views) {
                if ([view isKindOfClass:[UITextField class]]) {
                    UITextField *textField = (UITextField *)view;
                    textField.delegate = self;
                }
            }
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Type";
            cell.detailTextLabel.text = [_reminderType capitalizedString];
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"Date";
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.timeStyle = ([_reminderType isEqualToString:kALLocationReminderTypeLocation]) ? NSDateFormatterNoStyle : NSDateFormatterShortStyle;
            formatter.dateStyle = NSDateFormatterShortStyle;
            cell.detailTextLabel.text = [formatter stringFromDate:_date];
        } else {
            cell.textLabel.text = @"Location";
            cell.detailTextLabel.text = _place.name;
        }
    } else { //section == 1
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Repeat";
            cell.detailTextLabel.text = _repeatString;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Transport";
            cell.detailTextLabel.text = [_transportType capitalizedString];
        } else {
            cell.textLabel.text = @"Remind";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d minutes", _minutes];
        }
    }
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_editingTextField) {
        [_editingTextField resignFirstResponder];
    }
    if (_editingDatePicker) {
        [self hidePicker];
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *title = cell.textLabel.text;
    if ([title isEqualToString:@"Type"]) {
        CMOptionViewController *ovc = [self.storyboard instantiateViewControllerWithIdentifier:@"OptionViewController"];
        ovc.delegate = self;
        ovc.title = @"Reminder Type";
        ovc.options = [self reminderOptions];
        [self.navigationController pushViewController:ovc animated:YES];
    } else if ([title isEqualToString:@"Date"]) {
        [self showPicker];
    } else if ([title isEqualToString:@"Location"]) {
        UITabBarController *tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
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
            } else if ([vc isKindOfClass:[CMGeocodeViewController class]]) {
                CMGeocodeViewController *gvc = vc;
                gvc.delegate = self;
            }
        }
        [self.navigationController pushViewController:tbc animated:YES];
    } else if ([title isEqualToString:@"Repeat"]) {
        CMOptionViewController *ovc = [self.storyboard instantiateViewControllerWithIdentifier:@"OptionViewController"];
        ovc.delegate = self;
        ovc.title = @"Repeat";
        ovc.options = [self repeatOptions];
        [self.navigationController pushViewController:ovc animated:YES];
    } else if ([title isEqualToString:@"Transport"]) {
        CMOptionViewController *ovc = [self.storyboard instantiateViewControllerWithIdentifier:@"OptionViewController"];
        ovc.delegate = self;
        ovc.title = @"Transport";
        ovc.options = [self transportOptions];
        [self.navigationController pushViewController:ovc animated:YES];
    } else if ([title isEqualToString:@"Remind"]) { //"Remind"
        CMOptionViewController *ovc = [self.storyboard instantiateViewControllerWithIdentifier:@"OptionViewController"];
        ovc.delegate = self;
        ovc.title = @"Remind Before";
        ovc.options = [self reminderMinutesOptions];
        [self.navigationController pushViewController:ovc animated:YES];
    }
}

#pragma mark - TextField

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_editingDatePicker) {
        [self hidePicker];
    }
    _editingTextField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _editingTextField = nil;
    if (_date && _place && ![textField.text isEqualToString:@""]) _doneButton.enabled = YES;
    _reminderTitle = textField.text;
}

#pragma mark - Address Delegate

- (void)addressView:(CMAddressViewController *)avc didSelectAddress:(CMAddress *)address
{
    _place = address;
    if (_reminderTitle && _date) _doneButton.enabled = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Places Delegate

- (void)placeView:(CMPlacesViewController *)pvc didSelectPlace:(CMGooglePlace *)place
{
    _place = place;
    if (_reminderTitle && _date) _doneButton.enabled = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Favourites Delegate

- (void)favouritesView:(CMFavouritesViewController *)fvc didSelectFavourite:(CMPlace *)place
{
    _place = place;
//    if ([place isKindOfClass:[CMGooglePlace class]]) {
//        CMGooglePlace *gp = (CMGooglePlace *)place;
//        _locationLabel.text = gp.vicinity;
//    } else if ([place isKindOfClass:[CMAddress class]]) {
//        CMAddress *addr = (CMAddress *)place;
//        _locationLabel.text = addr.street;
//    }
    if (_reminderTitle && _date) _doneButton.enabled = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Geocode Delegate

- (void)geocodeViewController:(CMGeocodeViewController *)gvc didSelectPlace:(CMGeocodePlace *)place
{
    _place = place;
    if (_reminderTitle && _date) _doneButton.enabled = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Option Delegate

- (void)optionViewController:(CMOptionViewController *)ovc didSelectOption:(CMPair *)option
{
    if ([ovc.title isEqualToString:@"Reminder Type"]) {
        _reminderType = option.obj;
    } else if ([ovc.title isEqualToString:@"Repeat"]) {
        _repeatString = option.objDescription;
        _repeatType = [option.obj intValue]; //repeat is int
    } else if ([ovc.title isEqualToString:@"Remind Before"]) {
        _minutes = [option.obj intValue];
    } else if ([ovc.title isEqualToString:@"Transport"]) {
        _transportType = option.obj;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Option Arrays

- (NSArray *)repeatOptions
{
    CMPair *never = [CMPair pairWithObj:[NSString stringWithFormat:@"%d", kALRepeatTypeNever] description:@"Never"];
    CMPair *hour = [CMPair pairWithObj:[NSString stringWithFormat:@"%d", kALRepeatTypeHour] description:@"Hour"];
    CMPair *day = [CMPair pairWithObj:[NSString stringWithFormat:@"%d", kALRepeatTypeDay] description:@"Day"];
    CMPair *week = [CMPair pairWithObj:[NSString stringWithFormat:@"%d", kALRepeatTypeWeek] description:@"Week"];
    CMPair *month = [CMPair pairWithObj:[NSString stringWithFormat:@"%d", kALRepeatTypeMonth] description:@"Month"];
    return @[never, hour, day, week, month];
}

- (NSArray *)reminderOptions
{
    CMPair *preemptive = [CMPair pairWithObj:kALLocationReminderTypePreemptive description:@"Preemptive"];
    CMPair *location = [CMPair pairWithObj:kALLocationReminderTypeLocation description:@"Location"];
    CMPair *date = [CMPair pairWithObj:kALLocationReminderTypeDate description:@"Date"];
    return @[preemptive, location, date];
}

- (NSArray *)transportOptions
{
    CMPair *driving = [CMPair pairWithObj:kALLocationRemindersTransportTypeDriving description:@"Driving"];
    CMPair *walking = [CMPair pairWithObj:kALLocationRemindersTransportTypeWalking description:@"Walking"];
    CMPair *cycling = [CMPair pairWithObj:kALLocationRemindersTransportTypeCycling description:@"Cycling"];
    return @[driving, walking, cycling];
}

- (NSArray *)reminderMinutesOptions
{
    CMPair *zero = [CMPair pairWithObj:@"0" description:@"0 Minutes"];
    CMPair *five = [CMPair pairWithObj:@"5" description:@"5 Minutes"];
    CMPair *ten = [CMPair pairWithObj:@"10" description:@"10 Minutes"];
    CMPair *fifteen = [CMPair pairWithObj:@"15" description:@"15 Minutes"];
    CMPair *thirty = [CMPair pairWithObj:@"30" description:@"30 Minutes"];
    CMPair *sixty = [CMPair pairWithObj:@"60" description:@"60 Minutes"];
    return @[zero, five, ten, fifteen, thirty, sixty];
}

@end
