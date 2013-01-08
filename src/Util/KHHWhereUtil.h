//
//  KHHWhereUtil.h
//  CardBook
//
//  Created by CJK on 13-1-7.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h> 

@interface KHHWhereUtil : NSObject<CLLocationManagerDelegate>

+ (KHHWhereUtil *)sharedInstance;

- (void)getWhere:(void(^)(NSString *where)) done fail:(void(^)()) fail;

- (UIImage *)imgForIndex:(int)index;
@end
