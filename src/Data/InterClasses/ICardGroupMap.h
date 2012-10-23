//
//  ICardGroupMap.h
//  CardBook
//
//  Created by Sun Ming on 12-10-15.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "SMObject.h"
#import "KHHTypes.h"

@interface ICardGroupMap : SMObject
@property (nonatomic, strong) NSNumber *cardID;
@property (nonatomic) KHHCardModelType cardModelType;
@property (nonatomic, strong) NSNumber *groupID;
@end
