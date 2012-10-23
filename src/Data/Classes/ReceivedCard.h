#import "_ReceivedCard.h"
#import "InterCard.h"
#import "KHHTransformation.h"

@interface ReceivedCard : _ReceivedCard {}
@end

@interface ReceivedCard (Transformation) <KHHTransformation>
+ (id)processIObject:(InterCard *)iObj;
- (id)updateWithIObject:(InterCard *)iObj;
@end
