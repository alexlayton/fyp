//
//  CMAddTestViewController.m
//  Class Mate
//
//  Created by Alex Layton on 01/02/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import "CMAddTestViewController.h"
#import "CMOptionViewController.h"
#import "CMAppDelegate.h"
#import "CMPlace.h"
#import "CMAddress.h"
#import "CMGooglePlace.h"
#import "ALLocationReminders.h"
#import "CMPair.h"

@interface CMAddTestViewController ()

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIToolbar *toolbar;

@end

@implementation CMAddTestViewController
{
    ALLocationRemindersRepeatType _repeatType;
    ALLocationRemindersTransportType _transportType;
    ALLocationReminderType _reminderType;
    int _minutes;
}

@synthesize titleTextField = _titleTextField;
@synthesize date = _date;
@synthesize place = _place;
@synthesize timeCell = _timeCell;
@synthesize repeatLabel = _repeatLabel;
@synthesize typeLabel = _typeLabel;
@synthesize locationLabel = _locationLabel;
@synthesize transportLabel = _transportLabel;
@synthesize remindLabel = _remindLabel;
@synthesize dateLabel = _dateLabel;
@synthesize datePicker = _datePicker;
@synthesize toolbar = _toolbar;
@synthesize doneButton = _doneButton;

- (void)addReminder
{
    ALLocationReminderManager *lrm = [ALLocationReminderManager sharedManager];
//    CLLocation *location = _place.location;
//    NSLog(@"Adding Reminder at: %@", location);
//    NSString *payload = _titleTextField.text;
//    [lrm addPreemptiveReminderAtLocation:location payload:payload date:_date];
    ALLocationReminder *reminder = [[ALLocationReminder alloc] init];
    reminder.location = _place.location;
    reminder.payload = _titleTextField.text;
    reminder.date = _date;
    reminder.repeat = _repeatType;
    reminder.reminderType = _reminderType;
    reminder.transport = _transportType;
    reminder.minutesBefore = _minutes;
    
    NSLog(@"Reminder: %@", reminder);
    
    [lrm addReminder:reminder];
}

- (void)loadReminderDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *defaultString = [defaults objectForKey:@"minutes"];
    _remindLabel.text = [NSString stringWithFormat:@"%@ Minutes", defaultString];
    _minutes = [defaultString intValue];
    
    defaultString = [defaults objectForKey:@"transport"];
    _transportLabel.text = [defaultString capitalizedString];
    _transportType = defaultString;
    
    defaultString = [defaults objectForKey:@"reminderType"];
    _reminderType = defaultString;
    _typeLabel.text = [defaultString capitalizedString];
    
    _repeatLabel.text = @"Never";
    _repeatType = kALRepeatTypeNever;
}

- (IBAction)donePressed:(UIBarButtonItem *)sender
{
    [self addReminder];
    _doneButton.enabled = NO;
    [CMAppDelegate customiseAppearance];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelPressed:(UIBarButtonItem *)sender
{
    _doneButton.enabled = NO;
    [CMAppDelegate customiseAppearance];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)titleChanged:(UITextField *)textField
{
    _doneButton.enabled = (![textField.text isEqualToString:@""] && _date && _place) ? YES : NO;
}

#pragma mark - TextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (_date && _place && ![textField.text isEqualToString:@""]) _doneButton.enabled = YES;
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self loadReminderDefaults];
    _doneButton.enabled = NO;
    _dateLabel.text = @" "; //hacks on hacks on hacks
    
    _titleTextField.delegate = self;
    
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
    
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timePressed:)];
    [_timeCell addGestureRecognizer:tgr];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (!_datePicker.hidden) {
        [self hidePicker];
    }
}

- (void)timePressed:(id)sender
{
    [_titleTextField resignFirstResponder];
    //NSLog(@"Time Pressed!");
    if (_datePicker.hidden) {
        //NSLog(@"is hidden");
        _datePicker.frame = CGRectMake(0, self.view.frame.size.height, _datePicker.frame.size.width, _datePicker.frame.size.height);
        _toolbar.frame = CGRectMake(0, self.view.frame.size.height, _toolbar.frame.size.width, _toolbar.frame.size.height);
        CGRect pickerFrame = _datePicker.frame;
        CGRect toolbarFrame = _toolbar.frame;
        _datePicker.hidden = NO;
        _toolbar.hidden = NO;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:_timeCell];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        self.tableView.delaysContentTouches = NO;
        self.tableView.canCancelContentTouches = NO;
        
        [UIView animateWithDuration:0.3f animations:^{
            //NSLog(@"Animating");

            _datePicker.frame = CGRectMake(0, 200, pickerFrame.size.width, pickerFrame.size.height);
            _toolbar.frame = CGRectMake(0, 156, toolbarFrame.size.width, toolbarFrame.size.height);
        }];
    }
}

