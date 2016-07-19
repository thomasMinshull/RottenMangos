//
//  movieCell.m
//  W4D1
//
//  Created by thomas minshull on 2016-07-18.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "MovieCell.h"
#import <UIKit/UIKit.h>

@interface MovieCell ()

@property (strong, nonatomic) NSURLSessionTask *imageTask;

@end

@implementation MovieCell

//+ (instancetype)cellWithMovie:(Movie *)movie {
//    return [[self alloc] initWithMovie:movie];
//}

-(void)prepareForReuse {
    self.imageView.image = nil; 
    [self.imageTask cancel];
}

- (void)setupWithMovie:(Movie *)movie {
    [self.movieLabel setText:movie.title];
    
    
    NSURL *url = [NSURL URLWithString:movie.thumbNailURLAsString];
    NSURLSession *sessions = [NSURLSession sharedSession];
    
    __weak MovieCell *weakSelf = self;
    self.imageTask = [sessions downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSData *thumbNailData = [NSData dataWithContentsOfURL:location];
        UIImage *thumbNail = [UIImage imageWithData:thumbNailData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.imageView setImage:thumbNail];
        });
    }];
    
    [self.imageTask resume];
}

@end
