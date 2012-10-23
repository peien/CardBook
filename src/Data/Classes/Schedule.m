#import "Schedule.h"
#import "NSObject+SM.h"
#import "NSManagedObject+KHH.h"
#import "Address.h"
#import "InterCard.h"
#import "Card.h"
#import "Image.h"
#import "IImage.h"
#import "KHHLog.h"

@implementation Schedule
@end

@implementation Schedule (Transformation)
+ (id)objectWithIObject:(ISchedule *)iObj {
    Schedule *schdl = nil;
    if (iObj.id) {
        // 按ID从数据库里查询，无则新建。
        Schedule *newSchdl = [Schedule objectByID:iObj.id createIfNone:YES];
        // 若已标记为删除则删除
        if (iObj.isDeleted.integerValue) {
            [[self currentContext] deleteObject:newSchdl];
        } else {
            schdl = newSchdl;
        }
        // 更新数据
        [schdl updateWithIObject:iObj];
    }
    DLog(@"[II] schdl = %@", schdl);
    return schdl;
}
- (id)updateWithIObject:(ISchedule *)iObj {
    if (iObj) {
        self.id      = iObj.id;
        self.version = iObj.version;
        self.isFinished = iObj.isFinished;
        
        self.customer = iObj.customer;
        self.companions = iObj.companion;
        self.content = iObj.content;
        self.plannedDate = DateFromKHHDateString(iObj.plannedDate);        
        self.remind = iObj.isRemind;
        self.minutesToRemind = iObj.minutesToRemind;
        
        //targetCardList, InterCard数组
        [self.targetsSet removeAllObjects];
        for (InterCard *ic in iObj.targetCardList) {
            Card *card = [Card cardByID:ic.id modelType:ic.modelType];
            [self.targetsSet addObject:card];
        }
        //imageList, IImage数组
        [self.imagesSet removeAllObjects];
        for (IImage *ii in iObj.imageList) {
            Image *img = [Image objectWithIObject:ii];
            if (img) {
                [self.imagesSet addObject:img];
            }
        }
        // 地址信息
        if (nil == self.address) { // 无则新建
            self.address = [Address newObject];
        }
        [self.address updateWithIObject:iObj.address];
    }
    return self;
}
@end

