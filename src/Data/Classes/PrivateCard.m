#import "PrivateCard.h"
#import "InterCard.h"
#import "KHHLog.h"
#import "NSManagedObject+KHH.h"

@implementation PrivateCard
@end

@implementation PrivateCard (Transformation)
+ (id)objectWithIObject:(InterCard *)iCard {
    PrivateCard *card = nil;
    if (iCard.id) {
        // 按ID从数据库里查询，无则新建。
        PrivateCard *newCard = [PrivateCard objectByID:iCard.id createIfNone:YES];
        // 若已标记为删除则删除
        if (iCard.isDeleted.integerValue) {
            [[self currentContext] deleteObject:newCard];
        } else {
            card = newCard;
        }
        // 更新数据
        [card updateWithIObject:iCard];
    }
    DLog(@"[II] card = %@", card);
    return card;
}
- (id)updateWithIObject:(InterCard *)iCard {
    DLog(@"[II] self = %@", self);
    // 更新公共部分
    [super updateWithIObject:iCard];
    // 更新PrivateCard部分
    self.modelType = @(KHHCardModelTypePrivateCard);
    return self;
}
@end
