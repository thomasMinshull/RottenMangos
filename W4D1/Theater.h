//
//  Theater.h
//  W4D1
//
//  Created by thomas minshull on 2016-07-20.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;
@import MapKit;


@interface Theater : NSObject <MKAnnotation>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

- (MKMapItem*)mapItem;

@end
