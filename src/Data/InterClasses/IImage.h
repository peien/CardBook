//
//  IImage.h
//  CardBook
//
//  Created by Sun Ming on 12-10-9.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMObject.h"

@interface IImage : SMObject
@property (nonatomic, strong) NSNumber *id; //id
@property (nonatomic, strong) NSNumber *isDeleted; //isDelete
@property (nonatomic, strong) NSString *url; // fileUrl
@end

@interface IImage (KHHTransformation)
- (id)updateWithJSON:(NSDictionary *)json;
@end
