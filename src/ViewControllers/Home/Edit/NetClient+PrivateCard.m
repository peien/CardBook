//
//  NetClient+PrivateCard.m
//  CardBook
//
//  Created by CJK on 13-1-9.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "InterCard.h"
#import "PrivateCard.h"
#import "KHHData.h"


#pragma mark - Paramtrance
NSMutableDictionary * ParametersToCreateCard(InterCard *iCard)
{
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:10];
    // card.templateId
    [result setObject:(iCard.templateID? iCard.templateID.stringValue: @"")
               forKey:@"card.templateId"];
    // detail.name
    [result setObject:(iCard.name? iCard.name:  @"")
               forKey:@"detail.name"];
    // detail.jobTitle
    [result setObject:(iCard.title? iCard.title: @"")
               forKey:@"detail.jobTitle"];
    // detail.email
    [result setObject:(iCard.email? iCard.email: @"")
               forKey:@"detail.email"];
    // detail.companyName
    [result setObject:(iCard.companyName? iCard.companyName: @"")
               forKey:@"detail.companyName"];
    // detail.country
    [result setObject:(iCard.addressCountry? iCard.addressCountry: @"")
               forKey:@"detail.country"];
    // detail.province
    [result setObject:(iCard.addressProvince? iCard.addressProvince: @"")
               forKey:@"detail.province"];
    // detail.city
    [result setObject:(iCard.addressCity? iCard.addressCity: @"")
               forKey:@"detail.city"];
    // detail.address
    [result setObject:(iCard.addressOther? iCard.addressOther: @"")
               forKey:@"detail.address"];
    // detail.zipcode 邮编
    [result setObject:(iCard.addressZip? iCard.addressZip: @"")
               forKey:@"detail.zipcode"];
    // detail.telephone 固定电话
    [result setObject:(iCard.telephone? iCard.telephone: @"")
               forKey:@"detail.telephone"];
    // detail.mobilephone 手机
    [result setObject:(iCard.mobilePhone? iCard.mobilePhone: @"")
               forKey:@"detail.mobilephone"];
    // detail.fax
    [result setObject:(iCard.fax? iCard.fax: @"")
               forKey:@"detail.fax"];
    // detail.qq
    [result setObject:(iCard.qq? iCard.qq: @"")
               forKey:@"detail.qq"];
    // detail.msn
    [result setObject:(iCard.msn? iCard.msn: @"")
               forKey:@"detail.msn"];
    // detail.web
    [result setObject:(iCard.web? iCard.web: @"")
               forKey:@"detail.web"];
    // detail.moreInfo 其他
    [result setObject:(iCard.moreInfo? iCard.moreInfo: @"")
               forKey:@"detail.moreInfo"];
    // detail.col1 公司邮箱
    [result setObject:(iCard.companyEmail? iCard.companyEmail: @"")
               forKey:@"detail.col1"];
    // detail.col2 部门
    [result setObject:(iCard.department? iCard.department: @"")
               forKey:@"detail.col2"];
    // detail.col3 备注（名片中可看到）
    [result setObject:(iCard.remarks? iCard.remarks: @"")
               forKey:@"detail.col3"];
    // detail.microblog 微博
    [result setObject:(iCard.microblog? iCard.microblog: @"")
               forKey:@"detail.microBlog"];
    // detail.wangwang 旺旺
    [result setObject:(iCard.aliWangWang? iCard.aliWangWang: @"")
               forKey:@"detail.wangwang"];
    // detail.businessScope 业务范围
    [result setObject:(iCard.businessScope? iCard.businessScope: @"")
               forKey:@"detail.businessScope"];
    // detail.openBank 开户行
    [result setObject:(iCard.bankAccountBranch? iCard.bankAccountBranch: @"")
               forKey:@"detail.openBank"];
    // detail.bankNO 银行账号
    [result setObject:(iCard.bankAccountNumber? iCard.bankAccountNumber: @"")
               forKey:@"detail.bankNO"];
    return result;
}

#import "NetClient+PrivateCard.h"


@implementation NetClient (PrivateCard)

- (void)CreatePrivateCard:(InterCard *)iCard delegate:(id<delegateNewPrivateForEdit>)delegate
{
//    if ([self.r currentReachabilityStatus]== NotReachable) {
//        [delegate createFail:@"当前无网络，创建失败"];
//        return;
//    }
//   [self postPath:@"card" parameters:ParametersToCreateOrUpdateCard(iCard) success:^(AFHTTPRequestOperation *operation, id responseObject) {
//       NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
//       DLog(@"[II] responseDict = %@", responseDict);
//       KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
//       if (code == 0) {
//           iCard.id = responseDict[@"id"];
//           iCard.modelType = KHHCardModelTypePrivateCard;
//           [PrivateCard processIObject:iCard];
//            [[KHHData sharedData] saveContext];
//           [delegate createDone];
//           
//       }else{
//          [delegate createFail:@"服务器忙"];
//           
//       }
//   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//       [delegate createFail:@"服务器忙"];
//   }];
}

@end




