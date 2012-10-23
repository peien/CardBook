#import "_PrivateCard.h"
#import "InterCard.h"
#import "KHHTransformation.h"

@interface PrivateCard : _PrivateCard {}
@end

@interface PrivateCard (Transformation) <KHHTransformation>
+ (id)processIObject:(InterCard *)iObj;
- (id)updateWithIObject:(InterCard *)iObj;
@end
