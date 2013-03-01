//
//  CMHUDView.m
//  Class Mate
//
//  Created by Alex Layton on 10/02/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import "CMHUDView.h"

@implementation CMHUDView

@synthesize preemptiveHeaderLabel = _preemptiveHeaderLabel;
@synthesize preemptiveSubLabel = _preemptiveSubLabel;
@synthesize locationHeaderLabel = _locationHeaderLabel;
@synthesize locationSubLabel = _locationSubLabel;
@synthesize dateHeaderLabel = _dateHeaderLabel;
@synthesize dateSubLabel = _dateSubLabel;
@synthesize labels = _labels;

#pragma mark - Accessors

- (NSArray *)labels
{
    return @[_preemptiveHeaderLabel, _preemptiveSubLabel, _locationHeaderLabel, _locationSubLabel, _dateHeaderLabel, _dateSubLabel];
}

+ (CMHUDView *)hudView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"CMHUDView" owner:self options:nil] objectAtIndex:0];
}

- (void)dealloc
{
    NSLog(@"Killed HUD VIEW!!!!!!");
}

- (void)awakeFromNib
{
    //stuff here...
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
