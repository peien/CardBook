#import "_SyncMark.h"

@interface SyncMark : _SyncMark {}
@end

@interface SyncMark (KHH)
// 根据key查数据库，无则新建。
// 注意key为@""或nil，则返回nil；
+ (SyncMark *)syncMarkByKey:(NSString *)key;
+ (void)UpdateKey:(NSString *)key value:(NSString *)value;
@end
