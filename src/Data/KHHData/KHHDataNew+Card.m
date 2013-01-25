//
//  KHHData+Card.m
//  CardBook
//
//  Created by CJK on 13-1-12.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew+Card.h"


#import "CardTemplate.h"
#import "Company.h"






@implementation KHHDataNew (Card)

#pragma mark - 获取本地所有名片
-(NSArray*) allCards
{
    NSNumber *myComID = [NSNumber numberFromString:[KHHUser shareInstance].companyId];
    NSPredicate *predicate = nil;
    if (myComID.integerValue) {
        // 自己属于某公司
        // 用公司ID过滤掉同事
        predicate = [NSPredicate predicateWithFormat:@"company.id <> %@", myComID];
    }
    NSArray *fetched;
    fetched = [ContactCard objectArrayByPredicate:predicate
                                  sortDescriptors:[Card defaultSortDescriptors]];
    // 过滤掉意外情况
    NSMutableArray *result = FilterUnexpectedCardsFromArray(fetched);
    return result;
}



#pragma mark - 获取本地联系人名片
-(NSArray*) allCustomerCards
{
    NSArray *array;
    //老的存放地方
//    NSNumber *myComID = [KHHDefaults sharedDefaults].currentCompanyID;
    //新的存放地方
    NSString *myComID = [KHHUser shareInstance].companyId;
    NSPredicate *predicate = nil;
    if (myComID.integerValue) {
        // 自己属于某公司
        // 用公司ID过滤掉同事
        predicate = [NSPredicate predicateWithFormat:@"company.id <> %@", myComID];
    }
    array = [ReceivedCard objectArrayByPredicate:predicate
                                 sortDescriptors:[Card defaultSortDescriptors]];
    return array;
}

#pragma mark - 获取本地我的名片
- (MyCard *)myCardByID:(NSNumber *)cardID // 根据ID查询
{
    MyCard *aCard;
    aCard = [MyCard objectByID:cardID createIfNone:NO];
    return aCard;
}


#pragma mark - 名片查询---同步;
- (void)syncCard:(id<KHHDataCardDelegate>) delegate
{
    [self syncCard:delegate syncType:KHHCardSyncTypeSyncCard];
}




#pragma mark - 获取本地最后一个联系人
- (void)latestCustomerCard:(id<KHHDataCardDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent latestCustomerCard:self];
}

#pragma mark - 名片查询---同步;
- (void)syncCard:(id<KHHDataCardDelegate>) delegate syncType:(KHHCardSyncType) syncType
{
    self.delegate = delegate;
    self.syncType = syncType;
    //获取时间
    SyncMark *syncMark = [SyncMark syncMarkByKey:kSyncMarkKeySyncCardLastTime];
    [self.agent syncCard:syncMark.value delegate:self];
}

#pragma mark - 联系人查询---同步;
- (void)syncCustomerCard:(NSString *) startPage pageSize:(NSString *) pageSize delegate:(id<KHHDataCardDelegate>) delegate
{
    [self syncCustomerCard:startPage pageSize:pageSize delegate:delegate syncType:KHHCardSyncTypeSyncCustomerCard];
}

- (void)syncCustomerCard:(NSString *) startPage pageSize:(NSString *) pageSize delegate:(id<KHHDataCardDelegate>) delegate syncType:(KHHCardSyncType) syncType
{
    self.delegate = delegate;
    self.syncType = syncType;
    //获取时间
    SyncMark *syncMark = [SyncMark syncMarkByKey:kSyncMarkKeySyncCustomerCardLastTime];
    [self.agent syncCustomerCard:startPage pageSize:pageSize lastDate:syncMark.value delegate:self];
}


#pragma mark - 名片新增
- (void)doAddCard:(InterCard *)iCard delegate:(id<KHHDataCardDelegate>) delegate
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
- (void)doUpdateCard:(InterCard *)iCard delegate:(id<KHHDataCardDelegate>) delegate
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
- (void)doDeleteCard:(Card *)card delegate:(id<KHHDataCardDelegate>) delegate
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

#pragma mark - 过虑本地同步时产生的错误数据
// 过滤掉意外的名片：比如cardid＝＝0
NSMutableArray *FilterUnexpectedCardsFromArray(NSArray *oldArray)
{
    NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:oldArray.count];
    for (Card *card in oldArray) {
        if (card.idValue && card.isFullValue) {
            [newArray addObject:card];
        }
    }
    return newArray;
}


