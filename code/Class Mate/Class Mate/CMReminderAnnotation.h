//
//  CMReminderAnnotation.h
//  Class Mate
//
//  Created by Alex Layton on 19/12/2012.
//  Copyright (c) 2012 Alex Layton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class ALLocationReminder;

@interface CMReminderAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) NSString* title;
@property (nonatomic, readonly) NSString* subtitle;
@property (nonatomic, weak) ALLocationReminder *reminder;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location
                placeName:(NSString *)placeName
              description:(NSString *)description;

@end
