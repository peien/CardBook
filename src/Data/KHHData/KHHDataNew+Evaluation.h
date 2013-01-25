//
//  KHHDataNew+Evaluation.h
//  CardBook
//
//  Created by CJK on 13-1-24.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew.h"
#import "ICustomerEvaluation.h"
#import "MyCard.h"

@interface KHHDataNew (Evaluation)
- (void)saveEvaluation:(ICustomerEvaluation *)icv //
         aboutCustomer:(Card *)aCard              // 客户的名片
            withMyCard:(MyCard *)myCard;
@end
