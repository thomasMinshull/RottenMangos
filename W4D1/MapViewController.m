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
//    [self.myLocationManager startLocationMonitoring]; // should this be in viewWillAppear?
}

- (void)viewWillAppear:(BOOL)animated {
    [self.myLocationManager startLocationMonitoring];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.myLocationManager stopLocationMonitoring];
}


#pragma mark -MyLocationDelegate Methods 

- (void)recievedNewLocation:(CLLocation *)location {
    CLLocationCoordinate2D zoomLocation = location.coordinate;// CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    
    MKCoordinateRegion adjustedRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, zoominMapArea, zoominMapArea);
    
    [self.mapView setRegion:adjustedRegion animated:YES];
}

- (void)currentAddressUpdated:(CLPlacemark *)placemark {
    NSLog(@"postal code for updated placemark: %@",placemark.postalCode); //only includes half the postalCode !!!!!
    
    NSURLComponents *lightURLComponents = [NSURLComponents new];
    
    lightURLComponents.scheme = @"http";
    lightURLComponents.host =@"lighthouse-movie-showtimes.herokuapp.com";
    lightURLComponents.path = @"/theatres.json";
    lightURLComponents.queryItems = @[[NSURLQueryItem queryItemWithName:@"address" value:placemark.postalCode],
                                      [NSURLQueryItem queryItemWithName:@"movie" value:self.movie.title]];
    
    
    //Networking
//    NSString *trimedTitle = [self.movie.title stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSString *trimedPostalCode = [placemark.postalCode stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    
//    NSString *urlAsString = [NSString stringWithFormat:@"http://lighthouse-movie-showtimes.herokuapp.com/theatres.json?address=%@&movie=%@", trimedPostalCode, trimedTitle]; // Including spaces in Names Need to remove white space from movieTitle and PostalCode
//    NSURL *url = [NSURL URLWithString:urlAsString];
    NSURL *url = [lightURLComponents URL];
    NSURLSession *sessions = [NSURLSession sharedSession];
    
 //   __weak MapViewController *weakSelf = self;
    [[sessions dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                NSLog(@"response: %@", response);
        if (error == nil) {
            NSError *jsonError = nil;
            
            
            NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:0
                                                                              error:&jsonError];
            
            NSArray *responseTheaters = [tempDic objectForKey:@"theatres"];
            
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
                
                NSNumber *lst = [theater objectForKey:@"lat"];
                NSNumber *lng = [theater objectForKey:@"lng"];
                tempTheater.coordinate = CLLocationCoordinate2DMake([lst doubleValue], [lng doubleValue]);
                
                [self.mapView addAnnotation:tempTheater];
            }
            

        }
        
    }] resume];
}

@end
