//
//  PAPHomeViewController.m
//  Anypic
//
//  Created by Héctor Ramos on 5/2/12.
//

#import "PAPHomeViewController.h"
//#import "PAPSettingsActionSheetDelegate.h"
//#import "PAPSettingsButtonItem.h"
//#import "PAPFindFriendsViewController.h"
#import "MBProgressHUD.h"
#include "PAPEditPhotoViewController.h"

#import "AppDelegate.h"

@interface PAPHomeViewController ()
//@property (nonatomic, strong)PAPSettingsActionSheetDelegate *settingsActionSheetDelegate;
@property (nonatomic, strong) UIView *blankTimelineView;

//-(IBAction)takePicture:(id)sender;
-(IBAction)takePicture ;

@end

@implementation PAPHomeViewController
@synthesize firstLaunch;
//@synthesize settingsActionSheetDelegate;
@synthesize blankTimelineView;


//#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"撮影" style:UIBarButtonItemStylePlain target:self action:@selector(takePicture)];
    self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                    target:self action:@selector(takePicture)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.backBarButtonItem=nil;
}

-(IBAction)takePicture {
    BOOL cameraDeviceAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    BOOL photoLibraryAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    
    if (cameraDeviceAvailable && photoLibraryAvailable) {
        
        
        UIAlertController * ac =
        [UIAlertController alertControllerWithTitle:@"写真を投稿"
                                            message:@""
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction =
        [UIAlertAction actionWithTitle:@"キャンセル"
                                 style:UIAlertActionStyleDestructive
                               handler:^(UIAlertAction * action) {
                                   NSLog(@"Cancel button tapped.");
                               }];
        
        UIAlertAction * cameraAction =
        [UIAlertAction actionWithTitle:@"カメラで撮影"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   [self shouldStartCameraController] ;
                               }];

        UIAlertAction * photoAlbumAction =
        [UIAlertAction actionWithTitle:@"フォトアルバムより選択"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   [self shouldStartPhotoLibraryPickerController];
                               }];
                
        [ac addAction:cameraAction];
        [ac addAction:photoAlbumAction];
        [ac addAction:cancelAction];
        
        [self presentViewController:ac animated:YES completion:nil];

//        [actionSheet showFromTabBar:self.tabBar];
    } else {
        // if we don't have at least two options, we automatically show whichever is available (camera or roll)
        [self shouldPresentPhotoCaptureController];
    }
}

- (BOOL)shouldPresentPhotoCaptureController {
    BOOL presentedPhotoCaptureController = [self shouldStartCameraController];
    
    if (!presentedPhotoCaptureController) {
        presentedPhotoCaptureController = [self shouldStartPhotoLibraryPickerController];
    }
    
    return presentedPhotoCaptureController;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:NO completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    PAPEditPhotoViewController *viewController = [[PAPEditPhotoViewController alloc] initWithImage:image];
    [viewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    //    [self.navController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    //    [self.navController pushViewController:viewController animated:NO];
    [self.navigationController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self.navigationController pushViewController:viewController animated:NO];
    
//    [self presentModalViewController:self.navigationController animated:YES];
}

#pragma mark - PFQueryTableViewController

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];

    if (self.objects.count == 0 && ![[self queryForTable] hasCachedResult] & !self.firstLaunch) {
        self.tableView.scrollEnabled = NO;
        
        if (!self.blankTimelineView.superview) {
            self.blankTimelineView.alpha = 0.0f;
            self.tableView.tableHeaderView = self.blankTimelineView;
            
            [UIView animateWithDuration:0.200f animations:^{
                self.blankTimelineView.alpha = 1.0f;
            }];
        }
    } else {
        self.tableView.tableHeaderView = nil;
        self.tableView.scrollEnabled = YES;
    }    
}

- (void)showPermissionOfCameraAlertView {
    UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:@"カメラの使用が許可されていません"
                            message:@"設定画面で許可してください。"
                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                            style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // 何もしない
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"設定"
                                        style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)checkPermissionOfCamera {
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if((authStatus == AVAuthorizationStatusRestricted) || (authStatus == AVAuthorizationStatusDenied)) {
        [self showPermissionOfCameraAlertView] ;
        return false ;
    }  else if(authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(!granted) {
                    [self showPermissionOfCameraAlertView] ;
                }
            });
        }];
    }
    return true;
}

- (BOOL)shouldStartCameraController {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        return NO;
    }
    
    // Add
    if ([self checkPermissionOfCamera] == false) {
        return NO ;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]
        && [[UIImagePickerController availableMediaTypesForSourceType:
             UIImagePickerControllerSourceTypeCamera] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        } else if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        
    } else {
        return NO;
    }
    
    cameraUI.allowsEditing = YES;
    cameraUI.showsCameraControls = YES;
    cameraUI.delegate = self;
    
    [self presentViewController:cameraUI animated:YES completion:nil];
    
    return YES;
}


- (BOOL)shouldStartPhotoLibraryPickerController {
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO
         && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)) {
        return NO;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]
        && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]
               && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        
    } else {
        return NO;
    }
    
    cameraUI.allowsEditing = YES;
    cameraUI.delegate = self;
    
//    [self presentModalViewController:cameraUI animated:YES];
    [self presentViewController:cameraUI animated:YES completion:nil];
    
    return YES;
}

#pragma mark - ()

@end
