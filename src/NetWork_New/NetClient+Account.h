//
//  NetClient+Account.h
//  CardBook
//
//  Created by 王定方 on 13-1-9.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "NetClient.h"
#import "KHHNetClientAccountDelegates.h"

@interface NetClient (Account)
/*
 * 用户登录
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=230
 * 方法 post
 */
- (BOOL)login:(NSString *)user password:(NSString *)password delegate:(id<KHHNetClientAccountDelegates>) delegate;

/*
 * 用户注册
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=231
 * 方法 post
 */
- (void)createAccount:(NSDictionary *)account delegate:(id<KHHNetClientAccountDelegates>) delegate;

/*
 * 用户修改密码
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=232
 * 方法 put
 */
- (BOOL)changePassword:(NSString *)oldPassword toNewPassword:(NSString *)newPassword delegate:(id<KHHNetClientAccountDelegates>) delegate;

/*
 * 用户重置密码
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=233
 * 方法 get
 */
- (BOOL)resetPassword:(NSString *)mobile  delegate:(id<KHHNetClientAccountDelegates>) delegate;
@end
