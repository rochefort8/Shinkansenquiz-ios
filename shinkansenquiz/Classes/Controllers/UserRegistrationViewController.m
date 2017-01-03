//
//  RegistrationViewController.m
//  userreg
//
//  Created by Yuji Ogihara on 2015/05/16.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import "UserRegistrationViewController.h"
#import "User.h"
#import "AppDelegate.h"

@interface UserRegistrationViewController () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *descriptionText;

@property (nonatomic) User *user ;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (void)requestPassword ;

@end


@implementation UserRegistrationViewController

@synthesize isRequestPassword     = _isRequestPassword ;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.nameText.delegate = self ;
    self.emailText.delegate = self ;
    self.passwordText.delegate = self ;
    self.graduateView.delegate = self ;
    
    _user = [User new];

    [self.activityIndicator setHidden:YES];
    [self.graduateView selectRow:29 inComponent:0 animated:NO];
    
    if (self.isRequestPassword == true) {
        self.descriptionText.text = @"東筑高校同窓生であることを確認でき次第パスワードを連絡しますので、正確にご記入ください.";
        self.passwordText.hidden = true ;
        [self.button setTitle:@"パスワード入手" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES ;
}

- (IBAction)onButton:(id)sender {

    NSString *user = [self.nameText text];
    NSString *pass = [self.passwordText text];
    NSString *email = [self.emailText text];

    self.user.name = self.nameText.text ;
    self.user.email  = self.emailText.text ;
    NSInteger row = [self.graduateView selectedRowInComponent:0] ;
    self.user.graduate = [NSString stringWithFormat:@"%d",(int)(row + 47)];
    
    NSString *graduate = [NSString stringWithFormat:@"%d",(int)(row + 47)];
    
    NSLog(@"Name=%@ Email=%@ Graduate=%@",
          self.user.name,self.user.email,self.user.graduate) ;
    
    if ([user length] == 0) {
        NSString *msg = @"お名前を入力してください.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"不正な入力です"
                                    message:msg
                                    delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return ;
    }
    if ([email length] < 4) {
        NSString *msg ;
        if ([email length] == 0) {
            msg = @"メールアドレスを入力してください.";
        } else {
            msg = @"メールアドレスは４文字以上です.";
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"不正な入力です"
                                                        message:msg
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return ;
    }
    if (self.isRequestPassword == true) {
        [self requestPassword] ;
        return ;
    }

    if ([pass length] < 4) {
        NSString *msg ;
        if ([pass length] == 0) {
            msg = @"パスワードを入力してください.";
        } else {
            msg = @"パスワードは４文字以上です.";
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"不正な入力です"
                                                        message:msg
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return ;
    }

    [self.activityIndicator setHidden:NO];
    [self.activityIndicator setHidesWhenStopped:YES] ;
    [self.activityIndicator startAnimating];
    
    PFUser *newUser = [PFUser user];
    newUser.username = user;
    newUser.password = pass;
    newUser.email = email;
    newUser[@"graduate"] = graduate ;
        
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self.activityIndicator stopAnimating];
        if (error) {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登録できませんでした。" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
        } else {
            NSLog(@"Successful") ;
            UIAlertController * ac =
            [UIAlertController alertControllerWithTitle:@"登録に成功しました。"
                                                message:@"ようこそ「いいね！東筑」へ！"
                                         preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * destructiveAction =
            [UIAlertAction actionWithTitle:@"止める"
                                     style:UIAlertActionStyleDestructive
                                   handler:^(UIAlertAction * action) {
                                       [(AppDelegate*)[[UIApplication sharedApplication] delegate] doLogout];
                                       [self.navigationController popToRootViewControllerAnimated:YES] ;
                                   }];
            
            UIAlertAction * okAction =
            [UIAlertAction actionWithTitle:@"進む"
                                     style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       [self.navigationController popToRootViewControllerAnimated:YES];
                                   }];
            
            [ac addAction:destructiveAction];
            [ac addAction:okAction];
            [self presentViewController:ac animated:YES completion:nil];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView*)pickerView
numberOfRowsInComponent:(NSInteger)component{

    return (2015-1950+8) ;
}

- (void)requestPassword {
    
    NSString *user = [self.nameText text];
    NSString *email = [self.emailText text];
    NSInteger row = [self.graduateView selectedRowInComponent:0] ;
    NSString *graduate = [NSString stringWithFormat:@"%d",(int)(row + 47)];
    
    NSString *mailBody,*tmp ;
    
    mailBody = @"" ;
    mailBody = [mailBody stringByAppendingString:@"------\n"];
    tmp = [NSString stringWithFormat:@"[名前]%@\n",user];
    mailBody = [mailBody stringByAppendingString:tmp];
    tmp = [NSString stringWithFormat:@"[Email]%@\n",email];
    mailBody = [mailBody stringByAppendingString:tmp];
    tmp = [NSString stringWithFormat:@"[期]%@\n",graduate];
    mailBody = [mailBody stringByAppendingString:tmp];
    mailBody = [mailBody stringByAppendingString:@"------\n"];
        
    [PFCloud callFunctionInBackground:@"sendMail"withParameters:@{
                                                                  @"toEmail":@"yuji.ogihara.85@gmail.com",
                                                                  @"toName":@"Yuji Ogihara",
                                                                  @"fromEmail":email,
                                                                  @"fromName":user,
                                                                  @"text":mailBody,
                                                                  @"subject":@"[パスワード入手依頼][iOS]"}
                                block:^(NSString *result, NSError *error) {
                                    if (error) {
                                        NSString *errorString = [[error userInfo] objectForKey:@"error"];
                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"送信できませんでした。" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                        [alert show];
                                        NSLog(@"error:%@", error);
                                    } else {
                                        NSString *errorString = [[error userInfo] objectForKey:@"error"];
                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"パスワード送付を依頼しました。確認が取れ次第、メールにてパスワードが送信されます。しばらくお待ちください。" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                        [alert show];
                                    }
                                }];
    
    
}

-(NSString*)pickerView:(UIPickerView*)pickerView
           titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *graduateString ;
    
    if (row > 0) {
        NSString *eraString;
        if (row < 87-(48-1)) {
            eraString = [NSString stringWithFormat:@"昭和%d年",(int)(62-(85-48)+row -1)] ;
        } else {
            eraString = [NSString stringWithFormat:@"平成%d年",(int)(row-40+1)] ;
        }
        graduateString = [NSString stringWithFormat:@"%d期 (%d年/%@卒)",
                          (int)((48-1) + row), (int)((1950 - 1) + row),eraString];
        if (row == 1) {
            graduateString = [graduateString stringByAppendingString:@"以前"] ;
        }
    } else {
        graduateString =  @"よくわからない" ;
    }
    return graduateString ;
}

@end
