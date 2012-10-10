//
//  ICustomerEvaluation.h
//  CardBook
//
//  Created by Sun Ming on 12-10-9.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMObject.h"

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

//customPosition = "\U6d66\U4e1c";
//userId = 11136;
//cardId = 102322;
//col1 = "\U5907\U6ce81";
//col2 = "\U5907\U6ce82";
//gmtCreateTime = "2012-09-06 15:29:43";
//gmtModTime = "2012-09-06 15:29:43";
@end
