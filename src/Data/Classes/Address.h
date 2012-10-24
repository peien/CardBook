#import "_Address.h"
#import "IAddress.h"
#import "KHHTransformation.h"

@interface Address : _Address {}
@end

@interface Address (KHHTransformation) <KHHTransformation>
- (id)updateWithIObject:(IAddress *)iObj;
@end