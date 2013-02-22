//
//  KHHActionSheet.m
//  CardBook
//
//  Created by CJK on 13-1-29.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHActionSheet.h"

@implementation KHHActionSheet

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (NSMutableDictionary *)dic
{
    if (!_dic) {
        _dic = [[NSMutableDictionary alloc]initWithCapacity:3];
    }
    return _dic;
}



@end