- (void)hidePicker
{
    self.tableView.delaysContentTouches = YES;
    self.tableView.canCancelContentTouches = YES;
    
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
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeStyle = NSDateFormatterShortStyle;
    formatter.dateStyle = NSDateFormatterShortStyle;
    _date = _datePicker.date;
    NSString *formattedDate = [formatter stringFromDate:_date];
    _dateLabel.text = formattedDate;
    
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

#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"scrolling");
    CGRect tableBounds = self.tableView.bounds;
    CGRect pickerFrame = _datePicker.frame;
    CGRect toolbarFrame = _toolbar.frame;
    
    _datePicker.frame = CGRectMake(0, 200 + tableBounds.origin.y, pickerFrame.size.width, pickerFrame.size.height);
    _toolbar.frame = CGRectMake(0, 156 + tableBounds.origin.y, toolbarFrame.size.width, toolbarFrame.size.height);
    
    if ([_titleTextField isFirstResponder]) {
        [_titleTextField resignFirstResponder];
    }
    
//    if (!_datePicker.hidden) {
//        [self hidePicker];
//    }
}

#pragma mark - Option Delegate

- (void)optionViewController:(CMOptionViewController *)ovc didSelectOption:(CMPair *)option
{
    if ([ovc.title isEqualToString:@"Reminder Type"]) {
        _typeLabel.text = option.objDescription;
        _reminderType = option.obj;
    } else if ([ovc.title isEqualToString:@"Repeat"]) {
        _repeatLabel.text = option.objDescription;
        _repeatType = [option.obj intValue]; //repeat is int
    } else if ([ovc.title isEqualToString:@"Reminder Before"]) {
        _remindLabel.text = option.objDescription;
        //set somrthing here...
    } else if ([ovc.title isEqualToString:@"Transport"]) {
        _transportLabel.text = option.objDescription;
        _transportType = option.obj;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Address Delegate

- (void)addressView:(CMAddressViewController *)avc didSelectAddress:(CMAddress *)address
{
     _place = address;
    _locationLabel.text = address.street;
    if (_titleTextField.text && _date) _doneButton.enabled = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Places Delegate

- (void)placeView:(CMPlacesViewController *)pvc didSelectPlace:(CMGooglePlace *)place
{
    _place = place;
    _locationLabel.text = place.vicinity;
    if (_titleTextField.text && _date) _doneButton.enabled = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Favourites Delegate

- (void)favouritesView:(CMFavouritesViewController *)fvc didSelectFavourite:(CMPlace *)place
{
    _place = place;
    if ([place isKindOfClass:[CMGooglePlace class]]) {
        CMGooglePlace *gp = (CMGooglePlace *)place;
        _locationLabel.text = gp.vicinity;
    } else if ([place isKindOfClass:[CMAddress class]]) {
        CMAddress *addr = (CMAddress *)place;
        _locationLabel.text = addr.street;
    }
    if (_titleTextField.text && _date) _doneButton.enabled = YES;
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Repeat"]) {
        CMOptionViewController *ovc = segue.destinationViewController;
        ovc.delegate = self;
        ovc.title = @"Repeat";
        ovc.options = [self repeatOptions];
    } else if ([segue.identifier isEqualToString:@"Type"]) {
        CMOptionViewController *ovc = segue.destinationViewController;
        ovc.delegate = self;
        ovc.title = @"Reminder Type";
        ovc.options = [self reminderOptions];
    } else if ([segue.identifier isEqualToString:@"Remind"]) {
        CMOptionViewController *ovc = segue.destinationViewController;
        ovc.delegate = self;
        ovc.title = @"Remind Before";
        ovc.options = [self reminderMinutesOptions];
    } else if ([segue.identifier isEqualToString:@"Transport"]) {
        CMOptionViewController *ovc = segue.destinationViewController;
        ovc.delegate = self;
        ovc.title = @"Transport";
        ovc.options = [self transportOptions];
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

#pragma mark - option arrays

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
    CMPair *five = [CMPair pairWithObj:@"5" description:@"5 Minutes"];
    CMPair *ten = [CMPair pairWithObj:@"10" description:@"10 Minutes"];
    CMPair *fifteen = [CMPair pairWithObj:@"15" description:@"15 Minutes"];
    CMPair *thirty = [CMPair pairWithObj:@"30" description:@"30 Minutes"];
    CMPair *sixty = [CMPair pairWithObj:@"60" description:@"60 Minutes"];
    return @[five, ten, fifteen, thirty, sixty];
}

@end
