#import "_Image.h"
#import "IImage.h"
#import "KHHTransformation.h"

@interface Image : _Image {}
@end

@interface Image (Transformation) <KHHTransformation>
+ (id)processIObject:(IImage *)iObj;
- (id)updateWithIObject:(IImage *)iObj;
@end
