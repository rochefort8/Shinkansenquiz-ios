//
//  MSDTabBarController.m
//  MultiStoryboardsDemo
//
//  Created by Jiro Nagashima on 12/3/13.
//
//

#import "TabBarController.h"
#import "UIStoryboardExtensions.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setUpViewControllers];
}

- (void)setUpViewControllers
{
    self.viewControllers = @[[[UIStoryboard homeStoryboard] instantiateInitialViewController],
                             [[UIStoryboard photorelayStoryboard] instantiateInitialViewController],
//                             [[UIStoryboard quizStoryboard] instantiateInitialViewController],
                             [[UIStoryboard newsStoryboard] instantiateInitialViewController],
                             [[UIStoryboard likelistStoryboard] instantiateInitialViewController],
                             ];
}

@end
