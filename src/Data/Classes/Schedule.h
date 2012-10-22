#import "_Schedule.h"
#import "KHHTransformation.h"
#import "ISchedule.h"

@interface Schedule : _Schedule {}
@end

@interface Schedule (Transformation) <KHHTransformation>
+ (id)objectWithIObject:(ISchedule *)iObj;
- (id)updateWithIObject:(ISchedule *)iObj;
@end
