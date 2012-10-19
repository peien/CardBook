//
//  KHHEditCustomValueVC.m
//  CardBook
//
//  Created by 王国辉 on 12-8-24.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "KHHEditCustomValueVC.h"
#import "KHHCustomEvaluaView.h"
#import "KHHClasses.h"
#import "MBProgressHUD.h"

@interface KHHEditCustomValueVC ()<KHHCustomEvaluaViewDelegate>
@property (strong, nonatomic) ICustomerEvaluation *icustomerEva;

@end

@implementation KHHEditCustomValueVC
@synthesize importFlag = _importFlag;
@synthesize relationEx = _relationEx;
@synthesize customValue = _customValue;
@synthesize tf = _tf;
@synthesize cusView = _cusView;
@synthesize card;
@synthesize icustomerEva;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.rightBtn setTitle:@"保存" forState:UIControlStateNormal];
        self.icustomerEva = [[ICustomerEvaluation alloc] init];
    }
    return self;
}
- (void)rightBarButtonClick:(id)sender
{
    [_tf resignFirstResponder];
    //保存，如果没有修改重要标记，直接保存importFlag
    [self saveCustomValue];

    
}
- (void)saveCustomValue{
   
    if (!_tf.text) {
        DLog(@"直接保存重要标记");
    }else{
        _importFlag = _tf.text;
    }
//    self.icustomerEva.customerCardID = self.card.id;
//    self.icustomerEva.firstMeetAddress = @"";
//    self.icustomerEva.firstMeetDate = @"";
//    self.icustomerEva.id = self.card.id;
//    self.icustomerEva.isDeleted = @"";
//    self.icustomerEva.version = @"";
    //self.icustomerEva.degree = self.card.evaluation.degree;
    //self.icustomerEva.value = self.card.evaluation.value;
    DLog(@"self.icustomerEva ====== %@",self.icustomerEva);
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    KHHCustomEvaluaView *view = [[[NSBundle mainBundle] loadNibNamed:@"KHHCustomEvaluaView" owner:self options:nil] objectAtIndex:0];
    view.importFlag = _cusView.importFlag;
    //view.relationEx = _cusView.relationEx;
    //view.customValue = _cusView.customValue;
    view.relationEx = [self.card.evaluation.degree floatValue];
    view.customValue = [self.card.evaluation.value floatValue];
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
    self.card = nil;
    self.icustomerEva = nil;

}
- (void)handleTextfieldValue:(UITextField *)textf
{
    _tf = textf;
     DLog(@"_tf====%@",_tf.text);

}
- (void)handleStarNum:(DLStarRatingControl *)control startNum:(CGFloat)num
{
    if (control.tag == 7788) {
        //_relationEx = num;
        self.icustomerEva.degree = [NSNumber numberWithFloat:num];
    }else
    {
        //_customValue = num;
        self.icustomerEva.value = [NSNumber numberWithFloat:num];
    }
   
    

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
