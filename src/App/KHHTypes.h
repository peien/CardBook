//
//  KHHTypes.h
//
//  Created by 孙铭 on 12-9-19.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#ifndef KHHTypes_h
#define KHHTypes_h

// KHHCardModelType 名片模型，对应于数据库里的类
typedef enum {
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

// KHHTemplateDomainType 模板共有私有
typedef enum {
    KHHTemplateDomainTypePublic   = 1,
    KHHTemplateDomainTypePrivate  = 2,
} KHHTemplateDomainType;
#endif
