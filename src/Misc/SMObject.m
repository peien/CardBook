//
//  SMObject.m
//  CardBook
//
//  Created by Sun Ming on 12-10-10.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "SMObject.h"
#import "objc/runtime.h"
#import "NSString+SM.h"

@implementation SMObject
- (NSString *)description {
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:count];
    for (unsigned int i = 0; i < count; i++) {
        NSString *name = [NSString stringWithUTF8String:property_getName(properties[i])];
        NSString *value = [NSString stringFromObject:[self valueForKey:name]];
        dictionary[name] = value;
    }
    free(properties);
    return [dictionary description];
}
@end
