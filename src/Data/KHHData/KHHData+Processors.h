//
//  KHHData+Processors.h
//  CardBook
//
//  Created by Sun Ming on 12-9-22.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHData.h"

@interface KHHData (Processors)
// 解析一个对象
// 以下情况会返回nil
// 1.objDict为空或nil
// 2.className为空或nil
// 3.ID为空或nil，或者查不到对象
- (NSManagedObject *)processObject:(NSDictionary *)objDict ofClass:(NSString *)className withID:(NSNumber *)ID;
@end
#pragma mark - Processors_List
@interface KHHData (Processors_List)
// card
// 返回各种Card数组
- (NSMutableArray *)processCardList:(NSArray *)list cardType:(KHHCardModelType)type;
- (NSMutableArray *)processMyCardList:(NSArray *)list;
- (NSMutableArray *)processPrivateCardList:(NSArray *)list;
- (NSMutableArray *)processReceivedCardList:(NSArray *)list;

// template
// CardTemplate数组
- (NSMutableArray *)processCardTemplateList:(NSArray *)list;
// CardTemplateItem数组
- (NSMutableArray *)processCardTemplateItemList:(NSArray *)list;

@end
#pragma mark - Processors_Object
@interface KHHData (Processors_Object)
// 返回各种Card对象
- (Card *)processCard:(NSDictionary *)aCard cardType:(KHHCardModelType)type;
// 返回CardTemplate
- (CardTemplate *)processCardTemplate:(NSDictionary *)cardTemplate;
// 返回CardTemplateItem
- (CardTemplateItem *)processCardTemplateItem:(NSDictionary *)templateItem;
// 返回Company对象
- (Company *)processCompany:(NSDictionary *)company;
//
- (void)processSyncTime:(NSString *)syncTime;
@end
#pragma mark - Processors_FillContent
@interface KHHData (Processors_FillContent)
// 填地址数据。并把填好的地址返回。
- (Address *)fillAddress:(Address *)address withJSON:(NSDictionary *)json;
// 填银行帐户数据。并把填好的银行帐户返回。
- (BankAccount *)fillBankAccount:(BankAccount *)bankAccount withJSON:(NSDictionary *)json;
// JSON data -> Card
- (Card *)fillCard:(Card *)card ofType:(KHHCardModelType)type withJSON:(NSDictionary *)dict;
// JSON data -> Template 填模板数据，并把填好的模板返回。
- (CardTemplate *)fillCardTemplate:(CardTemplate *)cardTemplate withJSON:(NSDictionary *)dict;
// JSON data -> TemplateItem 填模板item数据，并把填好的item返回。
- (CardTemplateItem *)fillCardTemplateItem:(CardTemplateItem *)CardTemplateItem withJSON:(NSDictionary *)dict;
@end

