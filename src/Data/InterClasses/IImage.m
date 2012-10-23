//
//  IImage.m
//  CardBook
//
//  Created by Sun Ming on 12-10-9.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "IImage.h"
#import "NSNumber+SM.h"

@implementation IImage

@end

@implementation IImage (Transformation)

- (id)updateWithJSON:(NSDictionary *)json {
    self.id        = [NSNumber numberFromObject:json[JSONDataKeyID] zeroIfUnresolvable:NO]; //id
    self.isDeleted = [NSNumber numberFromObject:json[JSONDataKeyIsDelete] zeroIfUnresolvable:YES]; //isDelete
    self.url       = json[JSONDataKeyFileURL]; // fileUrl
    return self;
}

@end
