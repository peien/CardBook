#import "_MyCard.h"
#import "InterCard.h"
#import "KHHTransformation.h"

@interface MyCard : _MyCard {}
@end

@interface MyCard (Transformation) <KHHTransformation>
+ (id)objectWithIObject:(InterCard *)iObj;
- (id)updateWithIObject:(InterCard *)iObj;
@end
