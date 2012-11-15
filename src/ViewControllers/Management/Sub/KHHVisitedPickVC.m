//
//  KHHVisitedPickVC.m
//  CardBook
//
//  Created by 王国辉 on 12-11-14.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHVisitedPickVC.h"

@interface KHHVisitedPickVC ()

@end

@implementation KHHVisitedPickVC
@synthesize tempPickArr = _tempPickArr;
@synthesize isShowNoteValue;
@synthesize isShowTimeValue;
@synthesize isShowWarnValue;
@synthesize visitVC;
@synthesize visitedUpdateVale;
@synthesize datePick;
@synthesize pick;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithRed:241 green:238 blue:232 alpha:1.0]];
    if (self.isShowTimeValue) {
        self.pick.hidden = YES;
    }else if (self.isShowNoteValue || self.isShowWarnValue){
        self.datePick.hidden = YES;
    }
}
- (void)rightBarButtonClick:(id)sender{
    if (self.isShowTimeValue) {
        [self.visitVC datePickerValueChanged:datePick];
        
    }else{
        int row = [self.pick selectedRowInComponent:0];
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
        int row = [self.pick selectedRowInComponent:0];
        if (row == 0) {
            self.visitVC.timeInterval = MAXFLOAT;
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
