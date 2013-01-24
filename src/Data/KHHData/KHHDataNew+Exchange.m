//
//  KHHDataNew+Exchange.m
//  CardBook
//
//  Created by 王定方 on 13-1-15.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew+Exchange.h"
#import "KHHDataNew+Card.h"
@implementation KHHDataNew (Exchange)
#pragma mark - 发送名片到手机
- (void)sendCard:(long) cardID version:(int) version toPhones:(NSString *) phoneNumbers delegate:(id<KHHDataExchangeDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent sendCard:cardID version:version toPhones:phoneNumbers delegate:self];
}

#pragma mark - 发送名片到指定用户
- (void)sendCard:(long) cardID version:(int) version toUser:(NSString *)userID delegate:(id<KHHNetAgentExchangeDelegates>) delegate
{
    self.delegate = delegate;
    [self.agent sendCard:cardID version:version toUser:userID delegate:self];
}

#pragma mark - 摇摇交换名片
- (void)exchangeCard:(Card *)card withCoordinate:(CLLocationCoordinate2D)coordinate delegate:(id<KHHDataExchangeDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent exchangeCard:card withCoordinate:coordinate delegate:self];
}

#pragma mark - 获取最后获取的名片
- (void)pullLatestReceivedCard
{

}

#pragma mark - KHHNetAgentExchangeDelegates
//交换名片
-(void) exchangeCardSuccess:(NSDictionary *) dict
{
    DLog(@"exchangeCardSuccess! dict = %@", dict);
    //交换成，返回的数据有cardID
    //同步最后一张名片
#warning 这个地方给界面一个消息，告诉界面摇摇交换名片成功，下步是去获取名片信息
    [self latestCustomerCard:self];
}
-(void) exchangeCardFailed:(NSDictionary *) dict
{
    DLog(@"exchangeCardFailed! dict = %@", dict);
    if ([self.delegate respondsToSelector:@selector(exchangeCardForUIFailed:)])
    {
        [self.delegate exchangeCardForUIFailed: dict];
    }
}

//发送到手机
-(void) sendCardToMobileSuccess
{
    DLog(@"sendCardToMobileSuccess!");
    if ([self.delegate respondsToSelector:@selector(sendCardToMobileForUISuccess)])
    {
        [self.delegate sendCardToMobileForUISuccess];
    }
}
-(void) sendCardToMobileFailed:(NSDictionary *) dict
{
    DLog(@"sendCardToMobileFailed! dict = %@", dict);
    if ([self.delegate respondsToSelector:@selector(sendCardToMobileForUIFailed:)])
    {
        [self.delegate sendCardToMobileForUIFailed: dict];
    }
}

-(void) sendCardToUserSuccess
{
    DLog(@"sendCardToUserForUISuccess!");
    if ([self.delegate respondsToSelector:@selector(sendCardToUserForUISuccess)])
    {
        [self.delegate sendCardToMobileForUISuccess];
    }
}
-(void) sendCardToUserFailed:(NSDictionary *) dict
{
    DLog(@"sendCardToUserForUIFailed! dict = %@", dict);
    if ([self.delegate respondsToSelector:@selector(sendCardToUserForUIFailed:)])
    {
        [self.delegate sendCardToUserForUIFailed: dict];
    }
}

#pragma mark - KHHDataCardDelegate
//获取最后一个联系人名片
- (void)getLatestCustomerCardForUISuccess:(NSDictionary *)dict
{
    DLog("getLatestCustomerCardForUISuccess! latest receivedCard = %@", dict);
    //如果本地存在就提示名片存在，如果是新名片保存本地并提示新名片
    //判断cardId在本地有没有，是否是新名片
    if ([self.delegate respondsToSelector:@selector(exchangeCardForUISuccess:)])
    {
        [self.delegate exchangeCardForUISuccess:dict];
    }
}
- (void)getLatestCustomerCardForUIFailed:(NSDictionary *)dict
{
    //虽然交换成功，但是同步名片失败
    if ([self.delegate respondsToSelector:@selector(exchangeCardForUIFailed:)])
    {
        [self.delegate exchangeCardForUIFailed:dict];
    }
}
@end
