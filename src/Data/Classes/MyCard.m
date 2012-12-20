#import "KHHClasses.h"

@implementation MyCard
@end

@implementation MyCard (KHHTransformation)
+ (id)processIObject:(InterCard *)iCard {
    MyCard *card = nil;
    if (iCard.id) {
        // 按ID从数据库里查询，无则新建。
        MyCard *newCard = [MyCard objectByID:iCard.id createIfNone:YES];
        // 若已标记为删除则删除
        if (iCard.isDeleted) {
            [[self currentContext] deleteObject:newCard];
        } else {
            card = newCard;
            
            
            // 更新数据
            [card updateWithIObject:iCard];
        }
    }
    DLog(@"[II] card = %@", card);
    return card;
}
- (id)updateWithIObject:(InterCard *)iCard {
    DLog(@"[II] self = %@", self);
    // 更新公共部分
    [super updateWithIObject:iCard];
    // 更新MyCard部分
    self.modelType = @(KHHCardModelTypeMyCard);
    return self;
}
@end