#pragma mark - KHHNetAgentCardDelegate
//名片查询---同步;
- (void)syncCardSuccess:(NSDictionary *) dict
{
    DLog(@"同步名片成功! dict = %@", dict);
    //把返回的名片保存下来，根据cardType与cardSource来判断用什么类型的card来保存
#warning 把同步下来的名片保存到本地数据库中，注意的时要根据cardType与cardSource来判断用什么类型的card 看是要保存在myCard表中还是privateCard表中
    
    //告诉界面操作成功
    switch (self.syncType) {
        case KHHCardSyncTypeAdd:
        {
            //告诉界面，添加成功
            if ([self.delegate respondsToSelector:@selector(addCardForUISuccess)])
            {
                [self.delegate addCardForUISuccess];
            }
        }
            break;
        case KHHCardSyncTypeDelete:
        {
            //告诉界面，删除成功
            if ([self.delegate respondsToSelector:@selector(deleteCardForUISuccess)])
            {
                [self.delegate deleteCardForUISuccess];
            }
        }
            break;
        case KHHCardSyncTypeUpdate:
        {
            //告诉界面，更新成功
            if ([self.delegate respondsToSelector:@selector(updateCardForUISuccess)])
            {
                [self.delegate updateCardForUISuccess];
            }
        }
            break;
        default:
            if ([self.delegate respondsToSelector:@selector(syncCardForUISuccess)])
            {
                [self.delegate syncCardForUISuccess];
            }
            break;
    }
}
- (void)syncCardFailed:(NSDictionary *) dict
{
    DLog(@"同步名片失败! dict = %@", dict);
    //告诉界面操作失败
    switch (self.syncType) {
        case KHHCardSyncTypeAdd:
        {
            if ([self.delegate respondsToSelector:@selector(addCardForUIFailed:)])
            {
                [self.delegate addCardForUIFailed:dict];
            }
        }
            break;
        case KHHCardSyncTypeDelete:
        {
            if ([self.delegate respondsToSelector:@selector(deleteCardForUIFailed:)])
            {
                [self.delegate deleteCardForUIFailed:dict];
            }
        }
            break;
        case KHHCardSyncTypeUpdate:
        {
            if ([self.delegate respondsToSelector:@selector(updateCardForUIFailed:)]) {
                [self.delegate updateCardForUIFailed:dict];
            }
        }
            break;
        default:
            if ([self.delegate respondsToSelector:@selector(syncCardForUIFailed:)])
            {
                [self.delegate syncCardForUIFailed:dict];
            }
            break;
    }
}


//联系人查询---同步;
- (void)syncCustomerCardSuccess:(NSDictionary *) dict
{
    DLog(@"同步联系人成功! dict = %@", dict);
    //把返回的名片保存下来，根据cardType与cardSource来判断用什么类型的card来保存
#warning 把同步下来的名片保存到本地数据库中，注意的时要根据cardType与cardSource来判断用什么类型的card,不知道联系人与同事是怎么放的，以前全是放receivedCard表中
    
    //告诉界面操作成功
    switch (self.syncType) {
        case KHHCardSyncTypeSyncCustomerCardUpdateNewCardState:
        {
            //返回给界面操作成功
            if ([self.delegate respondsToSelector:@selector(updateCardNewCardStateForUISuccess)]) {
                [self.delegate updateCardNewCardStateForUISuccess];
            }
        }
            break;
        default:
            if ([self.delegate respondsToSelector:@selector(syncCustomerCardForUISuccess)])
            {
                [self.delegate syncCustomerCardForUISuccess];
            }
            break;
    }
}
- (void)syncCustomerCardFailed:(NSDictionary *) dict
{
    //告诉界面操作成功
    switch (self.syncType) {
        case KHHCardSyncTypeSyncCustomerCardUpdateNewCardState:
        {
            if ([self.delegate respondsToSelector:@selector(updateCardne:)]) {
                [self.delegate updateCardForUIFailed:dict];
            }
        }
            break;
        default:
            if ([self.delegate respondsToSelector:@selector(syncCustomerCardForUIFailed:)])
            {
                [self.delegate syncCustomerCardForUIFailed:dict];
            }
            break;
    }
}

