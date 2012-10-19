//
//  KHHNetworkAPIAgent+EnterpriseManagement.h
//  CardBook
//
//  Created by 孙铭 on 9/10/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPIAgent.h"
#import "ICheckIn.h"

@interface KHHNetworkAPIAgent (EnterpriseManagement)
/*!
 根据当前登录用户的公司权限，加载部门列表 employeeViewService.getOrgsByPermission
 @param
 @return
 @see
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=214
 */
//- (void)listDepartments;

#pragma mark - 签到
/*!
 签到 kinghhEmployeeVisitCustomService.signInNew
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=218
 bean.cardId      Long 	 是 	 名片ID
 bean.deviceToken 	 String 	 否 	 手机设备号
 bean.country 	 String 	 否 	 国家
 bean.province 	 String 	 否 	 省
 bean.city 	 String 	 否 	 城市
 bean.address 	 String 	 否 	 地址
 bean.longitude 	 Double 	 否 	 经度
 bean.latitude 	 Double 	 否 	 纬度
 bean.col1 	 String 	 否 	 备忘录
 imgFiles 	 File 	 否 	 签到图片(可传多张，名称相同即可)
 bean.col3 	 String 	 否 	 备注
 bean.col4 	 String 	 否 	 备注
 bean.col5 	 String 	 否 	 备注
 */
- (void)checkIn:(ICheckIn *)iCheckIn;

/*!
 获取员工签到列表
 */
@end
