//
//  KHHPlanViewController.m
//  CardBook
//
//  Created by CJK on 13-1-4.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHPlanViewController.h"
#import "KHHTargetCell.h"
#import "KHHDateCell.h"
#import "KHHLocationCell.h"
#import "KHHImageCell.h"
#import "KHHMemoCell.h"
#import "KHHUpperView.h"

@interface KHHPlanViewController ()
{
    NSDictionary *dicTemp;
    CGRect rectForKey;
    NSMutableArray *inputsForKeyboard;
}
@end

@implementation KHHPlanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil

{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        table = [[KHHInputTableView alloc]init];
        table.delegate = self;
        table.dataSource = self;
        table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        table.hiddenDelgate = self;
    }
    return self;
}

- (void)hiddenKeyboard
{
    for (id obj in  inputsForKeyboard) {
        if ([obj isKindOfClass:[UITextField class]]) {
            UITextField *pro = (UITextField *)obj;
            if(pro.isFirstResponder){
                [pro resignFirstResponder];
            }
            
        }
        if ([obj isKindOfClass:[KHHDatePicker class]]) {
            KHHDatePicker *pro = (KHHDatePicker *)obj;
            if(!pro.hidden){
                [pro cancelPicker:NO];
            }
            
        }
        if ([obj isKindOfClass:[HZAreaPickerView class]]) {
            HZAreaPickerView *pro = (HZAreaPickerView *)obj;
            if(!pro.hidden){
                [pro cancelPicker:NO];
            }
            
        }
        if ([obj isKindOfClass:[KHHMemoPicker class]]) {
            KHHMemoPicker *pro = (KHHMemoPicker *)obj;
            if(!pro.hidden){
                [pro cancelPicker:NO];
            }
            
        }
        
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.title = @"新建计划";
    // NSLog(@"%f",);
    
    table.frame =  CGRectMake(0, 0, 320, self.view.bounds.size.height-44-50);
    
    inputsForKeyboard = [[NSMutableArray alloc]initWithCapacity:10];
    [self.view addSubview:table];
    dicTemp = [[NSMutableDictionary alloc]init];
    KHHUpperView *upView = [[KHHUpperView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-44-50, 320, 50)];
    [self.view addSubview:upView];
    
}



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.datePicker||self.areaPicker||self.memoPicker) {
        [self cancelLocatePicker];
    }
    
}

