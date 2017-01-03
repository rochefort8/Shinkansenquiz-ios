//
//  UILabelWithPadding.m
//  shinkansenquiz
//
//  Created by 荻原有二 on 2016/10/02.
//  Copyright © 2016年 Yuji Ogihara. All rights reserved.
//

#import "UILabelWithPadding.h"

@implementation UILabelWithPadding

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawTextInRect:(CGRect)rect
{
    UIEdgeInsets insets = {0, 10, 0, 10};
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
