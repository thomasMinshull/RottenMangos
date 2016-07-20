//
//  MyLocationManager.m
//  W4D1
//
//  Created by thomas minshull on 2016-07-19.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "MyLocationManager.h"
@import CoreLocation;

@implementation MyLocationManager

+ (instancetype)sharedManager {
    static MyLocationManager *myLocationManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        myLocationManager = [MyLocationManager new];
    });
    
    return myLocationManager;
}

- (void)startLocationMonitoring {
    if ([CLLocationManager locationServicesEnabled]) {
        if ( [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined ||
            !([CLLocationManager authorizationStatus] == kCLErrorDenied||[CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)) {
            
            if (self.locationManager == nil) {
                self.locationManager = [CLLocationManager new];
                self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
                self.locationManager.distanceFilter = 10;
                
                self.locationManager.delegate = self;
                [self.locationManager requestWhenInUseAuthorization]; // alertViewController asks users for location permissions
                NSLog(@"new location Manager in startLocationManager");
            }
            
            [self.locationManager requestWhenInUseAuthorization];
            [self.locationManager startUpdatingLocation];
            NSLog(@"Start Regular Location Manager");
            
        } else { // Location Services have been turned off! Present an allert view telling the user to turn them back on
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Location services are disabled, Please go into Settings > Privacy > Location to enable them for Play" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                //Nothing to be done
            }];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                //Nothing to be done!
            }];
            
            [alertController addAction:ok];
            [alertController addAction:cancel];
        }
        
    } else { //CoreLocation not enabled???
        NSLog(@"locationServicesEnabled is false");
    }
}

#pragma mark -CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations lastObject];
    
    //if it's been a while since last update, and the update is accurate us the new location as current location
    
    NSTimeInterval locationAge = -[location.timestamp timeIntervalSinceNow];
    
    if (locationAge > 10.0) {
        return;
    }
    
    if (location.horizontalAccuracy < 0) {
        return;
    }
    
    if (self.currentLocation == nil || self.currentLocation.horizontalAccuracy >= location.horizontalAccuracy){
        self.currentLocation = location;
        [self.delegate recievedNewLocation:location];
        
        if (location.horizontalAccuracy <= self.locationManager.desiredAccuracy) { //good enough 
            if ([CLLocationManager locationServicesEnabled]) {
                if (self.locationManager) {
   //                 [self.locationManager stopUpdatingLocation]; // stops getting location updates 
                    NSLog(@"Stop Regular Location Manager");
                }
            }
        }

    }
    /* Danny's Code
     NSLog(@"Time %@, latitude %+.6f, longitude %+.6f currentLocation accuracy %1.2f loc accuracy %1.2f timeinterval %f",[NSDate date],loc.coordinate.latitude, loc.coordinate.longitude, loc.horizontalAccuracy, loc.verticalAccuracy, fabs([loc.timestamp timeIntervalSinceNow]));
     
     NSTimeInterval locationAge = -[loc.timestamp timeIntervalSinceNow];
     if (locationAge > 10.0){
     NSLog(@"locationAge is %1.2f",locationAge);
     return;
     }
     
     if (loc.horizontalAccuracy < 0){
     NSLog(@"loc.horizontalAccuracy is %1.2f",loc.horizontalAccuracy);
     return;
     }
     
     if (self.currentLocation == nil || self.currentLocation.horizontalAccuracy >= loc.horizontalAccuracy){
     
     self.currentLocation = loc;
     [self.delegate newLocationDetected:loc];
     
     if (loc.horizontalAccuracy <= self.locationManager.desiredAccuracy) {
     [self stopLocationManager];
     }
     }
     */
}

@end