- (void)dateChanged
{
    [dicTemp setValue:[KHHDateUtil strFromDate:[_datePicker date]] forKey:@"date"];
    [dicTemp setValue:[KHHDateUtil strTimeFromDate:[_datePicker date]] forKey:@"time"];
    [table reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:0],[NSIndexPath indexPathForRow:2 inSection:0],nil]  withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        CellIdentifier = @"Target";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[KHHTargetCell alloc]init];
            ((KHHTargetCell *)cell).headStr = @"对象";
            ((KHHTargetCell *)cell).placeStr = @"请选择拜访对象";
            ((KHHTargetCell *)cell).field.delegate = self;
            ((KHHTargetCell *)cell).field.tag = 10020;
        }
        if ([dicTemp objectForKey:@"target"]) {
            ((KHHTargetCell *)cell).field.text = [dicTemp objectForKey:@"target"];
        }
    
    }
    if (indexPath.row == 1||indexPath.row  == 2) {
        CellIdentifier = @"Date";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[KHHDateCell alloc]init];
        }
        if (indexPath.row == 1) {
            ((KHHDateCell *)cell).headStr = @"日期";
            if ([dicTemp objectForKey:@"date"]) {
                ((KHHDateCell *)cell).dateStr = [dicTemp objectForKey:@"date"];
            }else{
                ((KHHDateCell *)cell).dateStr = [KHHDateUtil nowDate];
            }
        }
        if (indexPath.row == 2) {
            ((KHHDateCell *)cell).headStr = @"时间";
            if ([dicTemp objectForKey:@"time"]) {
                ((KHHDateCell *)cell).dateStr = [dicTemp objectForKey:@"time"];
            }else{
                ((KHHDateCell *)cell).dateStr = [KHHDateUtil strTimeFromDate:[NSDate new]];
            }
        }
       
        
    }
    if (indexPath.row == 3) {
        CellIdentifier = @"Location";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[KHHLocationCell alloc]init];
        }
        ((KHHLocationCell *)cell).headStr = @"位置";
        ((KHHLocationCell *)cell).field.delegate = self;
        ((KHHLocationCell *)cell).field.tag = 10021;
        if ([dicTemp objectForKey:@"location"]) {
            ((KHHLocationCell *)cell).locationStr = [dicTemp objectForKey:@"location"];
        }else{
            ((KHHLocationCell *)cell).locationStr = @"请选择省市地";
        }

    }
    if (indexPath.row == 4) {
        CellIdentifier = @"Image";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[KHHImageCell alloc]init];
        }
        ((KHHImageCell *)cell).headStr = @"图片";
        [((KHHImageCell *)cell).imageBtn addTarget:self action:@selector(addImg) forControlEvents:UIControlEventTouchUpInside];
        //((KHHLocationCell *)cell).field.delegate = self;
        if ([dicTemp objectForKey:@"location"]) {
            //((KHHImageCell *)cell).locationStr = [dicTemp objectForKey:@"location"];
        }else{
            // ((KHHImageCell *)cell).locationStr = @"请选择省市地";
        }
    }
    if (indexPath.row == 5||indexPath.row == 6) {
        CellIdentifier = @"Date";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[KHHMemoCell alloc]init];
        }
        if (indexPath.row == 5) {
             ((KHHMemoCell *)cell).butTitle.titleLabel.text = [dicTemp objectForKey:@"date"];
//            if ([dicTemp objectForKey:@"date"]) {
//               
//            }else{
//                ((KHHDateCell *)cell).dateStr = [KHHDateUtil nowDate];
//            }
        }
        if (indexPath.row == 6) {
            ((KHHMemoCell *)cell).butTitle.titleLabel.text = [dicTemp objectForKey:@"date"];
//            ((KHHDateCell *)cell).headStr = @"提醒";
//            if ([dicTemp objectForKey:@"time"]) {
//                ((KHHDateCell *)cell).dateStr = [dicTemp objectForKey:@"time"];
//            }else{
//                ((KHHDateCell *)cell).dateStr = [KHHDateUtil strTimeFromDate:[NSDate new]];
//            }
        }
    }
    if (indexPath.row == 7) {
        CellIdentifier = @"Target";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[KHHTargetCell alloc]init];
            ((KHHTargetCell *)cell).headStr = @"说明";
            ((KHHTargetCell *)cell).placeStr = @"请输入文字记录(400字内)";
            ((KHHTargetCell *)cell).field.delegate = self;
            ((KHHTargetCell *)cell).field.tag = 10022;
        }
        if ([dicTemp objectForKey:@"target"]) {
            ((KHHTargetCell *)cell).field.text = [dicTemp objectForKey:@"target"];
        }
    }
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



#pragma mark - buttons actions

- (void)addImg{
    UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:nil, nil];
    [actSheet addButtonWithTitle:@"本地相册"];
    [actSheet addButtonWithTitle:@"拍照"];
    [actSheet showInView:self.view];
    actSheet.tag = 1001;
}

#pragma mark - textFiled delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    [dicTemp setValue:textField.text forKey:@"target"];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    rectForKey = textField.superview.superview.frame;
    if (textField.tag ==10022) {
        rectForKey = CGRectMake(rectForKey.origin.x, rectForKey.origin.y, rectForKey.size.width, rectForKey.size.height);
    }else{
        rectForKey = CGRectMake(rectForKey.origin.x, rectForKey.origin.y+30, rectForKey.size.width, rectForKey.size.height);
    }
    
    [table goToInsetForKeyboard:rectForKey];
    [self addRes:textField];
    if(!self.datePicker.hidden){
        [self.datePicker cancelPicker:NO];
    }
    if (!self.areaPicker.hidden) {
        [self.areaPicker cancelPicker:NO];
    }
    if (!self.memoPicker.hidden) {
        [self.memoPicker cancelPicker:NO];
    }
    
}

