//
//  InviteViewController.m
//  SignupTest
//
//  Created by 能登 要 on 2015/11/05.
//  Copyright © 2015年 Irimasu Densan Planning. All rights reserved.
//

#import "InviteViewController.h"
#import "IDPSignupManager.h"
#import <Parse/Parse.h>
#import "NSDictionary+IDPSignup.h"
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
        [[IDPSignupManager defaultManager] signupInviteWithUsername:_email mail:_email options:options completion:^(NSError *error, NSURL *URL) {
        
        

            if( error == nil ){
                _inviteURL = URL;
                _inviteTextField.text =_inviteURL.absoluteString;
                
                [_userInviteViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj setHidden:NO];
                }];
                
                [_generateInvitationViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
    
    [[UIApplication sharedApplication] openURL:_inviteURL];
}

- (IBAction)onPastboard:(id)sender
{
    [UIPasteboard generalPasteboard].string = _inviteURL.absoluteString;
}

@end