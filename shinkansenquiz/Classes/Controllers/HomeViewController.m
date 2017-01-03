//
//  HomeViewController.m
//  shinkansenquiz
//
//  Created by Yuji Ogihara on 2015/05/03.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import "HomeViewController.h"
#import "RegistrationViewController.h"
#import "RouteListCell.h"
#import "QuizStartViewController.h"

#import "RouteContent.h"

@import GoogleMobileAds;

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>

/* UI components */

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (nonatomic) NSInteger clickedPosition ;

// Getting data from Parse server
typedef void (^CallbackHandler)(NSError *error);
- (void)loadData:(CallbackHandler)handler ;

// Question list
@property int totalQuestionCount;
    // All questions on server
@property (strong, nonatomic) NSMutableArray *routeList;
@property (strong, nonatomic) RouteContent *selectedRoute ;

@property (nonatomic) CGFloat viewHeight ;
@property bool initialLoad ;

@end

int table[20];

@interface HomeViewController () <PFLogInViewControllerDelegate,
            PFSignUpViewControllerDelegate>
{
    NSArray *_descriptions;
}

@end

@implementation HomeViewController

#define     NUMBER_OF_ROUTES (10)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // General initialzation
    self.initialLoad = true ;
    
    // Tableview initialization
    self.tableView.delegate = self;
    self.tableView.dataSource = self ;
    UINib *nib = [UINib nibWithNibName:TableViewCellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:TableViewCellIdentifier];
    UIScreen *sc = [UIScreen mainScreen];
    CGRect rect = sc.applicationFrame ;
    self.viewHeight = rect.size.height -
                self.navigationController.navigationBar.frame.size.height -
                self.tabBarController.tabBar.frame.size.height;
    
    // Route List
    self.selectedRoute = [[RouteContent alloc] init];
//    [self.selectedRoute init];
    
    // AdMob
    // Replace this ad unit ID with your own ad unit ID.
    NSLog(@"Google Mobile Ads SDK version: %@", [GADRequest sdkVersion]);
    self.bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
    self.bannerView.rootViewController = self;
    
    GADRequest *request = [GADRequest request];
    // Requests test ads on devices you specify.Your test device ID is printed to the
    // console when an ad request is made. GADBannerView automatically
    // returns test ads when running on a simulator.
//    request.testDevices = @[
//                            @"2077ef9a63d2b398840261c8221a0c9a"  // Eric's iPod Touch
//                            ];
    [self.bannerView loadRequest:request];
    
    // Activity Indicator
    [self.activityIndicator setHidesWhenStopped:YES];
    [self.activityIndicator startAnimating];

    // Load data from server
    
    /*
     For remove warning,
     "Capturing self strongly in this block is likely to lead to a retain cycle"
     */
    __unsafe_unretained typeof(self) weakSelf = self;

    [self loadData:^(NSError *error) {
        if (!error){
            /*
            [self setQuestionsFromList:^(NSError *error) {
                if (!error) {
                    
                } else {
                    
                }
                [weakSelf.activityIndicator stopAnimating ];
                [weakSelf.startButton setEnabled:YES] ;
            }];
             */
            [weakSelf.activityIndicator stopAnimating ];
            [weakSelf.startButton setEnabled:YES] ;
        } else {
            [self.activityIndicator stopAnimating ];
            [self.startButton setEnabled:YES] ;
        }
    }];

}

- (void)loadData:(CallbackHandler)handler {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Routes"];
    [query orderByDescending:@"_created_at"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"[Routes] Error");
            if (handler) {
                handler(error) ;
            }
            return;
        }
        NSMutableArray *latestList = [objects mutableCopy];
        bool updated = false ;
        if ([latestList count] == [self.routeList count]) {
            for (int i = 0;i < [latestList count];i++) {
                PFObject *latest  = [latestList objectAtIndex:i] ;
                PFObject *current = [self.routeList objectAtIndex:i] ;
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
            NSLog (@"[QuestionList] data updated, loading...") ;
            
            self.routeList = [objects mutableCopy];
            
            [self.tableView reloadData];
            
        } else {
            NSLog(@"[QuestionList] No updates found.") ;
        }
        if (handler) {
            handler(error) ;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.routeList count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RouteListCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
    
    PFObject *object = [self.routeList objectAtIndex:indexPath.row] ;
    cell.route.text = [object objectForKey:@"name_jp"] ;
    NSString *section = [NSString stringWithFormat:@"%@ ~ %@",
                     [object objectForKey:@"starting"],[object objectForKey:@"terminus"]];
    cell.section.text = section ;
    
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
    return [RouteListCell rowHeight];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.clickedPosition = indexPath.row ;
/*
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
     */
    [self performSegueWithIdentifier:@"toQuizStartView" sender:self];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    QuizStartViewController *secondViewController = segue.destinationViewController;
    
    PFObject *object = [self.routeList objectAtIndex:self.clickedPosition] ;
//    [self.selectedRoute setObject:(PFObject*)object];
    self.selectedRoute.object = object;
    
    secondViewController.routeContent = self.selectedRoute ;

}

#pragma mark -
#pragma mark PFLogInViewControllerDelegate

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    // Do nothing, as the view controller dismisses itself
}

#pragma mark -
#pragma mark PFSignUpViewControllerDelegate

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    // Do nothing, as the view controller dismisses itself
}


@end
