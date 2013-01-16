//
//  KHHDataNew+Exchange.m
//  CardBook
//
//  Created by 王定方 on 13-1-15.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew+Exchange.h"
@implementation KHHDataNew (Exchange)
#pragma mark - 发送名片到手机
- (void)sendCard:(long) cardID version:(int) version toPhones:(NSString *) phoneNumbers delegate:(id<KHHDataExchangeDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent sendCard:cardID version:version toPhones:phoneNumbers delegate:self];
}


#pragma mark - 摇摇交换名片
- (void)exchangeCard:(Card *)card withCoordinate:(CLLocationCoordinate2D)coordinate delegate:(id<KHHDataExchangeDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent exchangeCard:card withCoordinate:coordinate delegate:self];
}

#pragma mark - KHHNetAgentExchangeDelegates
//交换名片
-(void) exchangeCardSuccess:(NSDictionary *) dict
{
    DLog(@"exchangeCardSuccess! dict = %@", dict);
    //交换成，返回的数据有cardID(不返回version？？？？)
    //判断cardId在本地有没有，是否是新名片
    if ([self.delegate respondsToSelector:@selector(exchangeCardForUISuccess:)])
    {
        [self.delegate exchangeCardForUISuccess:dict];
    }
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
    //交换成，返回的数据有cardID(不返回version？？？？)
    //判断cardId在本地有没有，是否是新名片
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
@end
