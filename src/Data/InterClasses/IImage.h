//
//  IImage.h
//  CardBook
//
//  Created by Sun Ming on 12-10-9.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IImage : NSObject
@property (nonatomic, strong) NSNumber *id; //id
@property (nonatomic, strong) NSNumber *isDeleted; //isDelete
@property (nonatomic, strong) NSString *url; // fileUrl
@end
