//
//  KHHWebView.h
//  CardBook
//
//  Created by 王定方 on 12-11-30.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "KHHTypes.h"

@interface KHHWebView : SuperViewController
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property(strong, nonatomic) NSString *myRequestUrl;
@property(strong, nonatomic) KHHDefaultBlock callback;
//设置title、url、如果有右键就设置邮件按钮文字、及callback，没有都传空
-(void) initUrl:(NSString *) url title:(NSString *) title rightBarName:(NSString*) barName rightBarBlock:(KHHDefaultBlock) callback;
@end
