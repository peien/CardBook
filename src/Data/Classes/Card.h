#import "_Card.h"
#import "KHHTypes.h"
#import "InterCard.h"
#import "KHHTransformation.h"

@interface Card : _Card {}
// 根据ID和type查询。
// 无则新建。
+ (id)cardByID:(NSNumber *)ID modelType:(KHHCardModelType)type;
@end

@interface Card (Type_And_Name)
- (NSString *)nameForServer;
+ (NSString *)ServerNameForCardModelType:(KHHCardModelType)type;
+ (KHHCardModelType)CardModelTypeForServerName:(NSString *)name;
+ (NSString *)EntityNameForCardModelType:(KHHCardModelType)cardType;//出错返回nil。
@end

@interface Card (Transformation) <KHHTransformation>
+ (id)objectWithIObject:(InterCard *)iObj;
- (id)updateWithIObject:(InterCard *)iObj;
@end
