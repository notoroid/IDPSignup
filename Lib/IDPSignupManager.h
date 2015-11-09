//
//  IDPSignupManager.h
//  IDPSignup
//
//  Created by 能登 要 on 2015/11/07.
//  Copyright © 2015年 Irimasu Densan Planning. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PFObject;

#define IDP_SIGNUP_SIGNUP_PAGE_TITLE @"signupPageTitle"
#define IDP_SIGNUP_SIGNUP_PAGE_MESSAGE @"signupPageMessage"
#define IDP_SIGNUP_SUCCESS_PAGE_TITLE @"successPageTitle"
#define IDP_SIGNUP_SUCCESS_PAGE_MESSAGE @"successPageMessage"
#define IDP_SIGNUP_SUCCESS_PAGE_BUTTON_TITLE @"successPageButtonTitle"
#define IDP_SIGNUP_FAILURE_EXIST_USER_PAGE_TITLE @"failureExistUserPageTitle"
#define IDP_SIGNUP_FAILURE_EXIST_USER_PAGE_MESSAGE @"failureExistUserPageMessage"
#define IDP_SIGNUP_FAILURE_EXIST_USER_PAGE_BUTTON_TITLE @"failureExistUserPageButtonTitle"
#define IDP_SIGNUP_FAILURE_TIMEOUT_PAGE_TITLE @"failureTimeoutPageTitle"
#define IDP_SIGNUP_FAILURE_TIMEOUT_PAGE_MESSAGE @"failureTimeoutPageMessage"

@interface IDPSignupManager : NSObject

+ (IDPSignupManager *) defaultManager;

- (void) signupInviteWithUsername:(NSString *)username mail:(NSString *)mail roles:(NSArray *)roles properties:(NSArray *)properties pageResources:(NSDictionary *)pageResources completion:(void (^)(NSError *error,NSURL *URL))completion; // サインアップを呼び出し

- (void) signupInviteWithUsername:(NSString *)username mail:(NSString *)mail options:(NSDictionary *)options pageResources:(NSDictionary *)pageResources completion:(void (^)(NSError *error,NSURL *URL))completion; // サインアップを呼び出し

- (void) handleOpenURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options signupHandle:(void (^)())signupHandle completion:(void (^)(NSError *error,NSString *username,NSString *email))completion;

@end
