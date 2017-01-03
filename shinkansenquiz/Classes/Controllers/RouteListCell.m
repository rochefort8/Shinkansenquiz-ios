//
//  RouteListCell.m
//  shinkansenquiz
//
//  Created by 荻原有二 on 2016/12/24.
//  Copyright © 2016年 Yuji Ogihara. All rights reserved.
//

#import "RouteListCell.h"

@implementation RouteListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)rowHeight
{
    return 120.0f;
}

@end
