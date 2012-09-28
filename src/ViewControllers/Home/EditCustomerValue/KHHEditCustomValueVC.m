//
//  KHHEditCustomValueVC.m
//  CardBook
//
//  Created by 王国辉 on 12-8-24.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "KHHEditCustomValueVC.h"
#import "KHHCustomEvaluaView.h"

@interface KHHEditCustomValueVC ()<KHHCustomEvaluaViewDelegate>

@end

@implementation KHHEditCustomValueVC
@synthesize importFlag = _importFlag;
@synthesize relationEx = _relationEx;
@synthesize customValue = _customValue;
@synthesize tf = _tf;
@synthesize cusView = _cusView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    }
    return self;
}
- (void)rightBarButtonClick:(id)sender
{
    [_tf resignFirstResponder];
    
    //保存，如果没有修改重要标记，直接保存importFlag
    if (!_tf.text) {
        DLog(@"直接保存重要标记");
    }else{
        _importFlag = _tf.text;
    }
    //保存成功，和服务器做一次同步
    //保存过慢，提示用户
    //保存失败，停留在本页面
        
    
  
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    KHHCustomEvaluaView *view = [[[NSBundle mainBundle] loadNibNamed:@"KHHCustomEvaluaView" owner:self options:nil] objectAtIndex:0];
    view.importFlag = _cusView.importFlag;
    view.relationEx = _cusView.relationEx;
    view.customValue = _cusView.customValue;
    view.delegate = self;
    view.isFieldValueEdit = YES;
    [self.view addSubview:view];
    //获取数据
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _importFlag = nil;
    _cusView = nil;

}
- (void)handleTextfieldValue:(UITextField *)textf
{
    _tf = textf;
     DLog(@"_tf====%@",_tf.text);

}
- (void)handleStarNum:(DLStarRatingControl *)control startNum:(CGFloat)num
{
    if (control.tag == 7788) {
        _relationEx = num;
    }else
    {
        _customValue = num;
    }

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
