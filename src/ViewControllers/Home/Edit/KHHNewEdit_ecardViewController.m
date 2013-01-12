//
//  KHHNewEdit_ecardViewController.m
//  CardBook
//
//  Created by CJK on 13-1-11.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNewEdit_ecardViewController.h"
#import "ParamForEditecard.h"
#import "Edit_eCardViewCell.h"
#import "EditCardPersonCell.h"
#import "NSString+Validation.h"
#import "KHHMemoPicker.h"

@interface KHHNewEdit_ecardViewController ()
{
    NSMutableArray *section0Arr;
    NSMutableArray *section1Arr;
    NSMutableArray *section2Arr;
    NSMutableArray *section3Arr;
    
    NSMutableArray *arrAllIn;
    
    //for picker
    KHHMemoPicker *sectionPicker;
    ParamForEditecard *editingParamPorPicker;
    NSIndexPath *indexPathForEditPicker;
    ParamForEditecard *cacheParamForPicker;
}

@end

@implementation KHHNewEdit_ecardViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _table = [[KHHInputTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
        _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _table.editing = YES;
        [self init3Arr];
    }
    return self;
}



- (void)init3Arr
{
    section0Arr = [[NSMutableArray alloc]initWithCapacity:2];
    section1Arr = [[NSMutableArray alloc]initWithCapacity:10];
    section2Arr = [[NSMutableArray alloc]initWithCapacity:10];
    section3Arr = [[NSMutableArray alloc]initWithCapacity:10];
    
    ParamForEditecard *paramPro00 = [[ParamForEditecard alloc]init];
    paramPro00.placeholder = @"请输入姓名";
    paramPro00.tag = 2400;
    [section0Arr addObject:paramPro00];
    ParamForEditecard *paramPro01 = [[ParamForEditecard alloc]init];
    paramPro01.placeholder = @"请输入职位";
    paramPro01.tag = 2400+1;
    [section0Arr addObject:paramPro01];
    
    NSMutableArray *arrPro = [[NSMutableArray alloc]initWithObjects:@"手机",@"电话",@"传真",@"邮箱", nil];
    NSMutableArray *arrPro1 = [[NSMutableArray alloc]initWithObjects:@"请输入手机号",@"请输入电话号码",@"请输入传真",@"请输入邮箱", nil];
    for (int i=0; i<4; i++) {
        ParamForEditecard *paramPro = [[ParamForEditecard alloc]initWithTitle:arrPro[i] placeholder:arrPro1[i]];
        paramPro.tag = 2400 +100 +i;
        [section1Arr addObject:paramPro];
    }
    ParamForEditecard *paramPro = [[ParamForEditecard alloc]init];
    paramPro.title = @"添加";
    paramPro.editingStyle = UITableViewCellEditingStyleInsert;
    paramPro.toPicker = [[NSMutableArray alloc]initWithArray:arrPro copyItems:YES];
    [section1Arr addObject:paramPro];
    
    
    NSMutableArray *arrPro2 = [[NSMutableArray alloc]initWithObjects:@"公司",@"地址",@"邮编", nil];
    
    [self init3ArrPro:arrPro2 sectionArr:section2Arr section:2];
    ParamForEditecard *paramPro2 = [[ParamForEditecard alloc]init];
    paramPro2.title = @"添加";
    paramPro2.editingStyle = UITableViewCellEditingStyleInsert;
    paramPro2.toPicker = [[NSMutableArray alloc]initWithObjects:@"部门",@"公司邮箱", nil];
    topicker2 = [[NSMutableArray alloc]initWithObjects:@"部门",@"公司邮箱", nil];
    paramPro2.forPickerToDel = YES;
    [section2Arr addObject:paramPro2];
    
    ParamForEditecard *paramPro3 = [[ParamForEditecard alloc]init];
    paramPro3.editingStyle = UITableViewCellEditingStyleInsert;
    paramPro3.title = @"添加更多";
    paramPro3.toPicker = [[NSMutableArray alloc]initWithObjects:@"网页",@"QQ",@"MSN",@"旺旺",@"业务范围",@"银行信息",@"其它信息", nil];
    topicker3 = [[NSMutableArray alloc]initWithObjects:@"网页",@"QQ",@"MSN",@"旺旺",@"业务范围",@"银行信息",@"其它信息", nil];
    paramPro3.forPickerToDel = YES;
    [section3Arr addObject:paramPro3];
    
    arrAllIn = [[NSMutableArray alloc]initWithCapacity:3];
    [arrAllIn addObject:section0Arr];
    [arrAllIn addObject:section1Arr];
    [arrAllIn addObject:section2Arr];
    [arrAllIn addObject:section3Arr];
}

