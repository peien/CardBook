//
//  InMessage.h
//  CardBook
//
//  Created by Sun Ming on 12-11-1.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "SMObject.h"

@interface InMessage : SMObject
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic) BOOL isDeleted;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *imgURL;
@end

@interface InMessage (KHHTransformation)
- (id)updateWithJSON:(NSDictionary *)json;
@end