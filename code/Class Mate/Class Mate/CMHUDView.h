//
//  CMHUDView.h
//  Class Mate
//
//  Created by Alex Layton on 10/02/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMHUDView : UIView

@property (strong, nonatomic) IBOutlet UILabel *preemptiveHeaderLabel;
@property (strong, nonatomic) IBOutlet UILabel *preemptiveSubLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationHeaderLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationSubLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateHeaderLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateSubLabel;
@property (readonly, nonatomic) NSArray *labels;

+ (CMHUDView *)hudView;

@end
