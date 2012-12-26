//
//  KHHKeyBoardManagerUtil.h
//  CardBook
//
//  Created by 王定方 on 12-12-24.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHHKeyBoardManagerUtil : NSObject
+(void) adjustPanelsWithKeybord:(UIView *) rootView textFieldRect:(CGRect) frame;
+(void) hideKeyboard:(UIView *) rootView;
+(void) hideKeyboard:(CGPoint) orgine rootView:(UIView *) rootView;
@end
