//
//  CMDatePickerView.m
//  Class Mate
//
//  Created by Alex Layton on 13/12/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import "CMDatePickerView.h"

#define DatePickerHeight 260
#define DatePickerPickerHeight 216 //picker in a picker!
#define DatePickerToolbarHeight 44

@interface CMDatePickerView ()

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic) CGRect originalFrame;
@property (nonatomic, strong) id target;
@property (nonatomic) SEL action;

@end

@implementation CMDatePickerView

@synthesize datePicker = _datePicker;
@synthesize toolbar = _toolbar;
@synthesize originalFrame = _originalFrame;
@synthesize target = _target;
@synthesize action = _action;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _originalFrame = frame;
        self.backgroundColor = [UIColor clearColor];
        
        CGFloat width = self.bounds.size.width;

        CGRect pickerRect = CGRectMake(0, frame.size.height - DatePickerPickerHeight, width, DatePickerPickerHeight);
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.frame = pickerRect;
        [self addSubview:_datePicker];
        
        NSLog(@"picker height: %f", _datePicker.frame.size.height);
        
        CGRect toolbarRect = CGRectMake(0, frame.size.height -DatePickerHeight, width, DatePickerToolbarHeight);
        _toolbar = [[UIToolbar alloc] initWithFrame:toolbarRect];
        _toolbar.barStyle = UIBarStyleBlackTranslucent;
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(donePressed)];
        _toolbar.items = @[doneButton];
        [self addSubview:_toolbar];
    }
    return self;
}

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated
{
    if (!hidden) {
        _datePicker.hidden = NO;
        _toolbar.hidden = NO;
    }
    CGRect frame = _originalFrame;
    frame.origin.y += (hidden) ? DatePickerHeight : 0;
    if (animated) {
        [UIView beginAnimations:@"animateDatePicker" context:nil];
        [UIView setAnimationDuration:0.3]; //maybe longer
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        self.frame = frame;
        
        [UIView commitAnimations];
    } else {
        self.frame = frame;
    }
    if (hidden) {
        _datePicker.hidden = YES;
        _toolbar.hidden = YES;
    }
}

- (void)addTargetForDonePressed:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}

- (void)donePressed
{
    if (_target) {
        [_target performSelector:_action];
    }
}
@end
