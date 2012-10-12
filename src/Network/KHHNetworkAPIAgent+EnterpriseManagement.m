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
#import "UIImage+KHH.h"

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
    DLog(@"[II] iCheckIn = %@", iCheckIn);
    
    CLPlacemark *placemark = iCheckIn.placemark;
    // 组合string参数
    NSDictionary *parameters = @{
    @"bean.cardId"      : [NSString stringFromObject:iCheckIn.cardID],
    @"bean.deviceToken" : [NSString stringFromObject:iCheckIn.deviceToken],
    @"bean.latitude"    : [NSString stringFromObject:iCheckIn.latitude],
    @"bean.longitude"   : [NSString stringFromObject:iCheckIn.longitude],
    @"bean.country"     : [NSString stringFromObject:placemark.country],
    @"bean.province"    : [NSString stringWithFormat:@"%@",
                           [NSString stringFromObject:placemark.administrativeArea]],
    @"bean.city"        : [NSString stringWithFormat:@"%@%@",
                           [NSString stringFromObject:placemark.locality],
                           [NSString stringFromObject:placemark.subLocality]],
    @"bean.address"     : [NSString stringWithFormat:@"%@%@",
                           [NSString stringFromObject:placemark.thoroughfare],
                           [NSString stringFromObject:placemark.subThoroughfare]],
    @"bean.col1"        : [NSString stringFromObject:iCheckIn.memo],
    };
    
    // 打包图片
    KHHConstructionBlock construction = ^(id <AFMultipartFormData>formData) {
        NSArray *imageArray = iCheckIn.imageArray;
        for (UIImage *image in imageArray) {
//            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            NSData *imageData = [image resizedImageDataForKHHUpload];
            [formData appendPartWithFileData:imageData
                                        name:@"imgFiles"
                                    fileName:@"imgFiles"
                                    mimeType:@"image/jpeg"];
        }
    };
    
    // 发请求
    NSString *action = @"checkIn";
    NSString *query = @"kinghhEmployeeVisitCustomService.signInNew";
    
    [self postAction:action
               query:query
          parameters:parameters
    constructingBody:construction
             success:nil];
}
@end
