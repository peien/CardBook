//
//  ParamForEditecard.h
//  CardBook
//
//  Created by CJK on 13-1-11.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParamForEditecard : NSObject

@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *placeholder;
@property(nonatomic,strong) NSString *value;
@property(nonatomic,assign) UIKeyboardType boardType;
@property(nonatomic,assign) int tag;
@property(nonatomic,assign) UIReturnKeyType returnKeyType;
@property(nonatomic,assign) UITableViewCellEditingStyle editingStyle;
//to picker
@property(nonatomic,strong) NSMutableArray *toPicker;
@property(nonatomic,assign) Boolean forPickerToDel;
- (id)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder;

@end
