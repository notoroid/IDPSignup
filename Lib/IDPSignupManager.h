//
//  IDPSignupManager.h
//  IDPSignup
//
//  Created by 能登 要 on 2015/11/07.
//  Copyright © 2015年 Irimasu Densan Planning. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PFObject;

#define IDP_SIGNUP_DEFAULT_PAGE_TITLE @"defaultPageTitle"

@interface IDPSignupManager : NSObject

+ (IDPSignupManager *) defaultManager;

- (void) signupInviteWithUsername:(NSString *)username mail:(NSString *)mail roles:(NSArray *)roles properties:(NSArray *)properties pageResources:(NSDictionary *)pageResources completion:(void (^)(NSError *error,NSURL *URL))completion; // サインアップを呼び出し

- (void) signupInviteWithUsername:(NSString *)username mail:(NSString *)mail options:(NSDictionary *)options pageResources:(NSDictionary *)pageResources completion:(void (^)(NSError *error,NSURL *URL))completion; // サインアップを呼び出し

- (void) handleOpenURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options signupHandle:(void (^)())signupHandle completion:(void (^)(NSError *error,NSString *username,NSString *email))completion;

@end
