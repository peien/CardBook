#import "KHHClasses.h"

@implementation Image
@end

@implementation Image (KHHTransformation)
+ (id)processIObject:(IImage *)ii {
    Image *img = nil;
    if (ii.url.length) {
        Image *newImg;
        if (ii.id.integerValue) {
            // 按ID从数据库里查询，无则新建。
            newImg = [Image objectByID:ii.id createIfNone:YES];
        } else {
            // id为0，按url查，无则新建。
            newImg = [Image objectByKey:@"url" value:ii.url createIfNone:YES];
        }
        
        // 若已标记为删除则删除
        if (ii.isDeleted.integerValue) {
            [[self currentContext] deleteObject:newImg];
        } else {
            img = newImg;
        }
        // 更新数据
        [img updateWithIObject:ii];
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