- (void)init3ArrPro:(NSMutableArray *)arrPro sectionArr:(NSMutableArray *)sectionArr section:(int)section
{
    for (int i=0; i<[arrPro count]; i++) {
        ParamForEditecard *paramPro = [[ParamForEditecard alloc]initWithTitle:arrPro[i] placeholder:[NSString stringWithFormat:@"请输入%@",arrPro[i]]];
        paramPro.tag = 2400 +section*100 +i;
        [sectionArr addObject:paramPro];
    }
}
#pragma mark - load
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:241 green:238 blue:232 alpha:1.0];
    
    _table.frame =  CGRectMake(0, 0, 320, self.view.bounds.size.height-44);
    [self.view addSubview:_table];
    [self addImg];
}

- (void)addImg
{
    UIView *viewf = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 220)];
    UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 180)];
    imgview.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoTemplagesVC:)];
    tapp.numberOfTapsRequired = 1;
    tapp.numberOfTouchesRequired = 1;
    [imgview addGestureRecognizer:tapp];
    // [imgview setImageWithURL:[NSURL URLWithString:self.cardTemp.bgImage.url] placeholderImage:nil];
    [viewf addSubview:imgview];
    _table.tableHeaderView = viewf;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - tableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return [[arrAllIn objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIDZero = @"cellIDZero";
    static NSString *cellIDOne = @"cellIDOne";
    if (indexPath.section == 0) {
        EditCardPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDZero];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Edit_eCardViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.nameValue.tag = ((ParamForEditecard *)[section0Arr objectAtIndex:0]).tag;
        cell.nameValue.text = ((ParamForEditecard *)[section0Arr objectAtIndex:0]).value;
        cell.nameValue.delegate = self;
        cell.nameValue.placeholder = ((ParamForEditecard *)[section0Arr objectAtIndex:0]).placeholder;
        cell.nameValue.keyboardType = ((ParamForEditecard *)[section0Arr objectAtIndex:0]).boardType;
        
        cell.jobValue.tag = ((ParamForEditecard *)[section0Arr objectAtIndex:1]).tag;
        cell.jobValue.text = ((ParamForEditecard *)[section0Arr objectAtIndex:1]).value;
        cell.jobValue.delegate = self;
        cell.jobValue.placeholder = ((ParamForEditecard *)[section0Arr objectAtIndex:1]).placeholder;
        cell.jobValue.keyboardType = ((ParamForEditecard *)[section0Arr objectAtIndex:1]).boardType;
        return cell;
    }
    Edit_eCardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDOne];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Edit_eCardViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:1];
    }
    ParamForEditecard *paramPro = (ParamForEditecard *)[[arrAllIn objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (paramPro.editingStyle == UITableViewCellEditingStyleInsert) {
        cell.name.text = paramPro.title;
        cell.value.enabled = NO;
        return cell;
    }
    cell.value.tag = paramPro.tag;
    cell.name.text = paramPro.title;
    
    cell.value.text = paramPro.value;;
    cell.value.delegate = self;
    cell.value.placeholder = paramPro.placeholder;
    
    cell.value.keyboardType = paramPro.boardType;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (editingStyle == UITableViewCellEditingStyleInsert ) {
        if (!sectionPicker) {
            sectionPicker = [[KHHMemoPicker alloc]init];
            ParamForEditecard *paramPro = (ParamForEditecard *)[[arrAllIn objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
            sectionPicker.PickFlag = 1;
            sectionPicker.tempArray = [self sortArrToPick:indexPath.section];
            sectionPicker.delegate = self;
        }
        
        editingParamPorPicker = paramPro;
        indexPathForEditPicker = indexPath;
        [self.navigationController pushViewController:sectionPicker animated:YES];
        
        
    }else if (editingStyle == UITableViewCellEditingStyleDelete){
        
        ParamForEditecard * paramPro = (ParamForEditecard *)[[arrAllIn objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        if ([self utilForPickerIsInBank:paramPro.title]) {
            [self utilForPickerDeleteBank];
            return;
        }
        NSMutableArray *sectionPro = [arrAllIn objectAtIndex:indexPath.section];
        
        ParamForEditecard * paramPro2;
        
        if (!((ParamForEditecard *)[[arrAllIn objectAtIndex:indexPath.section]lastObject]).toPicker) {
            NSString *title = @"添加";
            if (indexPath.section == 3) {
                title = @"添加更多";
            }
            paramPro2 = [[ParamForEditecard alloc]init];
            paramPro2.editingStyle = UITableViewCellEditingStyleInsert;
            paramPro2.title = title;
            paramPro2.toPicker = [[NSMutableArray alloc]initWithObjects:paramPro.title, nil];
            paramPro2.forPickerToDel = YES;
        }else{
            paramPro2 = [sectionPro objectAtIndex:sectionPro.count-1];
            [paramPro2.toPicker addObject:paramPro.title];
            
        }
        [sectionPro removeObject:paramPro];
        [_table deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
        if (![sectionPro containsObject:paramPro2]) {
            [sectionPro addObject:paramPro2];
            
            [_table insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:sectionPro.count-1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }
}

#pragma mark - tableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        //头像
        return 60;
    }else if (indexPath.section == 2 && indexPath.row == 1)
    {
        //地址编辑框
        return 70;
    }
    return 44;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ParamForEditecard *paramPro = (ParamForEditecard *)[[arrAllIn objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    return paramPro.editingStyle;
}

#pragma mark - picker delegate

- (void)utilForPickerDeleteBank
{
    NSMutableArray *section3Pro = [arrAllIn objectAtIndex:3];
    NSMutableArray *paramArrPro = [[NSMutableArray alloc]initWithCapacity:3];
    [section3Pro enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ParamForEditecard* paramPro = obj;
        if ([self utilForPickerIsInBank:paramPro.title]) {
            [paramArrPro addObject:paramPro];
        }
    }];
    [paramArrPro enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ParamForEditecard* paramPro = obj;
        int i = [section3Pro indexOfObject:paramPro];
        [section3Pro removeObject:paramPro];
        [_table deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:i  inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
        
    }];
    
    
    for (int i=0;i<[[arrAllIn objectAtIndex:3] count];i++) {
        ParamForEditecard* paramPro = [[arrAllIn objectAtIndex:3] objectAtIndex:i];
        if ([self utilForPickerIsInBank:paramPro.title]) {
            [[arrAllIn objectAtIndex:3] removeObject:paramPro];
            i--;
            [_table deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:i inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    ParamForEditecard * paramPro2;
    NSMutableArray *sectionPro = [arrAllIn objectAtIndex:3];
    if (!((ParamForEditecard *)[sectionPro lastObject]).toPicker) {
        
        NSString *title = @"添加更多";
        
        paramPro2 = [[ParamForEditecard alloc]init];
        paramPro2.editingStyle = UITableViewCellEditingStyleInsert;
        paramPro2.title = title;
        paramPro2.toPicker = [[NSMutableArray alloc]initWithObjects:@"银行信息", nil];
        paramPro2.forPickerToDel = YES;
    }else{
        paramPro2 = [[arrAllIn objectAtIndex:3] lastObject];
        [paramPro2.toPicker addObject:@"银行信息"];
    }
    if (![sectionPro containsObject:paramPro2]) {
        [sectionPro addObject:paramPro2];
        [_table insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:sectionPro.count-1 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (Boolean)utilForPickerIsInBank:(NSString *)title
{
    
    NSMutableArray *arrBank = [[NSMutableArray alloc]initWithObjects:@"开户行",@"银行帐号",@"户名", nil];
    for (NSString * str in arrBank) {
        if ([str isEqualToString:title]) {
            return YES;
        }
    }
    return NO;
}

- (void)utilForPickerParam:(NSMutableArray *)arrBank sectionArr:(NSMutableArray *)sectionArr
{
    for (int i=0;i<arrBank.count;i++) {
        ParamForEditecard* paramPro00 = [[ParamForEditecard alloc]initWithTitle:arrBank[i] placeholder:[NSString stringWithFormat:@"请输入%@",arrBank[i]]];
        paramPro00.editingStyle = UITableViewCellEditingStyleDelete;
        paramPro00.tag = 2400 +indexPathForEditPicker.section*100 +indexPathForEditPicker.row+i;
        [sectionArr insertObject:paramPro00 atIndex:indexPathForEditPicker.row+i];
        [_table insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPathForEditPicker.row+i inSection:indexPathForEditPicker.section]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    [((UITextField *)[self.view viewWithTag:2400 +indexPathForEditPicker.section*100 +indexPathForEditPicker.row]) becomeFirstResponder];
    
    if(editingParamPorPicker.forPickerToDel){
        [editingParamPorPicker.toPicker removeObject:@"银行信息"];
        if ([editingParamPorPicker.toPicker count] == 0) {
            [[arrAllIn objectAtIndex:3] removeObject:editingParamPorPicker];
            [_table deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPathForEditPicker.row+3 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

- (void)addToExternArrayFromPick:(NSString *)str
{
    if ([str isEqualToString:@"银行信息"]) {
        NSMutableArray *sectionArr = [arrAllIn objectAtIndex:indexPathForEditPicker.section];
        NSMutableArray *arrBank = [[NSMutableArray alloc]initWithObjects:@"开户行",@"银行帐号",@"户名", nil];
        [self utilForPickerParam:arrBank sectionArr:sectionArr];
        return;
    }else{
        
        ParamForEditecard* paramPro = [[ParamForEditecard alloc]initWithTitle:str placeholder:[NSString stringWithFormat:@"请输入%@",str]];
        paramPro.editingStyle = UITableViewCellEditingStyleDelete;
        paramPro.tag = 2400 +indexPathForEditPicker.section*100 +indexPathForEditPicker.row;
        [[arrAllIn objectAtIndex:indexPathForEditPicker.section] insertObject:paramPro atIndex:indexPathForEditPicker.row];
        
        [_table insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPathForEditPicker.row inSection:indexPathForEditPicker.section]] withRowAnimation:UITableViewRowAnimationNone];
        [((UITextField *)[self.view viewWithTag:paramPro.tag]) becomeFirstResponder];
    }
    if(editingParamPorPicker.forPickerToDel){
        [editingParamPorPicker.toPicker removeObject:str];
        if ([editingParamPorPicker.toPicker count] == 0) {
            [[arrAllIn objectAtIndex:indexPathForEditPicker.section] removeObject:editingParamPorPicker];
            [_table deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPathForEditPicker.row+1 inSection:indexPathForEditPicker.section]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

#pragma mark - picker sortUtil delegate

NSMutableArray *topicker2;
NSMutableArray *topicker3;
- (NSMutableArray *)sortArrToPick:(int)section
{
    ParamForEditecard *pro = (ParamForEditecard *)[[arrAllIn objectAtIndex:section]lastObject];
    
    if (section == 1) {
        return pro.toPicker;
    }
    
    NSMutableArray *arrPro = [[NSMutableArray alloc]initWithCapacity:8];
    NSMutableArray *topicker;
    
    if (section == 2) {
        topicker = topicker2;
    }else{
        topicker = topicker3;
    }
    [topicker enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([self isIn:(NSString *)obj arr:pro.toPicker] ) {
            [arrPro addObject:(NSString *)obj];
        }
    }];
    return arrPro;
}

- (BOOL)isIn:(NSString *)str2 arr:(NSArray *)arr{
    for (NSString * str in arr) {
        if ([str isEqualToString:str2]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - textField delegate;
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self nextTag:textField.tag]!=-1) {
        textField.returnKeyType = UIReturnKeyNext;
    }else{
        textField.returnKeyType = UIReturnKeyDone;
    }
    CGRect rectForKey = textField.superview.superview.frame;
    rectForKey.origin.y += 30;
    [_table goToInsetForKeyboard:rectForKey];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{    
    ParamForEditecard *param =  [self paramFromTag:textField.tag];
    param.value = textField.text;
    [self valid:param];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    int nextTag = [self nextTag:textField.tag];
    if (nextTag == -1){
        return YES;
    }
    UITextField *view = (UITextField *)[self.view viewWithTag:nextTag];
    [view becomeFirstResponder];
    return YES;
}

#pragma mark - textField Util

- (ParamForEditecard *)paramFromTag:(int)tag
{
    for (NSMutableArray *arrPro in arrAllIn) {
        for (ParamForEditecard *paramPro in arrPro) {
            if(paramPro.tag == tag){
                return paramPro;
            }
        }
    }
    return nil;
}

- (int)nextTag:(int)tag
{
    NSMutableArray *sectionPro = [arrAllIn objectAtIndex:3];
    if ([sectionPro count]==1) {
        sectionPro = [arrAllIn objectAtIndex:2];
    }
    if (!((ParamForEditecard *)[sectionPro lastObject]).toPicker) {
        ParamForEditecard *paramPro = (ParamForEditecard *)[sectionPro objectAtIndex:[sectionPro count]-1];
        if (tag>=paramPro.tag) {
            return -1;
        }
    }else{
        ParamForEditecard *paramPro = (ParamForEditecard *)[sectionPro objectAtIndex:[sectionPro count]-2];
        if (tag>=paramPro.tag) {
            return -1;
        }
    }
    
    int nextTag = tag+1;
    UIView *view = [self.view viewWithTag:nextTag];
    if([view isKindOfClass:[UITextField class]]){
        return nextTag;
    }
    nextTag = tag-tag%100+100;
    UIView *view2 = [self.view viewWithTag:nextTag];
    if([view2 isKindOfClass:[UITextField class]]){
        return nextTag;
    }
    return -1;
    
}

- (void)valid:(ParamForEditecard *)param
{
    if ([param.title isEqualToString:@"手机"]) {
        if (param.value.length > 0 && ![param.value isValidMobilePhoneNumber]) {
            [self warnAlertMessage:@"手机格式错误"];
        }
        
    }else if ([param.title isEqualToString:@"电话"]){
        if (param.value.length > 0 && ![param.value isValidTelephoneNUmber]) {
            [self warnAlertMessage:@"电话号码格式错误"];
        }
    }else if ([param.title isEqualToString:@"传真"]){
        if (param.value.length > 0 && ![param.value isValidTelephoneNUmber]) {
            [self warnAlertMessage:@"传真格式错误"];
        }
        
    }else if ([param.title isEqualToString:@"邮箱"]){
        if (param.value.length > 0 && ![param.value isValidEmail]) {
            [self warnAlertMessage:@"邮箱格式错误"];
        }
        
    }else if ([param.title isEqualToString:@"QQ"]){
        if (param.value.length > 0 && ![param.value isValidQQ]) {
            [self warnAlertMessage:@"QQ格式错误"];
        }
    }else if ([param.title isEqualToString:@"邮编"]){
        if (param.value.length > 0 && ![param.value isValidPostalCode]) {
            [self warnAlertMessage:@"邮编格式错误"];
        }
        
    }
}

- (void)warnAlertMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:message delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alert show];
}

@end
