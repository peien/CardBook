//
//  KHHNetworkAPIAgent+CustomerEvaluation.h
//  CardBook
//
//  Created by Sun Ming on 12-10-9.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHNetworkAPIAgent.h"

@interface KHHNetworkAPIAgent (CustomerEvaluation)
/**
 客户评估信息增量接口 customerAppraiseService.synCustomerAppraise
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=209
 */
- (void)customerEvaluationListAfterDate:(NSString *)lastDate
                                  extra:(NSDictionary *)extra;
@end
