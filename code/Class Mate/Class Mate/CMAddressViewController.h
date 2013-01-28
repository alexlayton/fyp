//
//  CMAddressTestViewController.h
//  Class Mate
//
//  Created by Alex Layton on 17/01/2013.
//  Copyright (c) 2013 Alex Layton. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMAddressViewController, CMAddress;

@protocol CMAddressViewDelegate <NSObject>

- (void)addressView:(CMAddressViewController *)avc didSelectAddress:(CMAddress *)address;

@end

@interface CMAddressViewController : UITableViewController<UIAlertViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) NSMutableArray *addresses;
//make this immutable
@property (nonatomic, strong) NSArray *results;
@property (nonatomic) NSUInteger previousSelectedIndex;
@property (nonatomic, weak) id<CMAddressViewDelegate> delegate;

@end
