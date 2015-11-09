//
//  StartViewController.m
//  SignupTest
//
//  Created by 能登 要 on 2015/11/08.
//  Copyright © 2015年 Irimasu Densan Planning. All rights reserved.
//

#import "StartViewController.h"
#import "InviteViewController.h"

@interface StartViewController ()
{
    __weak IBOutlet UITextField *_emailTextView;
    
}
@end

@implementation StartViewController

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if( [segue.identifier isEqualToString:@"inviteSegue"] ){
        InviteViewController *inviteViewController = segue.destinationViewController;
        inviteViewController.email = [_emailTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}

- (IBAction)returnFromInvite:(UIStoryboardSegue *)segue
{
    
}

- (IBAction)onInvite:(id)sender
{
    if( [_emailTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0 ){
        [self performSegueWithIdentifier:@"inviteSegue" sender:nil];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"入力エラー" message:@"メールアドレスを入力してください。" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           
        }]];
        [self presentViewController:alertController animated:YES completion:^{
           
        }];
    }
}

@end
