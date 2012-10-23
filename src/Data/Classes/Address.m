#import "KHHClasses.h"

@implementation Address
@end

@implementation Address (Transformation)

- (id)updateWithIObject:(IAddress *)iObj {
    if (iObj) {
        if (iObj.city.length)
            self.city     = iObj.city;
        if (iObj.country.length)
            self.country  = iObj.country;
        if (iObj.district.length)
            self.district = iObj.district;
        if (iObj.other.length)
            self.other    = iObj.other;
        if (iObj.province.length)
            self.province = iObj.province;
        if (iObj.street.length)
            self.street   = iObj.street;
        if (iObj.zip.length)
            self.zip      = iObj.zip;
    }
    return self;
}

@end
