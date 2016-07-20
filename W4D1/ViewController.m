//
//  ViewController.m
//  W4D1
//
//  Created by thomas minshull on 2016-07-18.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "ViewController.h"
#import "ReviewsTableViewController.h"
#import "Movie.h"
#import "MovieCell.h"
#import "Constants.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *movies;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.movies = [@[] mutableCopy];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.navigationController.navigationBarHidden = YES;
    
    // Networking
    NSString *urlAsString = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=";
    
    NSURL *url = [NSURL URLWithString:[urlAsString stringByAppendingString:API_KEY]];
    NSURLSession *sessions = [NSURLSession sharedSession];
    
    
    __weak ViewController *weakSelf = self;
    [[sessions dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
            NSError *jsonError = nil;
            
            NSDictionary *allResponses = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:0
                                                                           error:&jsonError];
            // todo: add nil check for jsonError
            
            NSLog(@"all Responses, %@", allResponses);
            
            NSArray *moviesResponse = allResponses[@"movies"];
            
            Movie *tempMovie;
            
            for (NSDictionary *movieWithAttributes in moviesResponse) {
                tempMovie = [Movie new];
                tempMovie.movieID = movieWithAttributes[@"id"];
                tempMovie.thumbNailURLAsString = movieWithAttributes[@"posters"][@"thumbnail"];
                tempMovie.title = movieWithAttributes[@"title"];
                tempMovie.summary = movieWithAttributes[@"synopsis"];
                
                [self.movies addObject:tempMovie];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.collectionView reloadData];
            });
            
        }
        
    }] resume];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -Data Source & Delegate Methodes 

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.movies count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCell" forIndexPath:indexPath];
    
    NSLog(@"Movie Cell ClassName: %@", NSStringFromClass([MovieCell class]));
//    MovieCell *c = [MovieCell cellWithMovie:self.movies[indexPath.row]];
    [cell setupWithMovie:self.movies[indexPath.row]];
    return cell;
    
    
//    return [self.tableView cell:[MyCell class] object:myArray[indexPath.row]];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    ReviewsTableViewController *tvc = [segue destinationViewController];
    NSArray *selectedIndexPaths = [self.collectionView indexPathsForSelectedItems];
    tvc.movie = self.movies[[[selectedIndexPaths firstObject] row]];
    
}


@end
