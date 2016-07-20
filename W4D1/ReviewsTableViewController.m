//
//  ReviewsTableViewController.m
//  W4D1
//
//  Created by thomas minshull on 2016-07-18.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "ReviewsTableViewController.h"
#import "ReviewTableViewCell.h"
#import "ReviewWebViewController.h"
#import "Constants.h"
#import "Review.h"

@interface ReviewsTableViewController ()

@property (strong, nonatomic) NSMutableArray *reviews;

@end

@implementation ReviewsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.reviews = [@[] mutableCopy]; // [MutiableArray new] more readable
    self.reviews = [NSMutableArray new];
    self.tableView.estimatedRowHeight = 194;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    //Networking
    NSString *urlAsString = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/movies/%@/reviews.json?apikey=%@", self.movie.movieID, API_KEY];
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSURLSession *sessions = [NSURLSession sharedSession];
    
    __weak ReviewsTableViewController *weakSelf = self;
    [[sessions dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"response: %@", response);
        if (error == nil) {
            NSError *jsonError = nil;
            
            NSDictionary *responseReviews = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:0
                                                                              error:&jsonError];
//            NSLog(@"responseReviews: %@", responseReviews);
            
            Review *tempReview;
            
            for (NSDictionary *review in responseReviews[@"reviews"]) {
                tempReview = [Review new]; // [tempReview alloc] initWithJson:review]; refactor to use 
                
                tempReview.critic = [review objectForKey:@"critic"];
                tempReview.publication = [review objectForKey:@"publication"];
                tempReview.quote = [review objectForKey:@"quote"];
                tempReview.link = [[review objectForKey:@"links"] objectForKey:@"review"];
                
                [self.reviews addObject:tempReview];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
        
    }] resume];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.reviews count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ReviewTableViewCell class]) forIndexPath:indexPath];
    
    [cell setupWithReview:self.reviews[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        
    } else {
        ReviewWebViewController *wvc = [segue destinationViewController];
        wvc.review = self.reviews[self.tableView.indexPathForSelectedRow.row];
    }
}

@end
