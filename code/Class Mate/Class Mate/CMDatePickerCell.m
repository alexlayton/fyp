//
//  CMDatePickerCell.m
//  Class Mate
//
//  Created by Alex Layton on 02/02/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import "CMDatePickerCell.h"

@implementation CMDatePickerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
