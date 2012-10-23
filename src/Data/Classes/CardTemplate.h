#import "_CardTemplate.h"
#import "KHHTransformation.h"

@interface CardTemplate : _CardTemplate {}
@end

@interface CardTemplate (Transformation) <KHHTransformation>
+ (id)processJSON:(NSDictionary *)jsonDict;
- (id)updateWithJSON:(NSDictionary *)jsonDict;
@end
