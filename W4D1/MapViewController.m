//
//  MapViewController.m
//  W4D1
//
//  Created by thomas minshull on 2016-07-19.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "MapViewController.h"
#import "MyLocationManager.h"
@import MapKit;

#define zoominMapArea 2100

@interface MapViewController () <CLLocationManagerDelegate, MyLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MyLocationManager *myLocationManager;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myLocationManager = [MyLocationManager sharedManager];
    self.myLocationManager.delegate = self;
    [self.myLocationManager startLocationMonitoring];

}

- (void)recievedNewLocation:(CLLocation *)location {
    CLLocationCoordinate2D zoomLocation = location.coordinate;// CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    
    MKCoordinateRegion adjustedRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, zoominMapArea, zoominMapArea);
    
    [self.mapView setRegion:adjustedRegion animated:YES];
}

- (void)currentAddressUpdated:(CLPlacemark *)placemark {
    NSLog(@"postal code for updated placemark: %@",placemark.postalCode);
}

@end
