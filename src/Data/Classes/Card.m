#import "Card.h"
#import "KHHClasses.h"

@implementation Card

// Custom logic goes here.

@end

NSString *NameOfCardModelType(KHHCardModelType type) {
    NSString *result = nil;
    switch (type) {
        case KHHCardModelTypeMyCard:
            result = @"private";
            break;
        case KHHCardModelTypePrivateCard:
            result = @"me";
            break;
        case KHHCardModelTypeReceivedCard:
            result = @"linkman";
            break;
    }
    return result;
}

KHHCardModelType TypeOfCardModelName(NSString *name) {
    return [name isEqualToString:@"linkman"]? KHHCardModelTypeReceivedCard
    :([name isEqualToString:@"me"]? KHHCardModelTypePrivateCard
      :KHHCardModelTypeMyCard);
}
