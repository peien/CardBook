//
//  InMessage.m
//  CardBook
//
//  Created by Sun Ming on 12-11-1.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "InMessage.h"
#import "NSNumber+SM.h"
#import "NSString+SM.h"

@implementation InMessage

@end

@implementation InMessage (KHHTransformation)
- (id)updateWithJSON:(NSDictionary *)json {
    self.id        = [NSNumber numberFromObject:json[JSONDataKeyID]
                             zeroIfUnresolvable:YES];
    self.isDeleted = [NSNumber numberFromObject:json[JSONDataKeyIsDelete]
                             zeroIfUnresolvable:YES].boolValue;
    self.time      = [NSString stringByFilterNilFromString:json[@"gmtSendTime"]];
    self.company   = [NSString stringByFilterNilFromString:json[@"companyName"]];
    self.subject   = [NSString stringByFilterNilFromString:json[@"col1"]];
    self.content   = [NSString stringByFilterNilFromString:json[@"message"]];
    self.imgURL    = [NSString stringByFilterNilFromString:json[@"imgPath"]];
    return self;
}
@end