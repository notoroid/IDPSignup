//
//  InviteViewController.m
//  SignupTest
//
//  Created by 能登 要 on 2015/11/05.
//  Copyright © 2015年 Irimasu Densan Planning. All rights reserved.
//

#import "InviteViewController.h"
#import "IDPSignup.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"

@interface InviteViewController ()
{
    BOOL _initialized;
    IBOutletCollection(UIView) NSArray *_generateInvitationViews;
    IBOutletCollection(UIView) NSArray *_userInviteViews;
    
    NSURL *_inviteURL;
    __weak IBOutlet UITextField *_inviteTextField;
}
@end

@implementation InviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_userInviteViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setHidden:YES];
    }];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if( _initialized != YES ){
        _initialized = YES;
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        NSDictionary *options = @{  @"roles":@[
                                                [NSDictionary dictionaryWithRoleName:@"User" generateType:IDPSignupRoleGenerateTypeExistNew acceptRoles:@[@"Administrators"]]
                                            ]
                                   ,@"properties":@[
                                                [NSDictionary dictionaryWithPropertyName:appDelegate.usersGroupPropertyName className:appDelegate.usersGroupClassName objectId:appDelegate.usersGroupObjectID destinationType:IDPSignupPropertyDestinationTypeUser]
                                           ]
                                   };
        
        NSDictionary *pageResources = @{
                                        IDP_SIGNUP_SIGNUP_PAGE_TITLE:/*@"サインアップ"*/ @"Signup"
                                        ,IDP_SIGNUP_SIGNUP_PAGE_MESSAGE:[NSString stringWithFormat:@"%@ さん。アカウント作成のためのパスワードを入力。",_email]
                                        ,IDP_SIGNUP_SUCCESS_PAGE_TITLE:/*@"サインアップ成功"*/ @"Succeed"
                                        ,IDP_SIGNUP_SUCCESS_PAGE_MESSAGE:[NSString stringWithFormat:@"%@ さん。アカウント作成が完了。以下のボタンをタップしてアプリケーションを起動してください。",_email]
                                        ,IDP_SIGNUP_SUCCESS_PAGE_BUTTON_TITLE:@"アプリケーションを起動"
                                        ,IDP_SIGNUP_FAILURE_EXIST_USER_PAGE_TITLE:/*@"既存のユーザー"*/@"Failure"
                                        ,IDP_SIGNUP_FAILURE_EXIST_USER_PAGE_MESSAGE:[NSString stringWithFormat:@"%@ さんは既に作成済み。",_email]
                                        ,IDP_SIGNUP_FAILURE_EXIST_USER_PAGE_BUTTON_TITLE:@"アプリケーションを起動"
                                        ,IDP_SIGNUP_FAILURE_TIMEOUT_PAGE_TITLE:/*@"タイムアウト"*/@"Timeout"
                                        ,IDP_SIGNUP_FAILURE_TIMEOUT_PAGE_MESSAGE:@"招待の期限が切れました  。招待元にリクエストを要求してください。"
                                        };
        [[IDPSignupManager defaultManager] signupInviteWithUsername:_email mail:_email options:options pageResources:pageResources completion:^(NSError *error, NSURL *URL) {

            if( error == nil ){
                self->_inviteURL = URL;
                self->_inviteTextField.text =self->_inviteURL.absoluteString;
                
                NSLog(@"inviteURL=%@",self->_inviteURL.absoluteString);
                
                [self->_userInviteViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj setHidden:NO];
                }];
                
                [self->_generateInvitationViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj setHidden:YES];
                }];
            }
        }];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)onInvite:(id)sender
{
    [self performSegueWithIdentifier:@"returnToStartSegue" sender:nil];
    
    [[UIApplication sharedApplication] openURL:_inviteURL options:@{} completionHandler:nil];
}

- (IBAction)onPastboard:(id)sender
{
    [UIPasteboard generalPasteboard].string = _inviteURL.absoluteString;
}

@end
