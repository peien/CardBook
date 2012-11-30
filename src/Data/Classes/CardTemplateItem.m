#import "KHHClasses.h"

@implementation CardTemplateItem
@end

@implementation CardTemplateItem (KHHTransformation)
+ (id)processJSON:(NSDictionary *)json {
    NSNumber *ID = [NSNumber numberFromObject:json[JSONDataKeyID]
                           zeroIfUnresolvable:YES];
    // 根据ID查询，无则新建。
    CardTemplateItem *item = [CardTemplateItem objectByID:ID createIfNone:YES];
    // 更新内容
    [item updateWithJSON:json];
    return item;
}
- (id)updateWithJSON:(NSDictionary *)json {
    if (json) {
        //id,
        self.id    = [NSNumber numberFromObject:json[JSONDataKeyID]
                          zeroIfUnresolvable:NO];
        //item => name
        self.name  = [NSString stringFromObject:json[JSONDataKeyItem]];
        //style
        self.style = [NSString stringFromObject:json[JSONDataKeyStyle]];
        
        // style to attributes "top: 32 px; left: 25 px; font-size: 22 px; color: #0; fontWeight: normal"
        NSDictionary *styleAttrDict = @{
        @"left":@"originX", @"top":@"originY", @"width":@"rectWidth", @"height":@"rectHeight",
        @"color":@"fontColor", @"font-size":@"fontSize", @"fontWeight":@"fontWeight",
        };
        NSArray *styleAttrList = [self.style componentsSeparatedByString:KHH_SEMICOLON];
        for (NSString *styleAttr in styleAttrList) {
            NSArray *keyValuePair = [styleAttr componentsSeparatedByString:@":"];
            if (keyValuePair.count != 2) {
                continue;
            }
            NSString *theKey = [(NSString *)keyValuePair[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *theValue = [(NSString *)keyValuePair[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *attrKey = styleAttrDict[theKey];
            if (0 == attrKey.length) {
                continue;
            }
            if ([theKey isEqualToString:@"color"] || [theKey isEqualToString:@"fontWeight"]) { // 这两个属性直接保存为string
                [self setValue:theValue forKey:attrKey];
            } else { // 其他属性是number
                [self setValue:[NSNumber numberFromString:theValue] forKey:attrKey];
            }
        }
        
        //templateId => template
        NSNumber *tmplID   = [NSNumber numberFromObject:json[JSONDataKeyTemplateId]
                                   zeroIfUnresolvable:NO];
        self.template = [CardTemplate objectByID:tmplID createIfNone:YES];
    }
    
    DLog(@"[II] item = %@", self);
    return self;
}
@end
