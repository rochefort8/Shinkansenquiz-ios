//
//  RegistrationViewController.m
//  shinkansenquiz
//
//  Created by Yuji Ogihara on 2015/05/09.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import <Parse/Parse.h>
#import "RegistrationViewController.h"

@interface RegistrationViewController () <UITextFieldDelegate>

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    PFUser *user = [PFUser currentUser] ;
    
    self.textName.text = [user username];
    self.textEmail.text = [user email];
    self.textGraduate.text =[user objectForKey:@"graduate"] ;
    
    self.textName.delegate = self ;
    self.textEmail.delegate = self ;
    self.textGraduate.delegate = self ;
    self.textComment.delegate = self ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)textName:(id)sender {
}
- (IBAction)OnRegistrationButton:(id)sender {
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (IBAction)onButton:(id)sender {
    
    NSString *mailBody,*tmp ;
    
    mailBody = @"" ;
    mailBody = [mailBody stringByAppendingString:@"------\n"];
    tmp = [NSString stringWithFormat:@"[名前]%@\n",self.textName.text];
    mailBody = [mailBody stringByAppendingString:tmp];
    tmp = [NSString stringWithFormat:@"[Email]%@\n",self.textEmail.text];
    mailBody = [mailBody stringByAppendingString:tmp];
    tmp = [NSString stringWithFormat:@"[期]%@\n",self.textGraduate.text];
    mailBody = [mailBody stringByAppendingString:tmp];
    tmp = [NSString stringWithFormat:@"[一言]%@\n",self.textComment.text];
    mailBody = [mailBody stringByAppendingString:tmp];
    mailBody = [mailBody stringByAppendingString:@"------\n"];
    
    NSLog(@"%@",mailBody);
     
     [PFCloud callFunctionInBackground:@"sendMail"withParameters:@{
                                @"toEmail":@"yuji.ogihara.85@gmail.com",
                                @"toName":@"Yuji Ogihara",
                                @"fromEmail":self.textEmail.text,
                                @"fromName":self.textName.text,
                                @"text":mailBody,
                                @"subject":@"[懇親会申し込み][iOS]"}
                                 block:^(NSString *result, NSError *error) {
         if (error) {
             NSString *errorString = [[error userInfo] objectForKey:@"error"];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"申し込みできませんでした。" message:errorString
                                                delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         } else {
             UIAlertController * ac =
             [UIAlertController alertControllerWithTitle:@"申し込みありがとうござます！"
                                                 message:@"当番期からメールにて連絡がありますので、しばらくお待ちください。"
                                          preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction * okAction =
             [UIAlertAction actionWithTitle:@"戻る"
                                      style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        [self.navigationController popViewControllerAnimated:YES];
                                    
                                    }];
             [ac addAction:okAction];
             [self presentViewController:ac animated:YES completion:nil];

         }
     }];
}

@end
