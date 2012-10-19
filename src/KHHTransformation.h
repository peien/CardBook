//
//  KHHTransformation.h
//  CardBook
//
//  Created by Sun Ming on 12-10-18.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KHHTransformation <NSObject>
@optional
+ (void)processIObjectList:(NSArray *)list;
+ (void)processJSONList:(NSArray *)list;
+ (id)objectWithJSON:(NSDictionary *)jsonDict;
- (id)updateWithJSON:(NSDictionary *)jsonDict;
+ (id)objectWithIObject:(id)iObj;
- (id)updateWithIObject:(id)iObj;
@end
