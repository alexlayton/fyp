//
//  CMDatePickerView.h
//  Class Mate
//
//  Created by Alex Layton on 13/12/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMDatePickerView : UIView

@property (nonatomic, strong) UIDatePicker *datePicker;

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)addTargetForDonePressed:(id)target action:(SEL)action;

@end
