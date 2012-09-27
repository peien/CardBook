//
//  PickViewController.m
//  CardBook
//
//  Created by 王国辉 on 12-8-15.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "PickViewController.h"

@interface PickViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

@end

@implementation PickViewController
@synthesize pickView = _pickView;
@synthesize PickFlag = _PickFlag;
@synthesize dataName = _dataName;
@synthesize delegate = _delegate;
@synthesize groupArr = _groupArr;
@synthesize tempArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.rightBarButtonItem = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 55, 320, 216)];
    _pickView.showsSelectionIndicator = YES;
    _pickView.delegate = self;
    _pickView.dataSource = self;
    [self.view addSubview:_pickView];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _pickView = nil;
    _dataName = nil;
    _groupArr = nil;
    self.tempArray = nil;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;

}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_PickFlag == 0 ) {
        return 4;
    }else if (_PickFlag == 2){
        return tempArray.count;
    }else if (_PickFlag == 3){
        return 2;
    }else if (_PickFlag == 1){
        return tempArray.count;
    }else
        return 0;

}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_PickFlag == 0) {
        return [[_dataName objectAtIndex:0] objectAtIndex:row];
    }else if (_PickFlag == 2){
        return [tempArray objectAtIndex:row];
    }else if(_PickFlag == 3){
        return [_groupArr objectAtIndex:row];
    }else if (_PickFlag == 1){
        return [tempArray objectAtIndex:row];
    }
     else
        return nil;

}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *str = nil;
    if (_PickFlag == 0) {
        str = [[_dataName objectAtIndex:0] objectAtIndex:row];
    }else if (_PickFlag == 2){
        str = [tempArray objectAtIndex:row];
    }else if (_PickFlag == 3){
        str = [_groupArr objectAtIndex:row];
    }else if (_PickFlag == 1){
        str = [tempArray objectAtIndex:row];
        
    }
    //NSLog(@">>>>>>>>>>%@",str);
    [_delegate addToExternArrayFromPick:str];
    [self.navigationController popViewControllerAnimated:YES];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