//名片新增
- (void)addCardSuccess
{
    DLog(@"添加名片成功!");
    //先同步一下相应名片类型的名片
    [self syncCard:self.delegate syncType:KHHCardSyncTypeAdd];
}

- (void)addCardSuccess:(NSDictionary *) dict
{
    DLog(@"添加名片成功!");
    //先同步一下相应名片类型的名片
    //告诉界面，添加成功
    if ([self.delegate respondsToSelector:@selector(addCardForUISuccess:)]) {
        [self.delegate addCardForUISuccess:dict];
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
    [self syncCard:self.delegate syncType:KHHCardSyncTypeDelete];
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
    [self syncCard:self.delegate syncType:KHHCardSyncTypeUpdate];
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
#warning 这个要startPage 和 pageSize 才能同步，如果服务不提供只同步一个联系人接口，那只能在成功后直接改本地数据库的
//    [self syncCustomerCard:nil pageSize:nil delegate:self.delegate syncType:KHHCardSyncTypeSyncCustomerCardUpdateNewCardState];
}
- (void)updateCardNewCardStateFailed:(NSDictionary *)dict
{
    DLog(@"更新新名片标记失败! dict = %@", dict);
    if ([self.delegate respondsToSelector:@selector(updateCardne:)]) {
        [self.delegate updateCardForUIFailed:dict];
    }
}

//获取最后一个联系人名片
- (void)getLatestCustomerCardSuccess:(NSDictionary *)dict
{
    DLog(@"getLatestCustomerCardSuccess!");
    //保存到本地
    InterCard *iCard = dict[kInfoKeyInterCard];
    // 填入数据库
    ReceivedCard *rCard = [ReceivedCard processIObject:iCard];
    [self saveContext];
    
    NSMutableDictionary *info = [[NSMutableDictionary alloc] initWithCapacity:0];
    // 发送消息
    if (rCard) {
        // 数据库操作成功,返回联系人名片
        [info setObject:rCard forKey:kInfoKeyReceivedCard];
    } else {
        // 虽然服务器返回成功，但本地数据库操作失败
        [info setObject:@(KHHErrorCodeLocalDataOperationFailed) forKey:kInfoKeyErrorCode];
    }
    
    //告诉界面
    if ([self.delegate respondsToSelector:@selector(getLatestCustomerCardForUISuccess:)]) {
        [self.delegate getLatestCustomerCardForUISuccess:info];
    }
}
- (void)getLatestCustomerCardFailed:(NSDictionary *)dict
{
    DLog(@"getLatestCustomerCardFailed!");
    if ([self.delegate respondsToSelector:@selector(getLatestCustomerCardForUIFailed:)]) {
        [self.delegate getLatestCustomerCardForUIFailed:dict];
    }
}

#pragma mark - data from manageContext
- (NSArray *)cardsOfUngrouped
{
    NSNumber *myComIDPro = [NSNumber numberFromString: [KHHUser shareInstance].companyId];
    NSPredicate *predicate = nil;
    if (myComIDPro.integerValue) {
        // 自己属于某公司
        predicate = [NSPredicate predicateWithFormat:@"company.id <> %@", myComIDPro];
    }
    NSArray *fetched;
    fetched = [ContactCard objectArrayByPredicate:predicate
                                  sortDescriptors:[Card defaultSortDescriptors]];
    NSMutableArray *filtered = [NSMutableArray arrayWithCapacity:fetched.count];
    for (Card *card in fetched) {
        if (card.groups.count < 1) {
            [filtered addObject:card];
        }
    }
    // 过滤掉意外情况
    NSMutableArray *result =[self filterUnexpectedCardsFromArray:filtered];
    return result;
}

- (NSMutableArray *) filterUnexpectedCardsFromArray:(NSArray *)oldArray
{
    NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:oldArray.count];
    for (Card *card in oldArray) {
        if (card.idValue && card.isFullValue) {
            [newArray addObject:card];
        }
    }
    return newArray;
}

- (NSArray *)cardsOfAll {
    NSNumber *myComID = [NSNumber numberFromString: [KHHUser shareInstance].companyId];
    NSPredicate *predicate = nil;
    if (myComID.integerValue) {
        // 自己属于某公司
        // 用公司ID过滤掉同事
        predicate = [NSPredicate predicateWithFormat:@"company.id <> %@", myComID];
    }
    NSArray *fetched;
    fetched = [ContactCard objectArrayByPredicate:nil
                                  sortDescriptors:[Card defaultSortDescriptors]];
    // 过滤掉意外情况
    NSMutableArray *result = [self filterUnexpectedCardsFromArray:fetched];
    return result;
}

