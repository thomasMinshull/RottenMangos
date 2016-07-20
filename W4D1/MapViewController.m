//
//  MapViewController.m
//  W4D1
//
//  Created by thomas minshull on 2016-07-19.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "MapViewController.h"
#import "MyLocationManager.h"
#import "Theater.h"
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
    NSLog(@"postal code for updated placemark: %@",placemark.postalCode); //only includes half the postalCode !!!!!
    
    //Networking
    NSString *urlAsString = [NSString stringWithFormat:@"http://lighthouse-movie-showtimes.herokuapp.com/theatres.json?address=%@&movie=%@", placemark.postalCode, self.movie.title]; // Including spaces in Names 
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSURLSession *sessions = [NSURLSession sharedSession];
    
 //   __weak MapViewController *weakSelf = self;
    [[sessions dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                NSLog(@"response: %@", response);
        if (error == nil) {
            NSError *jsonError = nil;
            
            
            NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:0
                                                                              error:&jsonError];
            
            NSArray *responseTheaters = [tempDic objectForKey:@"theater"];
            
            NSLog(@"responseTheaterss: %@", responseTheaters);
            
            //Clear out old annotations
            for (id<MKAnnotation> annotation in self.mapView.annotations) {
                [self.mapView removeAnnotation:annotation];
            }
            
            //Add new annotations
            Theater *tempTheater;
      
            for (NSDictionary *theater in responseTheaters) {
                tempTheater = [Theater new];
                tempTheater.name = [theater objectForKey:@"name"];
                tempTheater.address = [theater objectForKey:@"address"];
                
                NSNumber *lst = [theater objectForKey:@"lst"];
                NSNumber *lng = [theater objectForKey:@"lng"];
                tempTheater.coordinate = CLLocationCoordinate2DMake([lst doubleValue], [lng doubleValue]);
                
                [self.mapView addAnnotation:tempTheater];
            }
            

        }
        
    }] resume];
}

@end
