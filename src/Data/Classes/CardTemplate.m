#import "KHHClasses.h"

@implementation CardTemplate
@end

@implementation CardTemplate (KHHTransformation)
+ (id)processJSON:(NSDictionary *)json {
    NSNumber *ID = [NSNumber numberFromObject:json[JSONDataKeyID]
                           zeroIfUnresolvable:YES];
    // 根据ID查询，无则新建。
    CardTemplate *item = [self objectByID:ID createIfNone:YES];
    // 更新内容
    [item updateWithJSON:json];
    return item;
}
- (id)updateWithJSON:(NSDictionary *)json {
    if (json) {
        // id
        self.id      = [NSNumber numberFromObject:json[JSONDataKeyID]
                               zeroIfUnresolvable:NO];
        // version
        self.version = [NSNumber numberFromObject:json[JSONDataKeyVersion]
                               zeroIfUnresolvable:NO];
        // userId => ownerID
        self.ownerID = [NSNumber numberFromObject:json[JSONDataKeyUserId]
                               zeroIfUnresolvable:NO];
        
        // templateType => domainType
        NSString *dtString = [[NSString stringFromObject:json[JSONDataKeyTemplateType]]
                              lowercaseString];
        if ([dtString isEqualToString:@"public"]) {
            self.domainType = [NSNumber numberWithInteger:KHHTemplateDomainTypePublic];
        } else if([dtString isEqualToString:@"pay"]){
            self.domainType = [NSNumber numberWithInteger:KHHTemplateDomainTypePay];
        }else{
            self.domainType = [NSNumber numberWithInteger:KHHTemplateDomainTypePrivate];
        }
        
        // description => descriptionInfo
        self.descriptionInfo = [NSString stringFromObject:json[JSONDataKeyDescription]];
        
        // templateStyle => style
        self.style = [NSString stringFromObject:json[JSONDataKeyTemplateStyle]];
        
        // imageUrl => bgImage->url {
        NSLog(@"%@",json[JSONDataKeyImageUrl]);
        if ([json[JSONDataKeyImageUrl] isKindOfClass:[NSString class]]&&[json[JSONDataKeyImageUrl] length]>0) {
            self.bgImage = [Image objectByKey:@"url"
                                        value:json[JSONDataKeyImageUrl]
                                 createIfNone:YES];
        }
       
        
        // }
        
        // item列表 {
        [self.itemsSet removeAllObjects];
        [CardTemplateItem processJSONList:json[JSONDataKeyDetails]];
        // }
        
        if (self.items.count) {
            self.isFullValue = YES;
        }
    }
    
    
    return self;
}
@end
