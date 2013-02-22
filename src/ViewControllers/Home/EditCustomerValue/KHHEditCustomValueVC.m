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
#import "KHHDataAPI.h"
#import "KHHDataNew+Card.h"


@interface KHHEditCustomValueVC ()<KHHCustomEvaluaViewDelegate>
@property (strong, nonatomic) ICustomerEvaluation *icustomerEva;
//@property (strong, nonatomic) KHHData             *dataCtrl;
@property (strong, nonatomic) MBProgressHUD       *hud;

@end

@implementation KHHEditCustomValueVC
@synthesize importFlag = _importFlag;
@synthesize relationEx = _relationEx;
@synthesize customValue = _customValue;
@synthesize tf = _tf;
@synthesize cusView = _cusView;
@synthesize card;
@synthesize icustomerEva;
//@synthesize dataCtrl;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.rightBtn setTitle:@"保存" forState:UIControlStateNormal];
        self.icustomerEva = [[ICustomerEvaluation alloc] init];
       // self.dataCtrl = [KHHData sharedData];
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
    NSArray *cards = [[KHHDataNew sharedData] allMyCards];
    if (!cards || cards.count <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:KhhMessageDataErrorTitle
                                                        message:KhhMessageDataErrorNotice
                                                       delegate:nil
                                              cancelButtonTitle:KHHMessageSure
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    //注册评估消息
//    [self observeNotificationName:KHHUISaveEvaluationSucceeded selector:@"handleSaveEvaluationSucceeded:"];
//    [self observeNotificationName:KHHUISaveEvaluationFailed selector:@"handleSaveEvaluationFailed:"];
    if (!_tf.text) {
        DLog(@"直接保存重要标记");
        self.icustomerEva.remarks = @"";
    }else{
        _importFlag = _tf.text?_tf.text:@"";
        self.icustomerEva.remarks = _tf.text;
    }
    
    self.icustomerEva.id = self.card.evaluation.id;
    self.icustomerEva.version = self.card.evaluation.version;
    self.icustomerEva.degree = [NSNumber numberWithFloat:_relationEx];
    self.icustomerEva.value = [NSNumber numberWithFloat:_customValue];
    
    DLog(@"self.icustomerEva ====== %@",self.icustomerEva);
    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    self.hud.labelText = KHHMessageCreateCustomValue;
   
    InterCustomer *iCustomer = [[InterCustomer alloc]init];
    if (self.card.evaluation) {
        iCustomer.id = [NSString stringWithFormat:@"%lld",self.card.evaluation.idValue];
    }
    iCustomer.customerCard = [NSString stringWithFormat:@"%lld",self.card.idValue];
    iCustomer.depth = [NSString stringWithFormat:@"%d" ,(int)_relationEx];
    iCustomer.cost = [NSString stringWithFormat:@"%d" ,(int)_customValue];   
    iCustomer.remarks = _importFlag;
    [[KHHDataNew sharedData] doAddUpdateCustomer:iCustomer delegate:self];
}

- (void)addUpdateCustomerForUISuccess
{
    [_hud hide:YES];
    if (_addUpdateCostomerSuccess) {
        _addUpdateCostomerSuccess();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addUpdateCustomerForUIFailed:(NSDictionary *)dict
{
    [_hud hide:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"修改评估失败" message:dict[kInfoKeyErrorMessage] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

////处理网络返回结果
//- (void)handleSaveEvaluationSucceeded:(NSNotification *)info{
//    [self stopObservingForEvaluation];
//    [self.hud hide:YES];
//    [self.navigationController popViewControllerAnimated:YES];
//}
//- (void)handleSaveEvaluationFailed:(NSNotification *)info{
//    [self stopObservingForEvaluation];
//    DLog(@"handleSaveEvaluationFailed! ====== %@",info);
//    self.hud.labelText = NSLocalizedString(KHHMessageSaveFailed, nil);
//    [self.hud hide:YES afterDelay:1];
//
//}
//- (void)stopObservingForEvaluation{
//    [self stopObservingNotificationName:KHHUISaveEvaluationSucceeded];
//    [self stopObservingNotificationName:KHHUISaveEvaluationFailed];
//
//}
#pragma mark -
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    KHHCustomEvaluaView *view = [[[NSBundle mainBundle] loadNibNamed:@"KHHCustomEvaluaView" owner:self options:nil] objectAtIndex:0];
    view.importFlag =  self.card.evaluation.remarks;//_cusView.importFlag;
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
    self.hud = nil;

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
