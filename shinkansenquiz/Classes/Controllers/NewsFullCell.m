//
//  NewsListCell.m
//  shinkansenquiz
//
//  Created by Yuji Ogihara on 2015/05/06.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import "NewsFullCell.h"

@implementation NewsFullCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)rowHeight
{    
    return 600.0f;
}

@end
