//
//  KHHNetClinetAPIAgent+Account.h
//  CardBook
//
//  Created by 王定方 on 13-1-9.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetAgentAccountDelegates.h"
#import "KHHNetClinetAPIAgent.h"

@interface KHHNetClinetAPIAgent (Account)
/*
 * 用户登录
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=230
 * 方法 post
 */
- (BOOL)login:(NSString *)user password:(NSString *)password delegate:(id<KHHNetAgentAccountDelegates>) delegate;

/*
 *
 */
- (void)loginStep2:(NSString *)user password:(NSString *)password sessionId:(NSString *)sessionId companyId:(NSString *)companyId delegate:(id<KHHNetAgentAccountDelegates>) delegate;
/*
 * 用户注册
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=231
 * 方法 post
 */
- (void)createAccount:(NSDictionary *)account delegate:(id<KHHNetAgentAccountDelegates>) delegate;

/*
 * 用户修改密码
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=232
 * 方法 put
 */
- (BOOL)changePassword:(NSString *)oldPassword toNewPassword:(NSString *)newPassword delegate:(id<KHHNetAgentAccountDelegates>) delegate;

/*
 * 用户重置密码
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=233
 * 方法 get
 */
- (BOOL)resetPassword:(NSString *)mobile  delegate:(id<KHHNetAgentAccountDelegates>) delegate;

#pragma mark - save token
- (void)saveToken;
@end
