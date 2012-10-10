//
//  ICheckIn.m
//  CardBook
//
//  Created by Sun Ming on 12-10-10.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "ICheckIn.h"

@implementation ICheckIn

@end

@implementation ICheckIn (Methods)
- (id)initWithCard:(Card *)card {
    self = [super init];
    if (self) {
        _cardID = card.id;
    }
    return self;
}
@end
