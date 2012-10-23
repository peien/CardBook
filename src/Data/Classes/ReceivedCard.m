#import "KHHClasses.h"

@implementation ReceivedCard
@end

@implementation ReceivedCard (Transformation)
+ (id)processIObject:(InterCard *)iCard {
    ReceivedCard *card = nil;
    if (iCard.id) {
        // 按ID从数据库里查询，无则新建。
        ReceivedCard *newCard = [ReceivedCard objectByID:iCard.id createIfNone:YES];
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
    // 更新ReceivedCard部分
    self.modelType = @(KHHCardModelTypeReceivedCard);
    self.isRead    = iCard.isRead;
    self.memo      = iCard.memo;
    return self;
}
@end