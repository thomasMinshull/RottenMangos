//
//  MyLocationManager.h
//  W4D1
//
//  Created by thomas minshull on 2016-07-19.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;
@import CoreLocation;

@protocol MyLocationManagerDelegate <NSObject>

- (void)recievedNewLocation:(CLLocation *)location;

@end

@interface MyLocationManager : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

@property (weak, nonatomic) id<MyLocationManagerDelegate> delegate;

+ (id)sharedManager;
- (void)startLocationMonitoring;

@end
