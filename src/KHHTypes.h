//
//  KHHTypes.h
//
//  Created by 孙铭 on 12-9-19.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#ifndef KHHTypes_h
#define KHHTypes_h

@class AFHTTPRequestOperation;
@protocol AFMultipartFormData;

typedef void (^KHHSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^KHHFailureBlock)(AFHTTPRequestOperation *operation, NSError *error);
typedef void (^KHHConstructionBlock)(id <AFMultipartFormData> formData);
//无参数的block
typedef void (^KHHDefaultBlock)();

// KHHCardModelType 名片模型，对应于数据库里的类
typedef enum {
    KHHCardModelTypeCard         = 0,
    KHHCardModelTypeMyCard       = 1,
    KHHCardModelTypePrivateCard  = 2,
    KHHCardModelTypeReceivedCard = 3,
} KHHCardModelType;

// KHHCardRoleType 名片角色
typedef enum {
    KHHCardRoleTypePerson            = 1, // 个人
    KHHCardRoleTypeKHHCustomService  = 2, // KHH客服
    KHHCardRoleTypeCompany           = 3, // 公司的名片（通常是公司的客服）
    KHHCardRoleTypeCompanyEmployee   = 4, // 公司的员工 <---- 这个是通常所说的 “公司名片”
} KHHCardRoleType;

// KHHCardAttributeType 
typedef enum {
    KHHCardAttributeNone       = 0UL,
    KHHCardAttributeID         = 1UL << 0,
    KHHCardAttributeVersion    = 1UL << 1,
    KHHCardAttributeName       = 1UL << 2,
    KHHCardAttributeUserID     = 1UL << 3,
    KHHCardAttributeTemplateID = 1UL << 4,
    KHHCardAttributeAll        = ~KHHCardAttributeNone,
} KHHCardAttributeType;

// KHHGroupAttributeType
typedef enum {
    KHHGroupAttributeNone     = 0UL,
    KHHGroupAttributeID       = 1UL << 0,
    KHHGroupAttributeName     = 1UL << 1,
    KHHGroupAttributeParentID = 1UL << 2,
    KHHGroupAttributeAll      = ~KHHGroupAttributeNone,
} KHHGroupAttributeType;

// KHHScheduleAttributeType
typedef enum  {
    KHHScheduleAttributeNone = 0UL,
    KHHScheduleAttributeID   = 1UL << 0,
} KHHScheduleAttributeType;

// KHHTemplateDomainType 模板共有私有
typedef enum {
    KHHTemplateDomainTypePublic   = 1,
    KHHTemplateDomainTypePay,
    KHHTemplateDomainTypePrivate,
} KHHTemplateDomainType;

// KHHQueuedOperationSyncType
typedef enum {
    KHHQueuedOperationSyncPartly = 0,
    KHHQueuedOperationSyncReceivedCards,
    KHHQueuedOperationSyncTemplates,
    KHHQueuedOperationSyncGroups,
    KHHQueuedOperationSyncCardGroupMaps,
    KHHQueuedOperationSyncCustomerEvaluations,
    KHHQueuedOperationSyncVisitSchedules,
    KHHQueuedOperationSyncVisitSchedulesAfterCreation,
    KHHQueuedOperationSyncVisitSchedulesAfterUpdate,
    KHHQueuedOperationSyncVisitSchedulesAfterUploadImage,
    KHHQueuedOperationSyncMyCard,
    KHHQueuedOperationSyncMyCardsAfterUpdate,
} KHHQueuedOperationSyncType;

//一个界面有多个alert 时区分alert的
typedef enum {
    KHHAlertMessage         = 100,
    KHHAlertContact         = 101,
    KHHAlertSync            = 102,
    KHHAlertNewContact      = 103,
    KHHAlertDelete          = 104,
} KHHAlertType;

//客户评估、客户价值详细界面的类型 (KHHValueViewController 界面用到)
typedef enum {
    KHHCustomerVauleFunnel    = 1,
    KHHCustomerVauleRadar     = 2,
} KHHCustomerVauleDetailType;


//拜访计划类型
typedef enum {
    KHHVisitPlanAll          = 1,
    KHHVisitPlanExecuting,
    KHHVisitPlanOverdue,
    KHHVisitPlanFinished,
} KHHVisitPlanType;


//插件类型
typedef enum {
    KUIActionSheetStylePhone,
    KUIActionSheetStyleMessage,
    KUIActionSheetStyleEditGroupMember,
    KUIActionSheetStyleUpload
}KUIActionSheetHomeType;

//界面有多个table（home、组织架构页）,table类型
typedef enum {
    KHHTableIndexGroup = 100,
    KHHTableIndexClient = 101
} KHHTableIndexType;


//日历数据类型
typedef  enum {
    KHHCalendarViewDataTypeCheckIn = 10,
    KHHCalendarViewDataTypeCollect,
} KHHCalendarViewDataType;
#endif
