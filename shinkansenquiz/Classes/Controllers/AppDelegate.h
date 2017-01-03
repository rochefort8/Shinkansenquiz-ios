//
//  AppDelegate.h
//  LikeTochiku
//
//  Created by Yuji Ogihara on 2015/02/14.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, readonly) int networkStatus;

- (BOOL)isParseReachable;

- (void)doLogin;
- (void)doLogout;
- (void)allowOrientationLandscape:(BOOL)flag;


@end