- (NSArray *)cardsOfNew
{
    NSNumber *myComID = [NSNumber numberFromString: [KHHUser shareInstance].companyId];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isRead <> YES"];
    if (myComID.integerValue) {
        // 自己属于某公司
        predicate = [NSPredicate predicateWithFormat:@"(isRead <> YES) && (company.id <> %@)", myComID];
    }
    NSArray *fetched;
    fetched = [ReceivedCard objectArrayByPredicate:predicate
                                   sortDescriptors:@[[Card nameSortDescriptor]]];
    // 过滤掉意外情况
    NSMutableArray *result = [self filterUnexpectedCardsFromArray:fetched];
    return result;
}

#pragma mark - for detailCard
- (void)replyCard:(Card *) receiverCard myDefaultReplyCard:(Card *) myReplyCard {
    if (!receiverCard || !myReplyCard) {
        return;
    }
    
    DLog(@"reply card, the receiver mobilePhone = %@", receiverCard.mobilePhone);
    //判断是不是收到的联系人
    //    if ([receiverCard isKindOfClass: [ReceivedCard class]]) {
    //        [self.agent sendCard:myReplyCard toUser:[[NSString alloc] initWithFormat:@"%@",receiverCard.userID]];
    //    }else if ([receiverCard isKindOfClass: [PrivateCard class]]) {
    //取用户的手机号
    NSArray *mobiles = [receiverCard.mobilePhone componentsSeparatedByString:KHH_SEPARATOR];
    if (!mobiles || mobiles.count <= 0) {
        //发送失败的广播
        return;
    }
    NSMutableArray *newMobiles = [[NSMutableArray alloc] initWithCapacity:0];
    [newMobiles addObject:[mobiles objectAtIndex:0]];
    
    DLog(@"reply card, the receiver mobilePhone at index 0 = %@", mobiles);
    [self.agent sendCard:myReplyCard toPhones:newMobiles delegate:self];
   
}

- (void)doInsertMyCard
{
    
    InterCard *icardPro = [[InterCard alloc]init];
    icardPro.id = @(10);
    icardPro.userID = [NSNumber numberFromString:[KHHUser shareInstance].userId];
    icardPro.mobilePhone = [KHHUser shareInstance].username;
   
    
    [CardTemplate processJSON:[[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"template" ofType:@"plist"]][@"templatelist"][0]];
   // Company *company = [Company objectByID:@(10) createIfNone:YES];
//    icardPro.companyName = @"000";
//    icardPro.companyID = @"";
    
    icardPro.templateID = @(10);
    
    icardPro.modelType = KHHCardModelTypeMyCard;
    icardPro.name = [KHHUser shareInstance].username;
    [MyCard processIObject:icardPro];
    [self saveContext];
}

- (NSArray *)allMyCards
{
    NSArray *array;
   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"modelType == %d", KHHCardModelTypeMyCard];
    array = [MyCard objectArrayByPredicate:predicate
                           sortDescriptors:@[[Card nameSortDescriptor],[Card companyCardSortDescriptor]]];
    return array;
}



- (void)modifyMyCardWithInterCard:(InterCard *)iCard
{
    iCard.modelType = KHHCardModelTypeMyCard;
    [self.agent updateCard:iCard delegate:self];    
}

/*!
 PrivateCard: 我自己创建的联系人, 即 PrivateCard 私有联系人
 */
- (NSArray *)allPrivateCards
{
    NSArray *array;
    array = [PrivateCard objectArrayByPredicate:nil
                                sortDescriptors:@[[Card nameSortDescriptor]]];
    return array;
}

- (PrivateCard *)privateCardByID:(NSNumber *)cardID
{
    PrivateCard *aCard = [PrivateCard objectByID:cardID
                                    createIfNone:NO];
    return aCard;
}

- (void)createPrivateCardWithInterCard:(InterCard *)iCard
{
    iCard.modelType = KHHCardModelTypePrivateCard;
    [self.agent addCard:iCard delegate:self];
    
}

