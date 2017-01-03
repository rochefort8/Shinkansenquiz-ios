//
//  NewsFullViewController.h
//  shinkansenquiz
//
//  Created by Yuji Ogihara on 2015/05/12.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsFullViewController : UIViewController {
    NSString *_newsTitle ;
    NSString *_newsContents;
    UIImage *_newsImage ;
}

@property (strong, nonatomic) NSString *newsTitle;
@property (strong, nonatomic) NSString *newsContents;
@property (strong, nonatomic) UIImage  *newsImage ;

@end

static NSString * const NewsFullCellIdentifier = @"NewsFull";

