//
//  ICustomerEvaluation.h
//  CardBook
//
//  Created by Sun Ming on 12-10-9.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMObject.h"

//keys example:
//{
//    cardId = 0;
//    col1 = "\U91ce\U732a";                      n
//    col2 = "";                                  n
//    customCardId = 126;
//    customCost = 5;
//    customPosition = "";                        n
//    customType = me;
//    gmtCreateTime = "2012-09-07 14:16:27";      n
//    gmtModTime = "2012-09-07 14:16:27";         n
//    id = 3;
//    isDelete = n;
//    knowAddress = "";
//    knowTime = "<null>";
//    relateDepth = 5;
//    userId = 23795;                             n
//    version = 0;
//}

@interface ICustomerEvaluation : SMObject

@property (nonatomic, strong) NSNumber *id;//id = 2;
@property (nonatomic, strong) NSNumber *version;//version = 1;
@property (nonatomic, strong) NSNumber *isDeleted;//isDelete = n;

@property (nonatomic, strong) NSNumber *customerCardID;//customCardId = 32212;
@property (nonatomic) KHHCardModelType customerCardModelType;//customType = linkman;

@property (nonatomic, strong) NSNumber *value;//customCost = "";
@property (nonatomic, strong) NSNumber *degree;//relateDepth = 3;

@property (nonatomic, strong) NSString *firstMeetAddress;//knowAddress = "\U4e0a\U6d77";
@property (nonatomic, strong) NSString *firstMeetDate;//knowTime = "2011-12-13 18:59:59";

@end

@interface ICustomerEvaluation (Methods)
+ (ICustomerEvaluation *)iCustomerEvaluationWithJSON:(NSDictionary *)json;
@end