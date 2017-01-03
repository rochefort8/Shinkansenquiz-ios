//
//  PasswordViewController.m
//  shinkansenquiz
//
//  Created by Yuji Ogihara on 2015/05/16.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import "PasswordViewController.h"
#import "UserRegistrationViewController.h"

#import <CommonCrypto/CommonCryptor.h>

@interface PasswordViewController () <UITextFieldDelegate>

- (BOOL)verifyPassword:(NSString*) password ;


@end

@implementation PasswordViewController

BOOL isRequestPassword ;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.passwordText.delegate = self;
    isRequestPassword = true ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onButtonRequestPassword:(id)sender {
    isRequestPassword = true ;
}

- (IBAction)onButt0nNext:(id)sender {
    if ([self verifyPassword:self.passwordText.text] == true) {
        isRequestPassword = false ;
        [self performSegueWithIdentifier:@"toUserRegistrationView" sender:self];
        
    } else {
        NSString *title = @"パスワードが間違っています。";
        NSString *message = @"入力されたパスワードは正しくありません。もう一度入力をお願いします。" ;
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title
                                                           message:message
                                                          delegate:nil cancelButtonTitle:nil
                                                 otherButtonTitles:@"OK", nil];
        [alertView show];
        self.passwordText.text = @"" ;
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (BOOL)verifyPassword:(NSString *) password {
    NSString *key = @"tochiu85";
    NSString *iv = @"FEDCBA9876543210";
    
    NSString *expectedResultString = @"4X4zQV2tzUdNJVx0ZcJP3Q==" ;
    
    NSData *data = [password dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *encryptedPassword = [self crypto:data operation:kCCEncrypt key:key iv:iv];
    NSString *encryptedPasswordString = [encryptedPassword base64EncodedStringWithOptions:0];
    
    if([encryptedPasswordString isEqualToString:expectedResultString]){
        NSLog(@"Identical");
        return true ;
    }else{
        NSLog(@"NOOOOO!!!");
    }
    return false ;
}

- (IBAction)onButton:(id)sender {
    NSLog (@"onButton") ;
}



- (NSData *)crypto:(NSData *)data operation:(CCOperation)operation key:(NSString *)key iv:(NSString *)iv
{
    NSLog(@"%s", __func__);
    
    // Key
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    // IV
    char ivPtr[kCCBlockSizeAES128 + 1];
    bzero(ivPtr, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    // CCCrypt(CCOperation op,
    //         CCAlgorithm alg,
    //         CCOptions options,
    //         const void *key,
    //         size_t keyLength,
    //         const void *iv,
    //         const void *dataIn,
    //         size_t dataInLength,
    //         void *dataOut,
    //         size_t dataOutAvailable,
    //         size_t *dataOutMoved
    
    CCCryptorStatus cryptorStatus = CCCrypt(operation, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                            keyPtr, kCCKeySizeAES128,
                                            ivPtr,
                                            [data bytes], [data length],
                                            buffer, bufferSize,
                                            &numBytesEncrypted);
    
    if(cryptorStatus == kCCSuccess){
        NSLog(@"cryptorStatus == kCCSuccess");
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }else{
        NSLog(@"cryptorStatus != kCCSuccess");
    }
    
    //    4X4zQV2tzUdNJVx0ZcJP3Q==
    
    free(buffer);
    return nil;
}

 #pragma mark - Navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     UserRegistrationViewController *secondViewController = segue.destinationViewController;
     secondViewController.isRequestPassword = isRequestPassword ;
}

@end
