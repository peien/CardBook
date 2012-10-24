//
//  KHHActions.h
//  CardBook
//
//  Created by Sun Ming on 12-10-15.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#ifndef KHHActions_h
#define KHHActions_h

#pragma mark - Group
static NSString * const kActionNetworkChildGroupsOfGroupID = @"NetworkChildGroupsOfGroupID";
static NSString * const kActionNetworkCardIDsInAllGroup    = @"NetworkCardIDsInAllGroup";
#pragma mark - CustomerEvaluation
static NSString * const kActionNetworkCreateOrUpdateEvaluation = @"NetworkCreateOrUpdateEvaluation";
#pragma mark - Schedule
static NSString * const kActionNetworkCreateVisitSchedule = @"NetworkCreateVisitSchedule";
static NSString * const kActionNetworkUpdateVisitSchedule = @"NetworkUpdateVisitSchedule";
static NSString * const kActionNetworkDeleteVisitSchedule = @"NetworkDeleteVisitSchedule";
static NSString * const kActionNetworkUploadImageForVisitSchedule = @"NetworkUploadImageForVisitSchedule";
static NSString * const kActionNetworkDeleteImageFromVisitSchedule = @"NetworkDeleteImageFromVisitSchedule";

#endif
