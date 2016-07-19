//
//  ReviewTableViewCell.h
//  W4D1
//
//  Created by thomas minshull on 2016-07-18.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Review.h"

@interface ReviewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *publicationLabel;
@property (weak, nonatomic) IBOutlet UILabel *criticLabel;
@property (weak, nonatomic) IBOutlet UILabel *quoteLabel;

- (void)setupWithReview:(Review *)review;

@end
