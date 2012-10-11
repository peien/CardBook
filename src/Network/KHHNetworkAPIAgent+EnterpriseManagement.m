//
//  KHHNetworkAPIAgent+EnterpriseManagement.m
//  CardBook
//
//  Created by 孙铭 on 9/10/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPIAgent+EnterpriseManagement.h"
#import "NSString+SM.h"
#import "NSString+Networking.h"

@implementation KHHNetworkAPIAgent (EnterpriseManagement)
/*!
 根据当前登录用户的公司权限，加载部门列表 employeeViewService.getOrgsByPermission
 @param
 @return
 @see
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=214
 */
- (void)listDepartments {
    [self postAction:@"listDepartments"
               query:@"employeeViewService.getOrgsByPermission"
          parameters:nil
             success:nil];
}

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
- (void)checkIn:(ICheckIn *)iCheckIn {
    NSString *action = @"checkIn";
    DLog(@"[II] iCheckIn = %@", iCheckIn);
    
    NSString *cardID = [NSString stringFromObject:iCheckIn.cardID];
    NSString *deviceToken = [NSString stringFromObject:iCheckIn.deviceToken];
    NSString *latitude = [NSString stringFromObject:iCheckIn.latitude];
    NSString *longitude = [NSString stringFromObject:iCheckIn.longitude];
    NSString *memo = [NSString stringFromObject:iCheckIn.memo];
    NSData *image = UIImageJPEGRepresentation([UIImage imageNamed:@"crm__managerEm@2x.png"], 0.5);
    
    NSDictionary *parameters = @{
    @"bean.cardId"      : cardID,
    @"bean.deviceToken" : deviceToken,
    @"bean.latitude"    : latitude,
    @"bean.longitude"   : longitude,
    @"bean.col1"        : memo,
    };
    // 打包图片
    void (^construction)(id <AFMultipartFormData>formData);
    construction = ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData:image name:@"imgFiles[0]" fileName:@"imgFiles[0].jpg" mimeType:@"image/jpeg"];
    };
    NSDictionary *queries = @{ @"method" : @"kinghhEmployeeVisitCustomService.signInNew" };
    NSString *path = [NSString stringWithFormat:@"%@?%@",@"rest",[self queryStringWithDictionary:queries]];
    NSURLRequest *request = [[KHHHTTPClient sharedClient] multipartFormRequestWithMethod:@"POST"
                                                            path:path
                                                      parameters:parameters
                                       constructingBodyWithBlock:construction];
    [self postAction:action
             request:request
             success:nil
               extra:nil];
}
@end
