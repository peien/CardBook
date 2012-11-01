#import "_KHHMessage.h"
#import "NSManagedObject+KHH.h"
#import "InMessage.h"

@interface KHHMessage : _KHHMessage {}
// Custom logic goes here.
@end

@interface KHHMessage (KHHTransformation)
+ (id)processIObject:(InMessage *)iObj;
@end