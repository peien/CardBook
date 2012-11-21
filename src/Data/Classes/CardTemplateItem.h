#import "_CardTemplateItem.h"
#import "KHHTransformation.h"

@interface CardTemplateItem : _CardTemplateItem {}
@end

@interface CardTemplateItem (KHHTransformation) <KHHTransformation>
+ (id)processJSON:(NSDictionary *)jsonDict;
- (id)updateWithJSON:(NSDictionary *)jsonDict;
@end
