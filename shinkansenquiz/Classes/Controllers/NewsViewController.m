//
//  NewsViewController.m
//  shinkansenquiz
//
//  Created by Yuji Ogihara on 2015/05/04.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsFullViewController.h"
#import "NewsListCell.h"
#import <Parse/Parse.h>


@interface NewsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *newsList;

// For large view
@property (nonatomic) NSInteger clickedPosition ;
@property (nonatomic) UIImage *fullViewImage ;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *newsActivityIndicator;

typedef void (^CallbackHandler)(NSError *error);
- (void)loadData:(CallbackHandler)handler ;

@end


@implementation NewsViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    // Setting up listview
    self.tableView.delegate = self;
    self.tableView.dataSource = self ;

    // Prepare XIB for each cell
    UINib *nib = [UINib nibWithNibName:NewsListCellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"NewsCell"];

    // Start actiity indicator
    [self.newsActivityIndicator setHidesWhenStopped:YES];
    [self.newsActivityIndicator startAnimating ];
 
    // Load all news from server
    [self loadData:^(NSError *error) {
        if (!error){
            // No error
        } else {
            // Something happened..
        }
        [self.newsActivityIndicator stopAnimating];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.newsList count] ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsCell";
    NewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    PFObject *object = [self.newsList objectAtIndex:indexPath.row] ;
    cell.title.text     = [object objectForKey:@"title"] ;
    cell.content.text     = [object objectForKey:@"news"] ;
    
    PFFile *imageFile = [object objectForKey:@"image"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error){
            UIImage *image = [UIImage imageWithData:data];
            cell.picture.image = image ;
        } else {
            NSLog(@"no data!");
        }
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [NewsListCell rowHeight];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NewsFullViewController *secondViewController = segue.destinationViewController;
    
    PFObject *object = [self.newsList objectAtIndex:self.clickedPosition] ;
    
    // Provide title,contents and image to large view
    secondViewController.newsTitle = [object objectForKey:@"title"] ;
    secondViewController.newsContents = [object objectForKey:@"news"] ;
    secondViewController.newsImage = self.fullViewImage ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.clickedPosition = indexPath.row ;
    PFObject *object = [self.newsList objectAtIndex:indexPath.row] ;
    PFFile *imageFile = [object objectForKey:@"image"];
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error){
            self.fullViewImage = [UIImage imageWithData:data];
            [self performSegueWithIdentifier:@"toNewsDetailView" sender:self];
        } else {
            NSLog(@"no data!");
        }
    }];
}

- (IBAction)onRefresh:(id)sender {
    
   [self loadData:^(NSError *error) {
       
       if (!error){
           // No error
       } else {
           // Something happened..
       }
       [sender endRefreshing] ;
   }];
}

- (void)loadData:(CallbackHandler)handler {
    
    // Load news from parse
    PFQuery *query = [PFQuery queryWithClassName:@"News"];
    [query orderByDescending:@"_created_at"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error");
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                                message:error.localizedDescription
                                                               delegate:nil
                   
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
            if (handler) {
                handler(error);
            }
            return;
        }
        
        NSMutableArray *latestList = [objects mutableCopy];
        bool updated = false ;
        if ([latestList count] == [self.newsList count]) {
            for (int i = 0;i < [latestList count];i++) {
                PFObject *latest  = [latestList objectAtIndex:i] ;
                PFObject *current = [self.newsList objectAtIndex:i] ;
                if ([[latest objectId] isEqualToString:[current objectId]]) {
                    // Continue..
                } else {
                    NSLog (@"String is different %@ / %@",[latest objectId],[current objectId]) ;
                    updated = true ;
                    break ;
                }
            }
        } else {
            NSLog (@"Number is different") ;
            updated = true ;
        }
        
        // Reload view only when data had been really changed
        if (updated == true) {
            NSLog (@"News data updated, loading...") ;
            // Clear all data..
            [self.newsList removeAllObjects];
            self.newsList = [objects mutableCopy];
            [self.tableView reloadData];
        } else {
            NSLog(@"[News] No updates found.") ;
        }
        if (handler) {
            handler(error);
        }
    }];
}


@end
