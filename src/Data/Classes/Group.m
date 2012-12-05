#import "KHHClasses.h"
#import "KHHDataAPI.h"

@implementation Group
@end

@implementation Group (KHHTransformation)
+ (id)processIObject:(IGroup *)igroup{
    Group *grp = nil;
    if (igroup.id) { // ID无法解析就不操作
        // 按ID从数据库里查询, 无则新建。
        grp = [Group objectByID:igroup.id createIfNone:YES];
        // 填充数据
        grp.id = igroup.id;
        grp.name = igroup.name;
        NSNumber *parentID = [NSNumber numberFromObject:igroup.parentID
                                     zeroIfUnresolvable:YES];
        grp.parent = [Group objectByID:parentID createIfNone:YES];
    }
    return grp;
}
+ (void)processICardGroupMap:(ICardGroupMap *)icgm {
    if (icgm.cardID && icgm.groupID) {
        // 查名片
        Card *card   = [Card objectByID:icgm.cardID createIfNone:YES];
        // 查group
        Group *group = [Group objectByID:icgm.groupID createIfNone:YES];
        // 名片添加到group
        [group.cardsSet addObject:card];
    }
}
//删除本地所有分组
+(void)processDeleteAllLocalGroups {
    KHHData *dataCtrl = [KHHData sharedData];
    NSArray * array = [dataCtrl allTopLevelGroups];
    NSManagedObjectContext* context = [[KHHData sharedData] context];
    for (Group* group in array) {
        [context deleteObject:group];
    }
}
//删除本地所有分组下的card(其实分组要是删除过，该组下的名片其实已全空)
+(void)processDeleteAllCardGroupMaps {
    KHHData *dataCtrl = [KHHData sharedData];
    NSArray * array = [dataCtrl allTopLevelGroups];
    for (Group* group in array) {
        if (group && group.cards && group.cards.count > 0) {
           [group removeCards:group.cards];
        }
    }
}
@end
