#import "KHHClasses.h"

@implementation ReceivedCard
@end

@implementation ReceivedCard (KHHTransformation)
+ (id)processIObject:(InterCard *)iCard {
    
    DLog(@"########iCard.CardID = %@, isdelete = %d",iCard.id,iCard.isDeleted);
    ReceivedCard *card = nil;
    if (iCard.id) {
        // 按ID从数据库里查询，无则新建。
        ReceivedCard *newCard = [ReceivedCard objectByID:iCard.id createIfNone:YES];
        // 若已标记为删除则删除
        if (iCard.isDeleted  || (!iCard.userID || iCard.userID <= 0)) {
            DLog(@"isdeleted = %d        userID= %@",iCard.isDeleted,iCard.userID);
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
    // 更新ReceivedCard部分
    self.modelType = @(KHHCardModelTypeReceivedCard);
    self.isRead    = iCard.isRead;
    self.memo      = iCard.memo;
    return self;
}
@end