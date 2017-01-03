//
//  RegistrationViewController.h
//  userreg
//
//  Created by Yuji Ogihara on 2015/05/16.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserRegistrationViewController : UIViewController {
    BOOL _isRequestPassword ;
}
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UIPickerView *graduateView;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@property BOOL isRequestPassword ;

@end
