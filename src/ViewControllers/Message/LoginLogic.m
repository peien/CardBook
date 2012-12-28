//
//  LoginLogic.m
//  CardBook
//
//  Created by CJK on 12-12-27.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "LoginLogic.h"
#import "User.h"
#import "Encryptor.h"

@implementation LoginLogic

-(void)doLogin
{
    
    NSString *action = @"login";
    NSString *pathRoot = @"registerOrLogin";
    NSString *query = @"accountService.login";
    
    NSDictionary *parameters = @{
    @"loginType" : @"MOBILE",
    @"accountNo" : [User sharedInstance].phone,
    @"userPassword" : [User sharedInstance].password
    };
    
    NSURLRequest *request = [[NetClient sharedClient]
                             multipartFormRequestWithMethod:@"POST"
                             path:nil
                             parameters:parameters
                             constructingBodyWithBlock:nil];
}

@end
