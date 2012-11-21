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
/*!
 客户评估信息新增和修改
 新增：http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=210
 customerAppraiseService.addCustomerAppraise
 修改：http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=211
 customerAppraiseService.updateCustomerAppraise
 参数：
 customerAppraise.id 	 Long 	 否 	 id（andriod客户端没有这张表不使用）
 customerAppraise.cardId 	 Long 	 否 	 当前用户对应名片ID
 customerAppraise.version 	 int 	 否 	 当前用户对应名片版本号
 customerAppraise.customCardId 	 Long 	 是 	 客户名片ID
 customerAppraise.customType 	 String 	 是 客户类型（决定客户手机的类型）linkman---名片ID|me---私有名片ID）
 customerAppraise.customPosition 	 String 	 否 	 客户所在位置
 customerAppraise.relateDepth 	 String 	 否 	 关系深度
 customerAppraise.customCost String 否 	 客户价值
 knowTimeTemp 	 String 	 否 	 认识时间
 customerAppraise.knowAddress 	 String 	 否 	 认识地址
 customerAppraise.col1 	 String 	 否 	 备注1
 customerAppraise.col2 	 String 	 否 	 备注2
 */
- (void)createOrUpdateEvaluation:(ICustomerEvaluation *)icv
                   aboutCustomer:(Card *)aCard
                      withMyCard:(MyCard *)myCard;

@end
