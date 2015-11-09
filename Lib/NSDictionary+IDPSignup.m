//
//  NSDictionary+IDPSignup.m
//  IDPSignup
//
//  Created by 能登 要 on 2015/11/09.
//  Copyright © 2015年 Irimasu Densan Planning. All rights reserved.
//

#import "NSDictionary+IDPSignup.h"
#import <Parse/Parse.h>

@implementation NSDictionary (IDPSignup)

+ (NSDictionary *) dictionaryWithPropertyName:(NSString *)propertyName className:(NSString *)className objectId:(NSString *)objectId destinationType:(IDPSignupPropertyDestinationType)destinationType
{
    NSDictionary *dict = nil;
    
    if(propertyName.length > 0 && className.length > 0 && objectId.length ){
        dict = @{ @"name":propertyName
                 ,@"className":className
                 ,@"objectId":objectId
                 ,@"destination":destinationType == IDPSignupPropertyDestinationTypeUser ? @"user" : @"object"
                 ,@"type":@"pointer"
                };
    }
    
    return dict;
}

+ (NSDictionary *) dictionaryWithPropertyName:(NSString *)propertyName object:(PFObject *)object destinationType:(IDPSignupPropertyDestinationType)destinationType
{
    NSDictionary *dict = [NSDictionary dictionaryWithPropertyName:propertyName className:object.parseClassName objectId:object.objectId destinationType:destinationType];
    return dict;
}

+ (NSDictionary *) dictionaryWithRelationsName:(NSString *)relationshipName className:(NSString *)className objectId:(NSString *)objectId destinationType:(IDPSignupPropertyDestinationType)destinationType
{
    NSDictionary *dict = nil;
    if(relationshipName.length > 0 && className.length > 0 && objectId.length ){
        dict = @{ @"name":relationshipName
                  ,@"className":className
                  ,@"objectId":objectId
                  ,@"destination":destinationType == IDPSignupPropertyDestinationTypeUser ? @"user" : @"object"
                  ,@"type":@"relations"
                  };
    }
    
    return dict;
}

+ (NSDictionary *) dictionaryWithRelationsName:(NSString *)relationshipName object:(PFObject *)object destinationType:(IDPSignupPropertyDestinationType)destinationType
{
    NSDictionary *dict = [NSDictionary dictionaryWithRelationsName:relationshipName className:object.parseClassName objectId:object.objectId destinationType:destinationType];
    return dict;
}


+ (NSDictionary *) dictionaryWithRoleName:(NSString *)roleName generateType:(IDPSignupRoleGenerateType)generateType acceptRoles:(NSArray *)acceptRoles
{
    NSDictionary *dict = nil;
    
    if(roleName.length > 0 ){
        NSString *generateTypeString = nil;
        switch(generateType) {
            default:
            case IDPSignupRoleGenerateTypeExist:
                generateTypeString = @"new";
                break;
            case IDPSignupRoleGenerateTypeNew:
                generateTypeString = @"exist";
                break;
            case IDPSignupRoleGenerateTypeExistNew:
                generateTypeString = @"existnew";
                break;
        }
        
        NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:
                                                @{ @"name":roleName
                                                  ,@"generateType":generateTypeString
                                                 }];
        if( acceptRoles.count > 0 ){
            mutableDict[@"acceptRoles"] = acceptRoles;
        }
        
        dict = [NSDictionary dictionaryWithDictionary:mutableDict];
    }
    
    return dict;
}

@end
