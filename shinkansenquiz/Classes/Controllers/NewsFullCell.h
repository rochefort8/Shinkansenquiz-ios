//
//  NewsListCell.h
//  shinkansenquiz
//
//  Created by Yuji Ogihara on 2015/05/06.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsFullCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
// @property (weak, nonatomic) IBOutlet UILabel *newsContents;
@property (weak, nonatomic) IBOutlet UITextView *newsContents;

@property (weak, nonatomic) IBOutlet UIImageView *newsImage;

+ (CGFloat)rowHeight;

@end
