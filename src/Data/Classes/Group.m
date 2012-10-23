#import "KHHClasses.h"

@implementation Group
@end

@implementation Group (Transformation)
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
@end
