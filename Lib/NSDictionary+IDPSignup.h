//
//  NSDictionary+IDPSignup.h
//  IDPSignup
//
//  Created by 能登 要 on 2015/11/09.
//  Copyright © 2015年 Irimasu Densan Planning. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,IDPSignupPropertyDestinationType)
{
     IDPSignupPropertyDestinationTypeUser
    ,IDPSignupPropertyDestinationTypeObject
};

typedef NS_ENUM(NSInteger,IDPSignupRoleGenerateType)
{
     IDPSignupRoleGenerateTypeExist
    ,IDPSignupRoleGenerateTypeNew
    ,IDPSignupRoleGenerateTypeExistNew
};

@class PFObject;

@interface NSDictionary (IDPSignup)

+ (NSDictionary *) dictionaryWithPropertyName:(NSString *)propertyName className:(NSString *)className objectId:(NSString *)objectId destinationType:(IDPSignupPropertyDestinationType)destinationType;

+ (NSDictionary *) dictionaryWithPropertyName:(NSString *)propertyName object:(PFObject *)object destinationType:(IDPSignupPropertyDestinationType)destinationType;


+ (NSDictionary *) dictionaryWithRelationsName:(NSString *)relationshipName className:(NSString *)className objectId:(NSString *)objectId destinationType:(IDPSignupPropertyDestinationType)destinationType;

+ (NSDictionary *) dictionaryWithRelationsName:(NSString *)relationshipName object:(PFObject *)object destinationType:(IDPSignupPropertyDestinationType)destinationType;


+ (NSDictionary *) dictionaryWithRoleName:(NSString *)roleName generateType:(IDPSignupRoleGenerateType)generateType acceptRoles:(NSArray *)acceptRoles;


@end
