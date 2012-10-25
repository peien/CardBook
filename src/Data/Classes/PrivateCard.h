#import "_PrivateCard.h"
#import "InterCard.h"
#import "KHHTransformation.h"

@interface PrivateCard : _PrivateCard {}
@end

@interface PrivateCard (KHHTransformation) <KHHTransformation>
+ (id)processIObject:(InterCard *)iObj;
- (id)updateWithIObject:(InterCard *)iObj;
@end
