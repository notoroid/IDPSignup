//
//  IDPSignupManager.m
//  IDPSignup
//
//  Created by 能登 要 on 2015/11/07.
//  Copyright © 2015年 Irimasu Densan Planning. All rights reserved.
//

#import "IDPSignupManager.h"
#import <Parse/Parse.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>

static IDPSignupManager* s_signupManager = nil;

@implementation IDPSignupManager

+ (NSString*) generateUUID {
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, uuidObj);
    NSString *copiedUUIDString = [(__bridge NSString*)uuidString copy];
    CFRelease(uuidString);
    CFRelease(uuidObj);
    return copiedUUIDString;
}

+ (IDPSignupManager *) defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_signupManager = [[IDPSignupManager alloc] init];
    });
    return s_signupManager;
}

- (void) generateInviteWithUsername:(NSString *)username mail:(NSString *)mail options:(NSDictionary *)options pageResources:(NSDictionary *)pageResources completion:(void (^)(NSError *error,PFObject *inviteObject,NSString *invideCode))completion
{
    PFObject *invitation = [PFObject objectWithClassName:@"Invitation"];
    
    NSString *UUIDInvide = [IDPSignupManager generateUUID];
    UUIDInvide = [[UUIDInvide componentsSeparatedByString:@"-"] componentsJoinedByString:@""];
    
    [invitation setObject:UUIDInvide forKey:@"UUID"];
    [invitation setObject:mail forKey:@"email"];
    [invitation setObject:username forKey:@"username"];
    if( options != nil ){
        [invitation setObject:options forKey:@"options"];
    }
    
    if( pageResources != nil ){
        [invitation setObject:pageResources forKey:@"pageResources"];
    }
    
    [invitation saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if( completion != nil ){
            completion( error , succeeded ? invitation : nil , UUIDInvide );
        }
    }];
}

- (void) generateURLWithInvideCode:(NSString *)invideCode completion:(void (^)(NSError *error,NSURL *URL))completion
{
    [PFConfig getConfigInBackgroundWithBlock:^(PFConfig * _Nullable config, NSError * _Nullable error) {
        NSString *invitationURL = [config objectForKey:@"IDPInvitationURL"];
        invitationURL = [invitationURL stringByAppendingString:@"?invitationid="];
        invitationURL = [invitationURL stringByAppendingString:invideCode];
        // 招待コードを連結
        
        //        NSLog(@"invitationURL=%@",invitationURL);
        
        if( completion != nil ){
            completion(error,[NSURL URLWithString:invitationURL]);
        }
    }];
}

- (void) signupInviteWithUsername:(NSString *)username mail:(NSString *)mail roles:(NSArray *)roles properties:(NSArray *)properties pageResources:(NSDictionary *)pageResources completion:(void (^)(NSError *error,NSURL *URL))completion;
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if( roles.count > 0 ){
        dict[@"roles"] = roles;
    }
    
    if( properties.count > 0 ){
        dict[@"properties"] = properties;
    }
    
    [self signupInviteWithUsername:username mail:mail options:[NSDictionary dictionaryWithDictionary:dict] pageResources:pageResources completion:completion];
        // サインアップをyobidasi
}

- (void) signupInviteWithUsername:(NSString *)username mail:(NSString *)mail options:(NSDictionary *)options pageResources:(NSDictionary *)pageResources completion:(void (^)(NSError *error,NSURL *URL))completion
{
    
    [self generateInviteWithUsername:username mail:mail options:options pageResources:pageResources completion:^(NSError *error, PFObject *inviteObject, NSString *invideCode) {
        
        if( error == nil ){
            [self generateURLWithInvideCode:invideCode completion:^(NSError *error, NSURL *URL) {
                if( error == nil ){
                    if( completion ){
                        completion(error,URL);
                    }
                    /*
                    NSLog(@"URL.absoluteString=%@",URL.absoluteString);
                    */
                }else{
                    completion(error,nil);
                }
            }];
        }else{
            completion(error,nil);
        }
    }];
    
    
}

- (void) handleOpenURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options signupHandle:(void (^)())signupHandle completion:(void (^)(NSError *error,NSString *username,NSString *email))completion
{
    [PFConfig getConfigInBackgroundWithBlock:^(PFConfig * _Nullable config, NSError * _Nullable error) {
        NSString *loginScheme = [config objectForKey:@"IDPLoginScheme"];
        
        NSString *invitationCallbackURL = [config objectForKey:@"IDPInvitationURL"];
        invitationCallbackURL = [invitationCallbackURL stringByAppendingString:@"?callbackid="];
        
        NSString *schemeSeparator = @"://";
        loginScheme = [loginScheme hasSuffix:schemeSeparator] ? [loginScheme substringToIndex:loginScheme.length - schemeSeparator.length] : loginScheme;
        
        if( [loginScheme isEqualToString:url.scheme] ){
            if( signupHandle != nil ){
                signupHandle();
            }
            
            invitationCallbackURL = [invitationCallbackURL stringByAppendingString:url.host];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager GET:invitationCallbackURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if( completion != nil ){
                    completion(nil,responseObject[@"username"],responseObject[@"email"]);
                }
            }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if( completion != nil ){
                    completion(error,nil,nil);
                }
            }];
            
        }
        
    }];
}

@end
