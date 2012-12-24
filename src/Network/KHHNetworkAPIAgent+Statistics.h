//
//  KHHNetworkAPIAgent+Statistics.h
//  CardBook
//
//  Created by 孙铭 on 8/29/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPIAgent.h"

@interface KHHNetworkAPIAgent (Statistics)
/**
 用户注册信息保存 registerRecordService.save
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=190
 */
/**
 用户登录信息保存 kinghhLoginInfoService.saveLoginInfo
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=189
 */
- (void)saveToken;
@end
