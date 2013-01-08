//
//  KHHStringRes.h
//  CardBook
//
//  Created by 王定方 on 12-12-5.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#ifndef KHHStringRes_h
#define KHHStringRes_h
static NSString * const KHHMessageSure                          = @"确定";
static NSString * const KHHMessageCancle                        = @"取消";
static NSString * const KHHMessageSave                          = @"保存";
static NSString * const KHHMessageBack                          = @"返回";
static NSString * const KHHMessageFailed                        = @"失败";
static NSString * const KHHMessageSucceed                       = @"成功";
static NSString * const KHHMessageNetworkEorror                 = @"网络错误，请检查您的网络";
static NSString * const KHHMessageCreateVisitPlant              = @"正在创建拜访计划...";
static NSString * const KHHMessageModifyVisitPlant              = @"正在修改拜访计划...";
static NSString * const KHHMessageSaveFailed                    = @"保存失败";
static NSString * const KHHMessageModifyFailed                  = @"修改失败";
static NSString * const KHHMessageResetPassword                 = @"重置密码";
static NSString * const KHHMessageInvalidPhone                  = @"无效手机号";
static NSString * const KHHMessageResetRequestIsSended          = @"重置请求已发送,请留意您的短信";
static NSString * const KHHMessageSend                          = @"发送";
static NSString * const KHHMessageCreateCard                    = @"正在创建名片...";
static NSString * const KHHMessageModifyCard                    = @"正在修改名片...";
static NSString * const KHHMessageCreateCardFailed              = @"新建名片失败";
static NSString * const KHHMessageModifyCardFailed              = @"修改名片失败";
static NSString * const KHHMessageSyncAllFailed                 = @"同步数据失败";
static NSString * const KHHMessageSyncAll                       = @"正在从服务器上同步数据，请稍后";
static NSString * const KHHMessageEditMessage                   = @"编辑消息";
static NSString * const KHHMessageEditMessageFailed             = @"删除消息失败,请稍后再试";
static NSString * const KHHMessageDeleteMessage                 = @"正在删除消息,请稍后";
static NSString * const KHHMessageSyncMessage                   = @"正在同步消息,请稍后";
static NSString * const KHHMessageBMapAPIKey                    = @"75A59306A8389FED58ED8A8D65FDCE5E6F83B052";
static NSString * const KhhMessageAddressEditNotice             = @"点击选择省市";
static NSString * const KhhMessageSyncDataWithServer            = @"与服务器同步数据，可能会消耗您的流量，建议在WiFi网络下同步。您确定要同步吗？";
static NSString * const KhhMessageVisitRecordCustomerIsNull     = @"拜访对象是空,请选择或手动输入拜访对象。";
static NSString * const KhhMessageDataError                     = @"您的数据没有从服务器上同步完全，严重影响您的使用,强烈建议您立即与服务器进行次数据同步。是否立即同步？";
static NSString * const KhhMessageDataErrorNotice               = @"您的数据没有从服务器上同步完全，导致您无法正常执行当前操作。强烈建议您立即返回首页进行一次同步操作。";
static NSString * const KhhMessageDataErrorTitle                = @"数据出错";
static NSString * const KhhMessageDeleteContact                 = @"正在删除联系人,请稍后";
static NSString * const KHHMessageCreatingGroup                 = @"正在创建分组...";
static NSString * const KHHMessageModifingGroup                 = @"正在修改分组...";
static NSString * const KHHMessageDeletingGroup                 = @"正在删除分组...";
static NSString * const KHHMessageAddingGroupMember             = @"正在添加组员...";
static NSString * const KHHMessageDeletingGroupMember           = @"正在移除组员...";
static NSString * const KHHMessageCreateGroup                   = @"创建分组";
static NSString * const KHHMessageModifyGroup                   = @"修改组名";
static NSString * const KHHMessageDeleteGroup                   = @"删除分组";
static NSString * const KHHMessageAddGroupMember                = @"添加组员";
static NSString * const KHHMessageDeleteGroupMember             = @"移除组员";
static NSString * const KHHMessageCreateCustomValue             = @"正在保存客户评估值...";
static NSString * const KHHMessageAddContactToLocal             = @"保存至手机通讯录";
static NSString * const KHHMessageDefaultGroupAll               = @"所有";
static NSString * const KHHMessageDefaultGroupColleague         = @"同事";
static NSString * const KHHMessageDefaultGroupUnGroup           = @"未分组";
static NSString * const KHHMessageDefaultGroupLocal             = @"手机";
static NSString * const KHHMessagePersonalAccount               = @"个人账户";
static NSString * const KHHMessageCompanyAccount                = @"公司账户";
static NSString * const KHHMessageSendRecord                    = @"手机发送记录";
static NSString * const KHHMessageDataCollect                   = @"数据采集";
static NSString * const KHHMessageCheckIn                       = @"考勤";
static NSString * const KHHMessageCreatePlan                    = @"新建计划";
static NSString * const KHHMessageViewCalendar                  = @"日历查看";
#endif

//常量
#ifndef KHH_DEFAULT_COORDINATE
#define KHH_DEFAULT_COORDINATE CLLocationCoordinate2DMake(0, 0)
#endif

#ifndef KHH_Default_Point
#define KHH_Default_Point CGPointMake(0.0f, 0.0f)
#endif