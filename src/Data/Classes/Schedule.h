#import "_Schedule.h"
#import "KHHTransformation.h"
#import "ISchedule.h"

@interface Schedule : _Schedule {}
@end

@interface Schedule (KHHTransformation) <KHHTransformation>
+ (id)processIObject:(ISchedule *)iObj;
- (id)updateWithIObject:(ISchedule *)iObj;
@end
