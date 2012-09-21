//
//  KHHAddressBook.h
//  CardBook
//
//  Created by 王国辉 on 12-9-19.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "_Card.h"
@interface KHHAddressBook : NSObject
+ (BOOL)saveToCantactWithCard:(_Card *)card;
@end
