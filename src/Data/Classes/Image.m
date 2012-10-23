#import "KHHClasses.h"

@implementation Image
@end

@implementation Image (Transformation)
+ (id)objectWithIObject:(IImage *)iObj {
    Image *img = nil;
    if (iObj.id) {
        // 按ID从数据库里查询，无则新建。
        Image *newImg = [Image objectByID:iObj.id createIfNone:YES];
        // 若已标记为删除则删除
        if (iObj.isDeleted.integerValue) {
            [[self currentContext] deleteObject:newImg];
        } else {
            img = newImg;
        }
        // 更新数据
        [img updateWithIObject:iObj];
    }
    DLog(@"[II] img = %@", img);
    return img;
}
- (id)updateWithIObject:(IImage *)iObj {
    if (iObj) {
        self.id = iObj.id;
        self.url = iObj.url;
    }
    return self;
}

@end
