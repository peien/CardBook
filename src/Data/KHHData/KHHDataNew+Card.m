//
//  KHHData+Card.m
//  CardBook
//
//  Created by CJK on 13-1-12.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew+Card.h"
@implementation KHHDataNew (Card)
@dynamic syncType;
#pragma mark - 名片查询---同步;
- (void)syncCard:(id<KHHDataCardDelegate>) delegate
{
    self.delegate = delegate;
    //获取时间
    SyncMark *syncMark = [SyncMark syncMarkByKey:kSyncMarkKeySyncCardLastTime];
    [self.agent syncCard:syncMark.value delegate:self];
}

#pragma mark - 联系人查询---同步;
- (void)syncCustomerCard:(NSString *) startPage pageSize:(NSString *) pageSize delegate:(id<KHHDataCardDelegate>) delegate
{
    self.delegate = delegate;
    //获取时间
    SyncMark *syncMark = [SyncMark syncMarkByKey:kSyncMarkKeySyncCustomerCardLastTime];
    [self.agent syncCustomerCard:startPage pageSize:pageSize lastDate:syncMark.value delegate:self];
}

#pragma mark - 名片新增
- (void)addCard:(InterCard *)iCard delegate:(id<KHHDataCardDelegate>) delegate
{
    //参数判断放到网络接口中
    self.delegate = delegate;
    [self.agent addCard:iCard delegate:self];
}
- (void)addCard:(InterCard *)iCard logoImage:(UIImage *) logoImage cardLinks:(NSArray *) cardLinks delegate:(id<KHHDataCardDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent addCard:iCard logoImage:logoImage cardLinks:cardLinks delegate:self];
}


#pragma mark - 名片编辑
- (void)updateCard:(InterCard *)iCard delegate:(id<KHHDataCardDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent updateCard:iCard delegate:self];
}
- (void)updateCard:(InterCard *)iCard logoImage:(UIImage *) logoImage cardLinks:(NSArray *) cardLinks delegate:(id<KHHDataCardDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent updateCard:iCard logoImage:logoImage cardLinks:cardLinks delegate:self];
}


#pragma mark - 名片删除
- (void)deleteCard:(Card *)card delegate:(id<KHHDataCardDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent deleteCard:card delegate:self];
}


#pragma mark - 设置联系人的状态为已查看
- (void)updateCardReadState:(Card *)card myUserID:(long) userID delegate:(id<KHHDataCardDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent updateCardReadState:card myUserID:userID delegate:self];
}

//名片查询---同步;
- (void)syncCardSuccess:(NSDictionary *) dict
{
    DLog(@"同步名片成功! dict = %@", dict);
    //把返回的名片保存下来，根据cardType与cardSource来判断用什么类型的card来保存
    
    if ([self.delegate respondsToSelector:@selector(syncCardForUISuccess)]) {
        [self.delegate syncCardForUISuccess];
    }
}
- (void)syncCardFailed:(NSDictionary *) dict
{
    DLog(@"同步名片失败! dict = %@", dict);
    if ([self.delegate respondsToSelector:@selector(syncCardForUIFailed:)]) {
        [self.delegate syncCardForUIFailed:dict];
    }
}


//名片新增
- (void)addCardSuccess
{
    DLog(@"添加名片成功!");
    //先同步一下相应名片类型的名片
    //告诉界面，添加成功
    if ([self.delegate respondsToSelector:@selector(addCardForUISuccess)]) {
        [self.delegate addCardForUISuccess];
    }
}
- (void)addCardFailed:(NSDictionary *) dict
{
    DLog(@"添加名片失败! dict = %@", dict);
    if ([self.delegate respondsToSelector:@selector(addCardForUIFailed:)]) {
        [self.delegate addCardForUIFailed:dict];
    }
}

//名片删除
- (void)deleteCardSuccess
{
    DLog(@"删除名片成功! ");
    //先同步一下相应名片类型的名片
    //告诉界面，删除成功
    if ([self.delegate respondsToSelector:@selector(deleteCardForUISuccess)]) {
        [self.delegate deleteCardForUISuccess];
    }
}
- (void)deleteCardFailed:(NSDictionary *)dict
{
    DLog(@"删除名片失败! dict = %@", dict);
    if ([self.delegate respondsToSelector:@selector(deleteCardForUIFailed:)]) {
        [self.delegate deleteCardForUIFailed:dict];
    }
}

//名片编辑
- (void)updateCardSuccess
{
    DLog(@"更新名片成功!");
    //先同步一下相应名片类型的名片
    //告诉界面，更新成功
    if ([self.delegate respondsToSelector:@selector(updateCardForUISuccess)]) {
        [self.delegate updateCardForUISuccess];
    }
    
}
- (void)updateCardFailed:(NSDictionary *)dict
{
    DLog(@"更新名片失败! dict = %@", dict);
    if ([self.delegate respondsToSelector:@selector(updateCardForUIFailed:)]) {
        [self.delegate updateCardForUIFailed:dict];
    }
}

//设置联系人新名片标记
- (void)updateCardNewCardStateSuccess
{
    DLog(@"更新新名片标记成功!");
    //返回更新标记成功（这里只是改一张标记，可以直改本地数据库，建议与服务器同步一次）
    //返回给界面操作成功
    if ([self.delegate respondsToSelector:@selector(updateCardNewCardStateForUISuccess)]) {
        [self.delegate updateCardNewCardStateForUISuccess];
    }
}
- (void)updateCardNewCardStateFailed:(NSDictionary *)dict
{
    DLog(@"更新新名片标记失败! dict = %@", dict);
    if ([self.delegate respondsToSelector:@selector(updateCardne:)]) {
        [self.delegate updateCardForUIFailed:dict];
    }
}

//联系人查询---同步(私有联系人与我的名片);
- (void)syncCustomerCardSuccess:(NSDictionary *) dict
{

}
- (void)syncCustomerCardFailed:(NSDictionary *) dict
{

}
@end
