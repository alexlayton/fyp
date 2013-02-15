//
//  CMMapViewController.h
//  Class Mate
//
//  Created by Alex Layton on 30/11/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CMReminderViewController.h"

@interface CMMapViewController : UIViewController <MKMapViewDelegate, CMReminderViewControllerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
