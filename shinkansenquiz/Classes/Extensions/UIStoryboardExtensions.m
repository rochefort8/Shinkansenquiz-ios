//
//  UIStoryboard+MSDExtensions.m
//  MultiStoryboardsDemo
//
//  Created by Jiro Nagashima on 12/3/13.
//
//

#import "UIStoryboardExtensions.h"

NSString * const kHomeName = @"Home";
NSString * const kPhotoRelayName = @"PhotoRelay";
NSString * const kQuizName = @"Quiz";
NSString * const kLikeListName = @"LikeList";
NSString * const kNewsName = @"News";

@implementation UIStoryboard (LikeTochikuExtensions)

+ (instancetype)homeStoryboard
{
    return [self storyboardWithName:kHomeName];
}

+ (instancetype)photorelayStoryboard
{
    return [self storyboardWithName:kPhotoRelayName];
}

+ (instancetype)quizStoryboard
{
    return [self storyboardWithName:kQuizName];
}

+ (instancetype)likelistStoryboard
{
    return [self storyboardWithName:kLikeListName];
}

+ (instancetype)newsStoryboard
{
    return [self storyboardWithName:kNewsName];
}

+ (instancetype)storyboardWithName:(NSString *)name
{
    return [self storyboardWithName:name bundle:nil];
}

@end
