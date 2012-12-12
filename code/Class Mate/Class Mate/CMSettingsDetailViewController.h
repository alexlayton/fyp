//
//  CMSettingsDetailViewController.h
//  Class Mate
//
//  Created by Alex Layton on 03/12/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMSettingsDetailViewController : UITableViewController

@property (nonatomic, strong) NSString *defaultsKey;
@property (nonatomic, strong) NSDictionary *options;
@property (nonatomic, strong) id currentValue;
@property (nonatomic, weak) NSString *settingsType;

@end
