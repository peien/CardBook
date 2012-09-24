//
//  KHHData+Processors.h
//  CardBook
//
//  Created by Sun Ming on 12-9-22.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHData.h"

@interface KHHData (Processors)
//- (NSArray *)processList:(NSArray *)list ofClass:(NSString *)className;
- (NSManagedObject *)processObject:(NSDictionary *)objDict ofClass:(NSString *)className withID:(NSNumber *)ID;// ID 不存在就不操作
@end
#pragma mark - Address
@interface KHHData (Processors_Address)
// 填地址数据。并把填好的地址返回。
- (Address *)fillAddress:(Address *)address withJSON:(NSDictionary *)json;
@end
#pragma mark - BankAccount
@interface KHHData (Processors_BankAccount)
// 填银行帐户数据。并把填好的银行帐户返回。
- (BankAccount *)fillBankAccount:(BankAccount *)bankAccount withJSON:(NSDictionary *)json;
@end
#pragma mark - Card
@interface KHHData (Processors_Card)
// card
// 返回各种Card数组
- (NSArray *)processMyCardList:(NSArray *)list;
- (NSArray *)processPrivateCardList:(NSArray *)list;
- (NSArray *)processReceivedCardList:(NSArray *)list;
- (NSArray *)processCardList:(NSArray *)list cardType:(KHHCardModelType)type;
// 返回各种Card对象
- (Card *)processCard:(NSDictionary *)aCard cardType:(KHHCardModelType)type;
// JSON data -> Card
- (Card *)fillCard:(Card *)card ofType:(KHHCardModelType)type withJSON:(NSDictionary *)dict;
@end
#pragma mark - Company
@interface KHHData (Processors_Company)
// company
// 返回Company数组
- (NSArray *)processCompanyList:(NSArray *)list;
// 返回Company对象
- (Company *)processCompany:(NSDictionary *)company;
@end
#pragma mark - Template
@interface KHHData (Processors_Template)
// template
// CardTemplate数组
- (NSArray *)processCardTemplateList:(NSArray *)list;
// 返回CardTemplate
- (CardTemplate *)processCardTemplate:(NSDictionary *)cardTemplate;
// JSON data -> Template 填模板数据，并把填好的模板返回。
- (CardTemplate *)fillCardTemplate:(CardTemplate *)cardTemplate withJSON:(NSDictionary *)dict;
// CardTemplateItem数组
- (NSArray *)processCardTemplateItemList:(NSArray *)list;
// 返回CardTemplateItem
- (CardTemplateItem *)processCardTemplateItem:(NSDictionary *)templateItem;
// JSON data -> TemplateItem 填模板item数据，并把填好的item返回。
- (CardTemplateItem *)fillCardTemplateItem:(CardTemplateItem *)CardTemplateItem withJSON:(NSDictionary *)dict;
@end
#pragma mark - Misc
@interface KHHData (Processors_Zoo)
//
- (void)processSyncTime:(NSString *)syncTime;
@end