- (void)addRes:(id)obj2
{
    
    for (id obj in  inputsForKeyboard) {
        if ([obj isEqual:obj2]) {
            return;           
        }
    }
    [inputsForKeyboard addObject:obj2];
}

#pragma mark - Picker
-(void)cancelLocatePicker
{
    [self.datePicker cancelPicker:YES];
    self.datePicker = nil;
    [self.areaPicker cancelPicker:YES];
    self.areaPicker.delegate = nil;
    self.areaPicker = nil;
    
    [self.memoPicker cancelPicker:YES];
    self.memoPicker = nil;
}

- (void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    [dicTemp setValue:[NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district] forKey:@"location"];
    [table reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:0]]  withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1||indexPath.row == 2||indexPath.row == 3||indexPath.row == 5) {
        rectForKey = [tableView cellForRowAtIndexPath:indexPath].frame;
        rectForKey = CGRectMake(rectForKey.origin.x, rectForKey.origin.y+30, rectForKey.size.width, rectForKey.size.height);
        [table goToInsetForKeyboard:rectForKey];
    }
    
    if (indexPath.row == 1||indexPath.row == 2) {        
        [self hiddenKeyboard];
        if (!self.datePicker) {
            self.datePicker = [[ KHHDatePicker alloc] initWithFrame:CGRectMake(0.0,460-200.0,320.0,200.0)];
            
            [self.datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
            self.datePicker.hidden = YES;
            [self addRes:_datePicker];
        }
        if (self.datePicker.hidden) {
            [self.datePicker showInView:self.navigationController.view ];
        }else{
            [table showNormal];
        }
        
        return;
        
    }
    if (indexPath.row == 3) {
//        [self registResponder];
//        if(!self.datePicker.hidden){
//            [self.datePicker cancelPicker:NO];
//        }
         [self hiddenKeyboard];
        if (!self.areaPicker) {            
            self.areaPicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self];
            self.areaPicker.hidden = YES;
            [self addRes:_areaPicker];
        }
        if (self.areaPicker.hidden) {
            [self.areaPicker showInView:self.navigationController.view ];
        }else{
            [table showNormal];
        }
        return;
    }
    
    if (indexPath.row == 5) {
//        [self registResponder];
//        if(!self.memoPicker.hidden){
//            [self.memoPicker cancelPicker:NO];
//        }
        [self hiddenKeyboard];
        if (!self.memoPicker) {
            self.memoPicker = [[ KHHMemoPicker alloc] initWithFrame:CGRectMake(0.0,460-200.0,320.0,200.0)];
            self.memoPicker.hidden = YES;
            [self addRes:_memoPicker];
        }
        if (self.memoPicker.hidden) {
            [self.memoPicker showInView:self.navigationController.view ];
        }else{
            [table showNormal];
        }
        
        return;
    }
}

- (void)registResponder
{
    UITableViewCell *cell = [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (cell) {
        [((KHHTargetCell *)cell) registResponder];
    }
    UITableViewCell *cell1 = [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    if (cell) {
        [((KHHLocationCell *)cell1) registResponder];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        return 60;
    }
    if (indexPath.row == 4) {
        return 60;
    }
    return 45;
}

#pragma mark - imagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
     [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2 ){        
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"不支持拍照" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }else{
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            [self presentModalViewController:picker animated:YES];
        }
    }
    if (buttonIndex == 1) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = sourceType;
        picker.delegate = self;
        [self presentModalViewController:picker animated:YES];
        
    }
}






@end