- (void)modifyPrivateCardWithInterCard:(InterCard *)iCard
{
    iCard.modelType = KHHCardModelTypePrivateCard;
    [self.agent updateCard:iCard delegate:self];
    
}

- (void)deletePrivateCardByID:(NSNumber *)cardID
{
    Card *cardPro = [Card objectByID:cardID createIfNone:NO];
   
    [self.agent deleteCard:cardPro delegate:self];
   
}

/*!
 ReceivedCard: 收到的联系人, 即通常所说的“联系人”
 */
- (NSArray *)allReceivedCards
{
    NSArray *array;
    NSNumber *myComID = [NSNumber numberFromString:[KHHUser shareInstance].companyId];
    NSPredicate *predicate = nil;
    if (myComID.integerValue) {
        // 自己属于某公司
        // 用公司ID过滤掉同事
        predicate = [NSPredicate predicateWithFormat:@"company.id <> %@", myComID];
    }
    array = [ReceivedCard objectArrayByPredicate:predicate
                                 sortDescriptors:[Card defaultSortDescriptors]];
    return array;
}

- (ReceivedCard *)receivedCardByID:(NSNumber *)cardID
{
    ReceivedCard *aCard = [ReceivedCard objectByID:cardID
                                      createIfNone:NO];
    return aCard;
}

- (void)deleteReceivedCard:(ReceivedCard *)receivedCard;
{
    NSArray *cardList = @[receivedCard];
    for (Card *cardPro in  cardList) {
        [self.agent deleteCard:cardPro delegate:self];
    }
    //[self.agent deleteReceivedCards:cardList];
}

- (void)markIsRead:(ReceivedCard *)aCard
{
   // [self.agent markReadReceivedCard:aCard];
}


// 通过几颗星筛选关系
- (NSArray *)cardsOfstartsForRelation:(float)starts groupID: (long) groupID
{
    NSMutableArray *result;
    NSArray *fetched;
    NSPredicate *predicate;
    
    NSMutableString *pre = [[NSMutableString alloc] initWithCapacity:40];
    
    //关系条件
    if (starts == -1) {
        [pre appendString:[NSString stringWithFormat:@"evaluation.degree >= 1"]];
    }else {
        [pre appendString:[NSString stringWithFormat:@"evaluation.degree == %f",starts]];
    }
    
    //分组的条件
    if (groupID > 0) {
        [pre appendString:[NSString stringWithFormat:@"%@%ld",@" && SOME groups.id == ",groupID]];
    }
    
    predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@", pre]];
    
    fetched = [ContactCard objectArrayByPredicate:predicate
                                  sortDescriptors:[Card defaultSortDescriptors]];
    result = FilterUnexpectedCardsFromArray(fetched);
    return result;
    
}

- (NSArray *)cardsofStarts:(float)starts
{
    NSMutableArray *result;
    NSArray *fetched;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"evaluation.value == %f",starts]];
    fetched = [ContactCard objectArrayByPredicate:predicate
                                  sortDescriptors:[Card defaultSortDescriptors]];
    result = FilterUnexpectedCardsFromArray(fetched);
    return result;
}

- (NSArray *)cardsofStarts:(float)starts groupId:(NSNumber *)groupId
{
    if (!groupId) {
        return [self cardsofStarts:starts];
    }
    NSMutableArray *result;
    NSArray *fetched;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(evaluation.value == %f) AND (ANY groups.id = %d)",starts,[groupId intValue]]];
    fetched = [ContactCard objectArrayByPredicate:predicate
                                  sortDescriptors:[Card defaultSortDescriptors]];
    result = FilterUnexpectedCardsFromArray(fetched);
    return result;
}


#pragma mark - 同事（companyid与自己相同）

- (NSArray *)cardsOfColleague
{
    NSNumber *myComID = [NSNumber numberFromString:[KHHUser shareInstance].companyId] ;
    NSMutableArray *result = [NSMutableArray array];
    if (myComID.integerValue) {
        // 自己属于某公司
        NSPredicate *predicate =  [NSPredicate predicateWithFormat:@"company.id == %@", myComID];
        NSArray *fetched;
        fetched = [ContactCard objectArrayByPredicate:predicate
                                      sortDescriptors:[Card defaultSortDescriptors]];
        // 过滤掉意外情况
        result = FilterUnexpectedCardsFromArray(fetched);
    }
    return result;
}

@end
