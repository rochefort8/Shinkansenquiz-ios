//
//  NSString+Utilities.h
//  shinkansenquiz
//
//  Created by Yuji Ogihara on 2015/06/01.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utilities)

- (CGSize)sizeWithFontEx:(UIFont *)font;
- (CGSize)sizeWithFontEx:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGSize)sizeWithFontEx:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGSize)sizeWithFontEx:(UIFont *)font forWidth:(CGFloat)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end
