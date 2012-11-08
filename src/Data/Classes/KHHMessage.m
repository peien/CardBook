#import "KHHMessage.h"
#import "Image.h"

@implementation KHHMessage
@end

@implementation KHHMessage (KHHTransformation)

+ (id)processIObject:(InMessage *)iObj {
    KHHMessage *message = nil;
    if (iObj.id) {
        // 按ID从数据库里查询，无则新建。
        KHHMessage *newMSG = [KHHMessage objectByID:iObj.id
                                       createIfNone:YES];
        // 若已标记为删除则删除
        if (iObj.isDeleted) {
            [[self currentContext] deleteObject:newMSG];
        } else {
            message = newMSG;
        }
        // 更新数据
//        [message updateWithIObject:iObj];
        message.id = iObj.id;
        message.company = iObj.company;
        message.time = iObj.time;
        message.subject = iObj.subject;
        message.content = iObj.content;
        message.image = [Image objectByKey:@"url" value:iObj.imgURL createIfNone:YES];
    }
    DLog(@"[II] message = %@", message);
    return message;
}

@end