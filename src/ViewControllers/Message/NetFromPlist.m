//
//  NetFromPlist.m
//  CardBook
//
//  Created by CJK on 12-12-27.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "NetFromPlist.h"

@implementation NetFromPlist

- (id)init
{
    self = [super init];
    if (self) {
        _dic = [self fromPlist];
    }
    return self;
}

#ifdef TEST
- (NSURL *)currentUrl{    
    NSString *trPro =[self strForUrl:[_dic objectForKey:@"base1Test"] restStr:[_dic objectForKey:@"base2Test"]];
    return  [NSURL URLWithString: trPro];
}
#endif

#ifdef HAIBO
- (NSURL *)currentUrl{
    NSString *trPro =[self strForUrl:[_dic objectForKey:@"base1Haibo"] restStr:[_dic objectForKey:@"base2Test"]];
    return  [NSURL URLWithString: trPro];
}
#endif

#ifdef OFFIC
- (NSURL *)currentUrl{
    NSString *trPro =[self strForUrl:[_dic objectForKey:@"base1Official"] restStr:[_dic objectForKey:@"base2Official"]];
    return  [NSURL URLWithString: trPro];
}
#endif

- (NSString *)strForUrl:(NSString *)ipStr restStr:(NSString *)restStr{
    
    return [NSString stringWithFormat:@"http://%@/%@/",ipStr,restStr];
}


- (NSDictionary *)fromPlist{
    NSString *filePath   = [[NSBundle mainBundle] pathForResource:@"Net" ofType:@"plist"];
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    return params;
}

@end
