//
//  RouteListCell.h
//  shinkansenquiz
//
//  Created by 荻原有二 on 2016/12/24.
//  Copyright © 2016年 Yuji Ogihara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *route;
@property (weak, nonatomic) IBOutlet UILabel *section;
@property (weak, nonatomic) IBOutlet UIImageView *picture;

+ (CGFloat)rowHeight;
@end
