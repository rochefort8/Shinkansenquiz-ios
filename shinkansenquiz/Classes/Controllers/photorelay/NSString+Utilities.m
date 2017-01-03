//
//  NSString+Utilities.m
//  shinkansenquiz
//
//  Created by Yuji Ogihara on 2015/06/01.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//
#import "NSString+Utilities.h"

@implementation NSString (Utilities)

- (CGSize)sizeWithFontEx:(UIFont *)font
{
    NSDictionary *attributes = @{ NSFontAttributeName : font };
    return [self sizeWithAttributes:attributes];
}

- (CGSize)sizeWithFontEx:(UIFont *)font constrainedToSize:(CGSize)size
{
    return [self sizeWithFontEx:font constrainedToSize:size
                  lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGSize)sizeWithFontEx:(UIFont *)font constrainedToSize:(CGSize)size
           lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = lineBreakMode;
    style.alignment = NSTextAlignmentLeft;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName : font,
                                 NSParagraphStyleAttributeName : style
                                 };
    CGRect rect = [self boundingRectWithSize:size
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    return rect.size;
}

- (CGSize)sizeWithFontEx:(UIFont *)font forWidth:(CGFloat)size
           lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentLeft;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName : font,
                                 NSParagraphStyleAttributeName : style
                                 };
    
    CGFloat height = font.lineHeight;
    CGSize maxsize = CGSizeMake(size, height);
    
    CGRect rect = [self boundingRectWithSize:maxsize
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    return rect.size;
}


@end
