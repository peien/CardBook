#import "KHHClasses.h"

@implementation Address
@end

@implementation Address (Transformation)

- (id)updateWithIObject:(IAddress *)iObj {
    if (iObj) {
        self.city     = iObj.city;
        self.country  = iObj.country;
        self.district = iObj.district;
        self.other    = iObj.other;
        self.province = iObj.province;
        self.street   = iObj.street;
        self.zip      = iObj.zip;
    }
    return self;
}

@end
