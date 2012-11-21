//
//  ICustomerEvaluation.m
//  CardBook
//
//  Created by Sun Ming on 12-10-9.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "ICustomerEvaluation.h"
#import "KHHClasses.h"
#import "NSNumber+SM.h"
#import "NSString+SM.h"

@implementation ICustomerEvaluation

@end
@implementation ICustomerEvaluation (Methods)
+ (ICustomerEvaluation *)iCustomerEvaluationWithJSON:(NSDictionary *)json {
    ICustomerEvaluation *icv = [[ICustomerEvaluation alloc] init];
    
    icv.id        = [NSNumber numberFromObject:json[JSONDataKeyID] zeroIfUnresolvable:NO];//id = 2;
    icv.version   = [NSNumber numberFromObject:json[JSONDataKeyVersion] zeroIfUnresolvable:YES];//version = 1;
    icv.isDeleted = [NSNumber numberFromObject:json[JSONDataKeyIsDelete] zeroIfUnresolvable:YES];//isDelete = n;
    
    icv.customerCardID        = [NSNumber numberFromObject:json[JSONDataKeyCustomCardID] zeroIfUnresolvable:YES];//customCardId = 32212;
    icv.customerCardModelType = [Card CardModelTypeForServerName:json[JSONDataKeyCustomType]];//customType = linkman;
    
    icv.value  = [NSNumber numberFromObject:json[JSONDataKeyCustomCost] zeroIfUnresolvable:YES];//customCost = "";
    icv.degree = [NSNumber numberFromObject:json[JSONDataKeyRelateDepth] zeroIfUnresolvable:YES];//relateDepth = 3;
    icv.remarks = [NSString stringFromObject:json[JSONDataKeyCol1]]; // 备注
    
    icv.firstMeetAddress = [NSString stringFromObject:json[JSONDataKeyKnowAddress]];//knowAddress = "\U4e0a\U6d77";
    icv.firstMeetDate    = [NSString stringFromObject:json[JSONDataKeyKnowTime]];//knowTime = "2011-12-13 18:59:59";
    
    return icv;
}
@end