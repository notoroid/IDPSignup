//
//  AppDelegate.h
//  IDPSignup
//
//  Created by 能登 要 on 2015/11/07.
//  Copyright © 2015年 Irimasu Densan Planning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly,nonatomic) NSString *usersGroupClassName;
@property (readonly,nonatomic) NSString *usersGroupObjectID;
@property (readonly,nonatomic) NSString *usersGroupPropertyName;

@end

