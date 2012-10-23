#import "_CardTemplateItem.h"
#import "KHHTransformation.h"

@interface CardTemplateItem : _CardTemplateItem {}
@end

@interface CardTemplateItem (Transformation) <KHHTransformation>
+ (id)processJSON:(NSDictionary *)jsonDict;
- (id)updateWithJSON:(NSDictionary *)jsonDict;
@end
