//
//  AppDelegate.m
//  IDPSignup
//
//  Created by 能登 要 on 2015/11/07.
//  Copyright © 2015年 Irimasu Densan Planning. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "IDPSignup.h"
#import "StartViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#define PARSE_APPLICATION_ID @"nWOQiL7nntaHfHtFxXw8WK0CwYG1dYGafYVVDynS"
#define PARSE_CLIENT_KEY @"d2EscaGiatP0wXVyPaXkMyF6703ubKqKGdK0Bgqg"

#define IDP_SIGNUP_CLASS_KEY_NAME @"Group"
#define IDP_SIGNUP_OBJECT_ID_KEY_NAME @"63QaVm3vop"
#define IDP_SIGNUP_PROPERTY_NAME @"group"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:PARSE_APPLICATION_ID clientKey:PARSE_CLIENT_KEY];
    
    return YES;
}

- (NSString *)usersGroupClassName
{
    return IDP_SIGNUP_CLASS_KEY_NAME;
}

- (NSString *)usersGroupPropertyName
{
    return IDP_SIGNUP_PROPERTY_NAME;
}

- (NSString *)usersGroupObjectID
{
    return IDP_SIGNUP_OBJECT_ID_KEY_NAME;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    [[IDPSignupManager defaultManager] handleOpenURL:url options:options scheme:nil signupHandle:^{
        
    } completion:^(NSError *error, NSString *username, NSString *email) {
       AppDelegate *appDelegate = (AppDelegate *)app.delegate;
       UINavigationController *navigationController =  (UINavigationController *)appDelegate.window.rootViewController;
       StartViewController *startViewController = (StartViewController *)navigationController.topViewController;
       
       startViewController.inviteTextView.text = username;
    }];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

@end
