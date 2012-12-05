#import "_Group.h"
#import "KHHTransformation.h"
#import "NSManagedObject+KHH.h"
#import "IGroup.h"
#import "ICardGroupMap.h"

@interface Group : _Group {}
// Custom logic goes here.
@end
@interface Group (KHHTransformation) <KHHTransformation>
+ (id)processIObject:(IGroup *)igroup;
+ (void)processICardGroupMap:(ICardGroupMap *)icgm;
//删除本地所有分组
+(void)processDeleteAllLocalGroups;
//删除本地所有分组下的card
+(void)processDeleteAllCardGroupMaps;
@end