//
//  CMOptionViewController.h
//  Class Mate
//
//  Created by Alex Layton on 01/02/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMOptionViewController;

@protocol CMOptionDelegate <NSObject>

- (void)optionViewController:(CMOptionViewController *)ovc didSelectOption:(NSString *)option;

@end

@interface CMOptionViewController : UITableViewController

@property (nonatomic, weak) id<CMOptionDelegate> delegate;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray *options;

@end
