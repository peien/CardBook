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

@implementation IImage (KHHTransformation)

- (id)updateWithJSON:(NSDictionary *)json {
    self.id        = [NSNumber numberFromObject:json[JSONDataKeyID]
                             zeroIfUnresolvable:YES]; //id
    self.isDeleted = [NSNumber numberFromObject:json[JSONDataKeyIsDelete]
                             zeroIfUnresolvable:YES]; //isDelete
    NSString *url = json[JSONDataKeyLinkURL];
    if (0 == url.length) {
        url = json[JSONDataKeyFileURL];
    }
    self.url       = url; // fileUrl
    return self;
}

@end
