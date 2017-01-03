//
//  HomeViewController.h
//  shinkansenquiz
//
//  Created by Yuji Ogihara on 2015/05/03.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMobileAds;

@interface HomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@end

static NSString * const TableViewCellIdentifier = @"RouteListCell";

