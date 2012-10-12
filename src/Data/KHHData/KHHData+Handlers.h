//
//  KHHData+Handlers.h
//  CardBook
//
//  Created by 孙铭 on 12-9-19.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHData.h"

@interface KHHData (Handlers)
- (void)registerHandlersForNotifications;
- (void)handleAllDataAfterDateSucceeded:(NSNotification *)noti;
- (void)handleAllDataAfterDateFailed:(NSNotification *)noti;
@end
@interface KHHData (Handlers_Card)
- (void)handleCreateCardSucceeded:(NSNotification *)noti;
- (void)handleCreateCardFailed:(NSNotification *)noti;
- (void)handleUpdateCardSucceeded:(NSNotification *)noti;
- (void)handleUpdateCardFailed:(NSNotification *)noti;
- (void)handleDeleteCardSucceeded:(NSNotification *)noti;
- (void)handleDeleteCardFailed:(NSNotification *)noti;
- (void)handleDeleteReceivedCardsSucceeded:(NSNotification *)noti;
- (void)handleDeleteReceivedCardsFailed:(NSNotification *)noti;
//- (void)handleReceivedCardCountAfterDateLastCardSucceeded:(NSNotification *)noti;
//- (void)handleReceivedCardCountAfterDateLastCardFailed:(NSNotification *)noti;
- (void)handleReceivedCardsAfterDateLastCardExpectedCountSucceeded:(NSNotification *)noti;
- (void)handleReceivedCardsAfterDateLastCardExpectedCountFailed:(NSNotification *)noti;
- (void)handleLatestReceivedCardSucceeded:(NSNotification *)noti;
- (void)handleLatestReceivedCardFailed:(NSNotification *)noti;
@end
@interface KHHData (Handlers_Template)
- (void)handleTemplatesAfterDateSucceeded:(NSNotification *)noti;
- (void)handleTemplatesAfterDateFailed:(NSNotification *)noti;
@end
@interface KHHData (Handlers_VisitSchedule)
- (void)handleVisitSchedulesAfterDateSucceeded:(NSNotification *)noti;
- (void)handleVisitSchedulesAfterDateFailed:(NSNotification *)noti;
@end
@interface KHHData (Handlers_CustomerEvaluation)
- (void)handleCustomerEvaluationListAfterDateSucceeded:(NSNotification *)noti;
- (void)handleCustomerEvaluationListAfterDateFailed:(NSNotification *)noti;
@end
