#import "KHHClasses.h"

@implementation SyncMark
@end

@implementation SyncMark (KHH)
// 根据key查数据库，无则新建。
// 注意key为@""或nil，则返回nil；
+ (SyncMark *)syncMarkByKey:(NSString *)key {
    return (SyncMark *)[SyncMark objectByKey:@"key" value:key createIfNone:YES];
}
+ (void)UpdateKey:(NSString *)key value:(NSString *)value {
    if (key.length && value.length) {
        SyncMark *sm = [self syncMarkByKey:key];
        sm.value = value;
    }
}

@end
