//
//  CMAddReminderViewController.m
//  Class Mate
//
//  Created by Alex Layton on 28/11/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "CMAddReminderOldViewController.h"
#import "SSTextView.h"
#import "CMDatePickerView.h"

@interface CMAddReminderOldViewController ()

@property (nonatomic, strong) CMDatePickerView *pickerView;

@end

@implementation CMAddReminderOldViewController

@synthesize textView = _textView;
@synthesize doneButton = _doneButton;
@synthesize pickerView = _pickerView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _textView.placeholder = @"Notes";
    _doneButton.enabled = NO;
    
    CGRect test = CGRectMake(0, 0, 320, 480);
    _pickerView = [[CMDatePickerView alloc] initWithFrame:test];
    [_pickerView addTargetForDonePressed:self action:@selector(pickerDonePressed)];
    [_pickerView setHidden:YES animated:YES];
    [self.view addSubview:_pickerView];
    
}

- (void)pickerDonePressed
{
    NSLog(@"Picker Pressed: %@", _pickerView.datePicker.date);
    [_pickerView setHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)donePressed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelPressed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pickerPressed:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"Show Picker"]) {
        [sender setTitle:@"Hide Picker" forState:UIControlStateNormal];
        [_pickerView setHidden:NO animated:YES];
    } else {
        [sender setTitle:@"Show Picker" forState:UIControlStateNormal];
        [_pickerView setHidden:YES animated:YES];
    }
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
