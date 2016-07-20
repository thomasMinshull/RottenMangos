//
//  Theater.m
//  W4D1
//
//  Created by thomas minshull on 2016-07-20.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "Theater.h"
@import Contacts;

@implementation Theater


#pragma mark -MKAnnotation Methods 

- (MKMapItem*)mapItem {
    NSDictionary *addressDict = @{(NSString*)CNPostalAddressStreetKey : self.address};
    
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:self.coordinate
                              addressDictionary:addressDict];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    
    return mapItem;
}

@end
