#import "_CustomerEvaluation.h"
#import "ICustomerEvaluation.h"

@interface CustomerEvaluation : _CustomerEvaluation {}
@end

@interface CustomerEvaluation (KHHTransformation)
- (id)updateWithIObject:(ICustomerEvaluation *)icv;
@end