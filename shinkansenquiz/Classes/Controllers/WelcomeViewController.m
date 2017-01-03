//
//  WelcomeViewController.m
//  shinkansenquiz
//
//  Created by Yuji Ogihara on 2015/05/31.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import "WelcomeViewController.h"
#import "AppDelegate.h"
#import "Harpy.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated {
 
    PFUser *user = [PFUser currentUser] ;
    
    if (user != nil) {
        NSLog(@"Already logged in as %@",[[PFUser currentUser]valueForKey:@"username"]);
        NSLog(@"Username=%@",user.username) ;
        NSLog(@"Graduate=%@",[user valueForKey:@"graduate"]);
     
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] doLogin];
/*
        [[PFUser currentUser] refreshInBackgroundWithTarget:self selector:@selector(refreshCurrentUserCallbackWithResult:error:)];
*/
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
