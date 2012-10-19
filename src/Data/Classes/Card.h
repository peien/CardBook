#import "_Card.h"
#import "KHHTypes.h"
#import "InterCard.h"
#import "KHHTransformation.h"

@interface Card : _Card {}
@end

@interface Card (Type_And_Name)
+ (NSString *)ServerNameForCardModelType:(KHHCardModelType)type;
+ (KHHCardModelType)CardModelTypeForServerName:(NSString *)name;

// cardType -> entityName: 出错返回nil。
+ (NSString *)EntityNameForCardModelType:(KHHCardModelType)cardType;
@end

@interface Card (Transformation) <KHHTransformation>
+ (id)objectWithIObject:(InterCard *)iObj;
- (id)updateWithIObject:(InterCard *)iObj;
@end
