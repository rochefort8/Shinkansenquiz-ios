//
//  QuizStartViewController.h
//  shinkansenquiz
//
//  Created by 荻原有二 on 2016/12/25.
//  Copyright © 2016年 Yuji Ogihara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RouteContent.h"

@interface QuizStartViewController : UIViewController {
    
    RouteContent *_routeContent ;
}

@property (strong, nonatomic) RouteContent *routeContent ;

@end
