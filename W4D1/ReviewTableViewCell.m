//
//  ReviewTableViewCell.m
//  W4D1
//
//  Created by thomas minshull on 2016-07-18.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "ReviewTableViewCell.h"

@implementation ReviewTableViewCell


- (void)setupWithReview:(Review *)review {
    [self.publicationLabel setText:review.publication];
    [self.criticLabel setText:review.critic];
    [self.quoteLabel setText:review.quote];
}

@end
