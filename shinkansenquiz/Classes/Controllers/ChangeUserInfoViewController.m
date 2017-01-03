//
//  ChangeUserInfoViewController.m
//  shinkansenquiz
//
//  Created by Yuji Ogihara on 2015/05/23.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import "ChangeUserInfoViewController.h"

@interface ChangeUserInfoViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (weak, nonatomic) IBOutlet UITextField *nameTex;
@property (weak, nonatomic) PFUser *currentUser ;
@property (weak, nonatomic) IBOutlet UIButton *buttonUpdate;

- (void)UpdateUserInfo ;

@end


@implementation ChangeUserInfoViewController
@synthesize kind     = _kind ;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameTex.delegate = self ;

    self.currentUser = [PFUser currentUser] ;
    switch (self.kind) {
        case 0: // User name
            self.titleText.text = @"お名前変更" ;
            self.nameTex.text = [self.currentUser username] ;
            break;
        case 1: //
            self.titleText.text = @"メールアドレス変更" ;
            self.nameTex.text = [self.currentUser email] ;
            break ;
        case 2: //
            self.titleText.text = @"期変更" ;
            self.nameTex.text = [self.currentUser objectForKey:@"graduate"] ;
            break ;
        case 3:
            self.titleText.text = @"パスワード変更" ;
            self.nameTex.text = [self.currentUser password] ;
            [self.nameTex setSecureTextEntry:YES] ;
            break ;
        default:
            break;
    }
    // Do any additional setup after loading the view.
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
- (IBAction)onButtonUpdate:(id)sender {
    UIAlertController * ac =
    [UIAlertController alertControllerWithTitle:@"変更しますか?"
                                        message:@""
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * destructiveAction =
    [UIAlertAction actionWithTitle:@"しない"
                             style:UIAlertActionStyleDestructive
                           handler:^(UIAlertAction * action) {
                               NSLog(@"Destructive button tapped.");
                               
                           }];
    
    UIAlertAction * okAction =
    [UIAlertAction actionWithTitle:@"変更する"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action) {
                               [self UpdateUserInfo] ;
                           }];
    [ac addAction:destructiveAction];
    [ac addAction:okAction];
    [self presentViewController:ac animated:YES completion:nil];
}

- (IBAction)onChangeText:(id)sender {
    NSString *string ;
    
    switch (self.kind) {
        case 0: // User name
            string = [self.currentUser username] ;
            break;
        case 1: //
            string = [self.currentUser email] ;
            break ;
        case 2: //
            string = [self.currentUser objectForKey:@"graduate"] ;
            break ;
        case 3:
            string = [self.currentUser password] ;
            break ;
        default:
            break;
    }
    
    if ([self.nameTex.text isEqualToString:string]) {
        self.buttonUpdate.enabled = NO ;
    } else {
        self.buttonUpdate.enabled = YES ;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (void)UpdateUserInfo {
    
    switch (self.kind) {
        case 0: // User name
            [[PFUser currentUser] setUsername:self.nameTex.text];
            break;
        case 1: //
            [[PFUser currentUser] setEmail:self.nameTex.text];
            break ;
        case 2: //
            [[PFUser currentUser] setObject:self.nameTex.text forKey: @"graduate"];
            break ;
        case 3:
            [[PFUser currentUser] setPassword:self.nameTex.text];
            break ;
        default:
            break;
    }
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            UIAlertController * ac =
            [UIAlertController alertControllerWithTitle:@"変更しました。"
                                                message:@""
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * okAction =
            [UIAlertAction actionWithTitle:@"戻る"
                                     style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       [self.navigationController popViewControllerAnimated:YES];
                                   
                                   }];
            [ac addAction:okAction];
            [self presentViewController:ac animated:YES completion:nil];
            
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新できませんでした。" message:errorString
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];

        }
    }];

}

@end
