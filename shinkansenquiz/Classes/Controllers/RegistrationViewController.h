//
//  RegistrationViewController.h
//  shinkansenquiz
//
//  Created by Yuji Ogihara on 2015/05/09.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet UITextField *textEmail;
@property (weak, nonatomic) IBOutlet UITextField *textComment;
@property (weak, nonatomic) IBOutlet UITextField *textGraduate;

@end
