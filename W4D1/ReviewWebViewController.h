//
//  ReviewWebViewController.h
//  W4D1
//
//  Created by thomas minshull on 2016-07-18.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Review.h"
#import "Movie.h"

@interface ReviewWebViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) Review *review;
@property (strong, nonatomic) Movie *movie;

@end
