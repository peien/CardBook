#import "KHHClasses.h"

@implementation CustomerEvaluation
@end

@implementation CustomerEvaluation (KHHTransformation)

- (id)updateWithIObject:(ICustomerEvaluation *)icv {
    self.id               = icv.id;
    self.version          = icv.version;
    self.value            = icv.value;
    self.degree           = icv.degree;
    self.firstMeetAddress = icv.firstMeetAddress;
    self.firstMeetDate    = icv.firstMeetDate;
    self.remarks          = icv.remarks;
    Card *aCard;
    switch (icv.customerCardModelType) {
        case KHHCardModelTypePrivateCard:
            aCard = [PrivateCard objectByID:icv.customerCardID createIfNone:NO];
            break;
        case KHHCardModelTypeReceivedCard:
            aCard = [ReceivedCard objectByID:icv.customerCardID createIfNone:NO];
            break;
        default:
            break;
    }
    
    if (aCard) {
        self.customerCard     = aCard;
    }
    return self;
}

@end