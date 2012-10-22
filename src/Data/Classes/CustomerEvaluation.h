#import "_CustomerEvaluation.h"
#import "ICustomerEvaluation.h"

@interface CustomerEvaluation : _CustomerEvaluation {}
@end

@interface CustomerEvaluation (Transformation)
- (id)updateWithIObject:(ICustomerEvaluation *)icv;
@end