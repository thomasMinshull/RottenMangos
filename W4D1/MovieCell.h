//
//  movieCell.h
//  W4D1
//
//  Created by thomas minshull on 2016-07-18.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MovieCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView; // outlets should be private
@property (weak, nonatomic) IBOutlet UILabel *movieLabel;

- (void)setupWithMovie:(Movie *)movie;

//- (instancetype)initWithJson:(NSDictionary *)json;
//+ (instancetype)cellWithMovie:(Movie *)movie;

@end
