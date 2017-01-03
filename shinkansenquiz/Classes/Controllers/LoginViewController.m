//
//  LoginViewController.m
//  shinkansenquiz
//
//  Created by Yuji Ogihara on 2015/05/10.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

//@interface LoginViewController () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate,UITextFieldDelegate>
@interface LoginViewController () <UITextFieldDelegate>
{
    NSArray *_descriptions;
}
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passwordEntry;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userName.delegate = self ;
    self.passwordEntry.delegate = self ;

    [self.activityIndicator setHidden:YES];

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

#pragma mark -
#pragma mark PFLogInViewControllerDelegate

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    NSLog(@"Login OK") ;
    [self dismissViewControllerAnimated:YES completion:nil];
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] doLogin];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    NSLog(@"Login canceled") ;
}

#pragma mark -
#pragma mark PFSignUpViewControllerDelegate

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    NSLog(@"Signup OK") ;

    [self dismissViewControllerAnimated:YES completion:nil];
    

}

- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"Signup canceled") ;

    // Do nothing, as the view controller dismisses itself
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (IBAction)onButtonRequestLogin:(id)sender {
    NSLog(@"Request Login") ;
    
    NSString *user = [self.userName text];
    NSString *pass = [self.passwordEntry text];

    NSLog(@"Name=%@",user) ;

    if ([user length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"不正な入力です"
                message:@"ユーザ名かメールアドレスを入力してください." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return ;
    }
    if ([pass length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"不正な入力です"
                                                        message:@"パスワードを入力してください." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return ;
    }
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator setHidesWhenStopped:YES];
    [self.activityIndicator startAnimating];
  

    PFQuery *query = [PFUser query];
    
    [query whereKey:@"email" equalTo:user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){        
        NSString *username = user ; // Assume it is username;

        // email -> username
        if (objects.count > 0) {
            PFObject *object = [objects objectAtIndex:0];
            username = [object objectForKey:@"username"];
        } else {
            // No specified email found, so assume user is "username"
        }
        [PFUser logInWithUsernameInBackground:username password:pass block:^(PFUser* user, NSError* error){
            [self.activityIndicator stopAnimating];
            
            if (user) {
                NSLog(@"Successful") ;
                [self.navigationController popToRootViewControllerAnimated:YES];
                [(AppDelegate*)[[UIApplication sharedApplication] delegate] doLogin];
                
            } else {
                NSLog(@"%@",error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ログインできませんでした" message:@"メールアドレスもしくはパスワードが間違っています." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }];
}
- (IBAction)onPasswordForgottenButton:(id)sender {
    NSString *user = [self.userName text];
    
    NSLog(@"Name=%@",user) ;
    
    if ([user length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"不正な入力です"
                                                        message:@"ユーザ名かメールアドレスを入力してください." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return ;
    }
    
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator setHidesWhenStopped:YES];
    [self.activityIndicator startAnimating];

    PFQuery *query = [PFUser query];
    
    [query whereKey:@"username" equalTo:user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        NSString *email = user ; // Assume it is email;
        
        // email -> username
        if (objects.count > 0) {
            PFObject *object = [objects objectAtIndex:0];
            email = [object objectForKey:@"email"];
        } else {
            // No specified username found, so assume user is "username"
        }
        
        [PFUser requestPasswordResetForEmailInBackground:email
                                                   block:^(BOOL succeeded, NSError *error){
                                                       [self.activityIndicator stopAnimating];
                                     
             if (!succeeded) {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[email stringByAppendingString:@"宛にメール送信できませんでした。"]
                                                                 message:@"メールアドレス、ネットワーク接続状態を確認の上再度お試しください。"
                                                                delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
                 return;
             }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[email stringByAppendingString:@"宛にメール送信"]
                                                            message:@"文中の指示に従いパスワードの再設定を行ってください."
                                                            delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                
            [alert show];
         }];
    }];
}

@end
