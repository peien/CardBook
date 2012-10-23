#import "KHHClasses.h"

@implementation CardTemplate
@end

@implementation CardTemplate (Transformation)
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
                                     defaultValue:1 defaultIfUnresolvable:YES];
        // userId => ownerID
        self.ownerID = [NSNumber numberFromObject:json[JSONDataKeyUserId]
                               zeroIfUnresolvable:YES];
        
        // templateType => domainType
        NSString *dtString = [[NSString stringFromObject:json[JSONDataKeyTemplateType]] lowercaseString];
        if ([dtString isEqualToString:@"public"]) {
            self.domainType = [NSNumber numberWithInteger:KHHTemplateDomainTypePublic];
        } else {
            self.domainType = [NSNumber numberWithInteger:KHHTemplateDomainTypePrivate];
        }
        
        // description => descriptionInfo
        self.descriptionInfo = [NSString stringFromObject:json[JSONDataKeyDescription]];
        
        // templateStyle => style
        self.style = [NSString stringFromObject:json[JSONDataKeyTemplateStyle]];
        
        // imageUrl => bgImage->url {
        self.bgImage = [Image objectByKey:@"url"
                                        value:json[JSONDataKeyImageUrl]
                                 createIfNone:YES];
        // }
        
        // item列表 {
        [self.itemsSet removeAllObjects];
        [CardTemplateItem processJSONList:json[JSONDataKeyDetails]];
        // }
    }
    
    DLog(@"[II] tmpl = %@", self);
    return self;
}
@end
