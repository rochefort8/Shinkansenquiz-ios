//
//  AppDelegate.m
//  LikeTochiku
//
//  Created by Yuji Ogihara on 2015/02/14.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarController.h"
#import <Parse/Parse.h>

#import "Reachability.h"
#import "MBProgressHUD.h"
#import "Harpy.h"
#import <Keys/ShinkansenQuizKeys.h>

// #import "LoginViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSTimer *autoFollowTimer;

@property (nonatomic, strong) Reachability *hostReach;
@property (nonatomic, strong) Reachability *internetReach;
@property (nonatomic, strong) Reachability *wifiReach;
@property (nonatomic, strong) UIViewController *rootViewController ;

@end

static NSString *const appId = @"9785870" ;

@implementation AppDelegate
@synthesize networkStatus;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        
    // Save root view controller to change this after login
    self.rootViewController = self.window.rootViewController ;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // ---------- Parse server ----------
    ShinkansenquizKeys *keys=[[ShinkansenquizKeys alloc] init] ;
        // Secret Id/Key, stored in keystore by cocoapods-keys

    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = keys.parseApplicationId;
        configuration.clientKey = keys.parseClientKey ;
        configuration.server = @"https://parseapi.back4app.com/";
    }]];
    
    [PFUser enableAutomaticUser];
    PFACL *defaultACL = [PFACL ACL];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];

    // ---------- Reachability ----------
    [self monitorReachability];
    
    // Request for local notification permission
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }

    // ---------- Check for Update / Using "harpy" ----------
        // Set the App ID for your app
    
    [[Harpy sharedInstance] setAppID:appId];
    // FIXME : Doesn't work when [PFUser enableAUtimaticUser] is running,
    // Maybe because rootViewController becomes invalid....

    /* 
     * Move to doLogin()
        // Set the UIViewController that will present an instance of UIAlertController
    [[Harpy sharedInstance] setPresentingViewController:_rootViewController];
    
        // Perform check for new version of your app
    [[Harpy sharedInstance] checkVersion];
    */
    
    // Use background fetch
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [[Harpy sharedInstance] checkVersion];
    
    // Clear icon badge
    [UIApplication sharedApplication].applicationIconBadgeNumber = -1;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)isParseReachable {
    return self.networkStatus != NotReachable;
}

- (void)monitorReachability {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:ReachabilityChangedNotification object:nil];
    
    self.hostReach = [Reachability reachabilityWithHostName: @"api.parse.com"];
    [self.hostReach startNotifier];
    
    self.internetReach = [Reachability reachabilityForInternetConnection];
    [self.internetReach startNotifier];
    
    self.wifiReach = [Reachability reachabilityForLocalWiFi];
    [self.wifiReach startNotifier];
}

//Called by Reachability whenever status changes.
- (void)reachabilityChanged:(NSNotification* )note {
    Reachability *curReach = (Reachability *)[note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NSLog(@"Reachability changed: %@", curReach);
    networkStatus = [curReach currentReachabilityStatus];

    NSLog(@"Network status=%d",networkStatus);
    /*
    if ([self isParseReachable] && [PFUser currentUser] && self.homeViewController.objects.count == 0) {
        // Refresh home timeline on network restoration. Takes care of a freshly installed app that failed to load the main timeline under bad network conditions.
        // In this case, they'd see the empty timeline placeholder and have no way of refreshing the timeline unless they followed someone.
        [self.homeViewController loadObjects];
    }
     */
    // Refresh
}

- (void)doLogin {
    NSLog(@"doLogin");
    
    // Change root view controller for shinkansenquiz tabbar
    self.window.rootViewController = [[TabBarController alloc] init];
    [self.window makeKeyAndVisible];

    // Perform check for new version of your app
    [[Harpy sharedInstance] setPresentingViewController:self.window.rootViewController];
 
    // FIXME : Comment out below until ID for this app is assigned.
    // [[Harpy sharedInstance] checkVersion];
}

- (void)doLogout {
    NSLog(@"doLogout");
    [PFUser logOut] ;
    
    /*
    // Change root view controller for login
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    [self.window makeKeyAndVisible];
    */
    self.window.rootViewController = self.rootViewController ;
    [self.window makeKeyAndVisible];
}

//
// Push nofiitation by parse.com
//
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // コンテンツのダウンロード処理など
    NSLog (@"performFetch") ;
/*
    if (success) {
        if (hasData) {
            completionHandler(UIBackgroundFetchResultNewData);
        } else {
            completionHandler(UIBackgroundFetchResultNoData);
        }
    } else {
        completionHandler(UIBackgroundFetchResultFailed);
    }
 */
}

BOOL bAcceptOrientationLandscape = false ;

- (void)allowOrientationLandscape:(BOOL)flag {
    bAcceptOrientationLandscape = flag ;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)
#else
- (UIInterfaceOrientationMask)
#endif
application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    NSUInteger orientations = UIInterfaceOrientationMaskAll;

    if(self.window.rootViewController){
        /*
        UIViewController *presentedViewController = [[(UINavigationController *)self.window.rootViewController viewControllers] lastObject];
         */
        orientations = UIInterfaceOrientationMaskPortrait ;
        if (bAcceptOrientationLandscape == true) {
            orientations = UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscapeLeft|UIInterfaceOrientationMaskLandscapeRight ;
        }
    }
    return orientations;
}


@end
