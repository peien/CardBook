//
//  KHHNetClinetAPIAgent+Company.m
//  CardBook
//
//  Created by 王定方 on 13-1-13.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent+Company.h"
#import "InterCard.h"

@implementation KHHNetClinetAPIAgent (Company)
/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=297
 * 获取公司logo
 * url company/logo
 * 方法 get
 */
- (void) getCompanyLogo:(id<KHHNetAgentCompanyDelegates>) delegate
{
    //检查网络
    if (![self networkStateIsValid:delegate selector:@"getCompanyLogoFailed:"]) {
        return;
    }
    
    //url
    NSString *path = @"company/logo";
    
    //服务器有返回值
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        DLog(@"[II] response = %@", responseDict);
        // 把返回的数据转成本地数据
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
        // errorCode
        dict[kInfoKeyErrorCode] = @(code);
        if (KHHErrorCodeSucceeded == code) {
            //companyLogo
            dict[kInfoKeyCompanyLogo] = [responseDict valueForKey:JSONDataKeyCompanyLogo];
            
            //同步成功, 返回到data层进行保存
            if ([delegate respondsToSelector:@selector(getCompanyLogoSuccess:)]) {
                [delegate getCompanyLogoSuccess:dict];
            }
        }else {
            //错误信息
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //同步失败，返回失败信息
            if ([delegate respondsToSelector:@selector(getCompanyLogoFailed:)]) {
                [delegate getCompanyLogoFailed:dict];
            }
        }
    };
    
    //其他错误返回
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"getCompanyLogoFailed:"];
    
    //调接口
    [self getPath:path parameters:nil success:success failure:failed];
}


/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=284
 * 获取公司部门
 * url department/departments
 * 方法 get
 */
- (void) getCompanyDepartment:(id<KHHNetAgentCompanyDelegates>) delegate
{
    //检查网络
    if (![self networkStateIsValid:delegate selector:@"getCompanyDepartmentsFailed:"]) {
        return;
    }
    
    //url
    NSString *path = @"department/departments";
    
    //服务器有返回值
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        DLog(@"[II] response = %@", responseDict);
        // 把返回的数据转成本地数据
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
        // errorCode
        dict[kInfoKeyErrorCode] = @(code);
        if (KHHErrorCodeSucceeded == code) {
            //companyLogo
            dict[kInfoKeyCompanyLogo] = [responseDict valueForKey:JSONDataKeyCompanyLogo];
            
            //同步成功, 返回到data层进行保存
            if ([delegate respondsToSelector:@selector(getCompanyDepartmentsSuccess:)]) {
                [delegate getCompanyDepartmentsSuccess:dict];
            }
        }else {
            //错误信息
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //同步失败，返回失败信息
            if ([delegate respondsToSelector:@selector(getCompanyDepartmentsFailed:)]) {
                [delegate getCompanyDepartmentsFailed:dict];
            }
        }
    };
    
    //其他错误返回
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"getCompanyDepartmentsFailed:"];
    
    //调接口
    [self getPath:path parameters:nil success:success failure:failed];
}

/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=280
 * 获取公司logo
 * url department/{department_id}/{startPage}/{pageSize}
 * 方法 get
 */
- (void) getCompanyColleagueByDepartmentID:(long) departmentID startPage:(int) startPage pageSize:(int) pageSize delegate:(id<KHHNetAgentCompanyDelegates>) delegate
{
    //检查网络
    if (![self networkStateIsValid:delegate selector:@"getColleagueByDepartmentFailed:"]) {
        return;
    }
    
    //检查参数
    if (departmentID <= 0 || startPage < 0 || pageSize <= 0) {
        [self parametersNotMeetRequirementFailedResponse:delegate selector:@"getColleagueByDepartmentFailed:"];
        return;
    }
    
    //url
    NSString *pathFormat = @"department/%ld/%d/%d";
    NSString *path = [NSString stringWithFormat:pathFormat, departmentID, startPage, pageSize];
    
    //服务器有返回值
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        DLog(@"[II] response = %@", responseDict);
        // 把返回的数据转成本地数据
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
        // errorCode
        dict[kInfoKeyErrorCode] = @(code);
        if (KHHErrorCodeSucceeded == code) {
            //employeeList --> reveivedCardList
            NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:20];
            NSArray *employeeList = responseDict[JSONDataKeyEmployeeList];
            for (id obj in employeeList) {
                InterCard *colleague = [InterCard interCardWithReceivedCardJSON:obj nodeName:nil];
                DLog(@"colleague = %@", colleague);
                [newArray addObject:colleague];
            }
            
            dict[kInfoKeyReceivedCardList] = newArray;
            
            //同步成功, 返回到data层进行保存
            if ([delegate respondsToSelector:@selector(getColleagueByDepartmentSuccess:)]) {
                [delegate getColleagueByDepartmentSuccess:dict];
            }
        }else {
            //错误信息
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //同步失败，返回失败信息
            if ([delegate respondsToSelector:@selector(getColleagueByDepartmentFailed:)]) {
                [delegate getCompanyDepartmentsFailed:dict];
            }
        }
    };
    
    //其他错误返回
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"getColleagueByDepartmentFailed:"];
    
    // 调接口
    [self getPath:path parameters:nil success:success failure:failed];
}
@end
