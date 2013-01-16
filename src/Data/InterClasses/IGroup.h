//
//  IGroup.h
//  CardBook
//
//  Created by Sun Ming on 12-10-15.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "SMObject.h"

@interface IGroup : SMObject
// 内部数据
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *parentID;
@property (nonatomic, strong) NSNumber *cardID;
@end
