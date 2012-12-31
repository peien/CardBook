//
//  KHHVisitedPickVC.m
//  CardBook
//
//  Created by 王国辉 on 12-11-14.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHVisitedPickVC.h"

#define pickFrame  CGRectMake(0, 85, 320, 216)

@interface KHHVisitedPickVC () <UIPickerViewDelegate>
{
    UIDatePicker *datePick;
    UIPickerView *pick;
}
@end

@implementation KHHVisitedPickVC
@synthesize tempPickArr = _tempPickArr;
@synthesize isShowNoteValue;
@synthesize isShowTimeValue;
@synthesize isShowWarnValue;
@synthesize visitVC;
@synthesize visitedUpdateVale;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.rightBtn setTitle:KHHMessageSure forState:UIControlStateNormal];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithRed:241 green:238 blue:232 alpha:1.0]];
    if (self.isShowTimeValue) {
//        pick.hidden = YES;
        [self initDatePickView];
    }else if (self.isShowNoteValue || self.isShowWarnValue){
//        datePick.hidden = YES;
        [self initPickView];
    }
}

-(void) initDatePickView {

    datePick = [[UIDatePicker alloc] initWithFrame:pickFrame];
    //只能选择未来的时间
    datePick.minimumDate = [NSDate new];
    [self.view addSubview:datePick];
}

-(void) initPickView {
    pick = [[UIPickerView alloc] initWithFrame:pickFrame];
    pick.delegate = self;
    [pick setShowsSelectionIndicator:YES];
    [self.view addSubview:pick];
}

- (void)rightBarButtonClick:(id)sender{
    if (self.isShowTimeValue) {
        [self.visitVC datePickerValueChanged:datePick];
        
    }else{
        int row = [pick selectedRowInComponent:0];
        NSString *title = [_tempPickArr objectAtIndex:row];
        if ([visitedUpdateVale isKindOfClass:[UITextField class]]) {
            UITextField *tf = (UITextField *)visitedUpdateVale;
            tf.text = title;
        }else{
            UIButton *btn = (UIButton *)visitedUpdateVale;
            [btn setTitle:title forState:UIControlStateNormal];
        }
    
    }
    if (self.isShowWarnValue) {
        int row = [pick selectedRowInComponent:0];
        if (row == 0) {
            self.visitVC.timeInterval = 0;
        }else if (row == 1){
            self.visitVC.timeInterval = 30*60;
        }else if (row == 2){
            self.visitVC.timeInterval = 60*60;
        }else if (row == 3){
            self.visitVC.timeInterval = 2*60*60;
        }else if (row == 4){
            self.visitVC.timeInterval = 3*60*60;
        }else if (row == 5){
            self.visitVC.timeInterval = 12*60*60;
        }else if (row == 6){
            self.visitVC.timeInterval = 24*60*60;
        }else if (row == 7){
            self.visitVC.timeInterval = 2*24*60*60;
        }else if (row == 8){
            self.visitVC.timeInterval = 3*24*60*60;
        }else if (row == 9){
            self.visitVC.timeInterval = 7*24*60*60;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark UIPickViewDelegates
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return [_tempPickArr count];
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_tempPickArr objectAtIndex:row];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
