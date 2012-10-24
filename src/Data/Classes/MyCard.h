#import "_MyCard.h"
#import "InterCard.h"
#import "KHHTransformation.h"

@interface MyCard : _MyCard {}
@end

@interface MyCard (Transformation) <KHHTransformation>
+ (id)processIObject:(InterCard *)iObj;
- (id)updateWithIObject:(InterCard *)iObj;
@end
