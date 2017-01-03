//
//  CommentViewController.m
//  shinkansenquiz
//
//  Created by Yuji Ogihara on 2015/08/08.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController () <UITextFieldDelegate>

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (IBAction)onSend:(id)sender {
    
    NSString *mailBody,*tmp ;
    
    PFUser *user = [PFUser currentUser] ;
    
    NSString *username = [user username];
    NSString *email    = [user email];
    NSString *graduate = [user objectForKey:@"graduate"] ;

    
    mailBody = @"" ;
    mailBody = [mailBody stringByAppendingString:@"------\n"];
    tmp = [NSString stringWithFormat:@"[名前]%@\n",username];
    mailBody = [mailBody stringByAppendingString:tmp];
    tmp = [NSString stringWithFormat:@"[Email]%@\n",email];
    mailBody = [mailBody stringByAppendingString:tmp];
    
    tmp = [NSString stringWithFormat:@"[期]%@\n",graduate];
    mailBody = [mailBody stringByAppendingString:tmp];
    tmp = [NSString stringWithFormat:@"[メッセージ]%@\n",self.textComment.text];
    mailBody = [mailBody stringByAppendingString:tmp];
    mailBody = [mailBody stringByAppendingString:@"------\n"];
    
    NSLog(@"%@",mailBody);
    
    [PFCloud callFunctionInBackground:@"sendMailForMessage"withParameters:@{
                                                                  @"toEmail":@"yuji.ogihara.85@gmail.com",
                                                                  @"toName":@"Yuji Ogihara",
                                                                  @"fromEmail":email,
                                                                  @"fromName":username,
                                                                  @"text":mailBody,
                                                                  @"subject":@"[ベルギービール万歳][作者へ一言][iOS]"}
                                block:^(NSString *result, NSError *error) {
                                    if (error) {
                                        NSString *errorString = [[error userInfo] objectForKey:@"error"];
                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"送信できませんでした。" message:errorString
                                                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                        [alert show];
                                    } else {
                                        UIAlertController * ac =
                                        [UIAlertController alertControllerWithTitle:@"メッセージありがとうござます！"
                                                                            message:@"作者よりご連絡差し上げる際は、よろしくお願いいたします！"
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
