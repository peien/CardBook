#import "_CustomerEvaluation.h"
#import "ICustomerEvaluation.h"

@interface CustomerEvaluation : _CustomerEvaluation {}
@end

@interface CustomerEvaluation (Transformation)
- (id)updateWithICustomerEvaluation:(ICustomerEvaluation *)icv;
@end