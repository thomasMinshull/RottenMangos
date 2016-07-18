//
//  ViewController.m
//  W4D1
//
//  Created by thomas minshull on 2016-07-18.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *apiKey = @"c9zzxwtuc3q2tftqata3k59w";
    NSString *urlAsString = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=";
    
    NSURL *url = [NSURL URLWithString:[urlAsString stringByAppendingString:apiKey]];
    NSURLSession *sessions = [NSURLSession]
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
