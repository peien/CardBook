#import "_Group.h"
#import "KHHTransformation.h"
#import "NSManagedObject+KHH.h"
#import "IGroup.h"
#import "ICardGroupMap.h"

@interface Group : _Group {}
// Custom logic goes here.
@end
@interface Group (Transformation) <KHHTransformation>
+ (id)processIObject:(IGroup *)igroup;
+ (void)processICardGroupMap:(ICardGroupMap *)icgm;
@end