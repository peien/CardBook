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
#import "KHHLocalForCardCell.h"
#import "CardTemplate.h"
#import "NSManagedObject+KHH.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Image.h"
#import "InterCard.h"
#import "KHHCardTemplageVC.h"
#import "KHHFrameCardView.h"

@interface KHHNewEdit_ecardViewController  ()
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
    
    
    //for location
    NSString *locationStr;
    HZAreaPickerView *areaPicker;
    
    //for save card;
    InterCard *icard;
    
    //for Template;
    CardTemplate *_cardTemplate;
    UIImageView *tempImgview;
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
        [self.rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    }
    return self;
}

#pragma mark - apparece in edit
- (void)init3Arr_2
{
    [self init3Arr];
    
    ((ParamForEditecard *)section0Arr[0]).value = _toEditCard.name;
    ((ParamForEditecard *)section0Arr[1]).value = _toEditCard.title;
    
    ((ParamForEditecard *)section1Arr[0]).value = _toEditCard.mobilePhone;
    ((ParamForEditecard *)section1Arr[1]).value = _toEditCard.telephone;
    ((ParamForEditecard *)section1Arr[2]).value = _toEditCard.fax;
    ((ParamForEditecard *)section1Arr[3]).value = _toEditCard.email;
   
    ((ParamForEditecard *)section2Arr[0]).value = _toEditCard.company.name;
    if (_toEditCard.address.province) {
         locationStr =[NSString stringWithFormat:@"%@,%@,%@", _toEditCard.address.province,_toEditCard.address.city ,_toEditCard.address.district];
    }
   
    ((ParamForEditecard *)section2Arr[1]).value = _toEditCard.address.street;
    ((ParamForEditecard *)section2Arr[2]).value = _toEditCard.address.zip;
}

#pragma mark - apparece in new
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
    [self doBrach];
    self.view.backgroundColor = [UIColor colorWithRed:241 green:238 blue:232 alpha:1.0];
    
    _table.frame =  CGRectMake(0, 0, 320, self.view.bounds.size.height-44);
    [self.view addSubview:_table];
    [self addImg];
}

- (void)doBrach{
    if (self.toEditCard) {
        self.title = @"详细信息";
        [self init3Arr_2];
    }else{
        self.title = @"新建名片";
        [self init3Arr];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_table showNormal];
    if (!sectionPicker) {
        [sectionPicker cancelPicker:YES];
    }
    if (!areaPicker) {
        [areaPicker cancelPicker:YES];
    }
}

- (void)addImg
{
    if (!self.toEditCard) {
        
        
        UIView *viewf = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 220)];
        tempImgview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 180)];
        tempImgview.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoTemplagesVC:)];
        tapp.numberOfTapsRequired = 1;
        tapp.numberOfTouchesRequired = 1;
        [tempImgview addGestureRecognizer:tapp];
        CardTemplate * cardTempLatePro = [CardTemplate objectByID:@(10) createIfNone:NO];
        [tempImgview setImageWithURL:[NSURL URLWithString:cardTempLatePro.bgImage.url] placeholderImage:nil];
        [viewf addSubview:tempImgview];
        _table.tableHeaderView = viewf;
        
    }else{
        
        //[KHHShowHideTabBar hideTabbar];
        KHHFrameCardView *cardView = [[KHHFrameCardView alloc] initWithFrame:CGRectMake(0, 0, 320, 220) delegate:self isVer:NO callbackAction:nil];
        cardView.tapCallBack = ^(){[self gotoTemplagesVC:nil];};
        cardView.isOnePage = YES;
        cardView.card = self.toEditCard;
        [cardView showView];
        _table.tableHeaderView = cardView;
    }
}

- (void)gotoTemplagesVC:(UITapGestureRecognizer *)sender{
    KHHCardTemplageVC *temVC = [[KHHCardTemplageVC alloc] initWithNibName:nil bundle:nil];
    temVC.selectTemplate = ^(CardTemplate *cardTemplate){
        _cardTemplate = cardTemplate;
        [tempImgview setImageWithURL:[NSURL URLWithString:_cardTemplate.bgImage.url] placeholderImage:nil];
    };
    [self.navigationController pushViewController:temVC animated:YES];
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
    static NSString *cellLocal = @"cellLocal";
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
    if (indexPath.section == 2 && indexPath.row == 1) {
        KHHLocalForCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellLocal];
        if (!cell) {
            cell = [[KHHLocalForCardCell alloc]init];
            cell.localTip = ^(){[self showLocalPicker:indexPath];};
        }
        ((KHHLocalForCardCell *)cell).headStr = @"地址";
        ((KHHLocalForCardCell *)cell).field.delegate = self;
        ((KHHLocalForCardCell *)cell).field.tag = ((ParamForEditecard *)[section2Arr objectAtIndex:1]).tag;
        ((KHHLocalForCardCell *)cell).field.text = ((ParamForEditecard *)[section2Arr objectAtIndex:1]).value;
        NSLog(@"tag%d",cell.field.tag);
        if (locationStr) {
            ((KHHLocalForCardCell *)cell).locationStr = locationStr;
        }else{
            ((KHHLocalForCardCell *)cell).locationStr = @"请选择省市地";
        }
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
        [self hiddenKeyboard];
        if (!sectionPicker) {
            sectionPicker = [[ KHHMemoPicker alloc] initWithFrame:CGRectMake(0.0,H460-200.0,320.0,200.0)];
            sectionPicker.hidden = YES;
            
            
            __block KHHNewEdit_ecardViewController *weakself = self;
            sectionPicker.showTitle = ^(NSString *title, int tag){
                [weakself addToExternArrayFromPick:title];
            };
            
        }
        sectionPicker.memoArr = [self sortArrToPick:indexPath.section];
        if (sectionPicker.hidden) {
            CGRect rectForKey = [tableView cellForRowAtIndexPath:indexPath].frame;
            rectForKey = CGRectMake(rectForKey.origin.x, rectForKey.origin.y+30, rectForKey.size.width, rectForKey.size.height);
            [_table goToInsetForKeyboard:rectForKey];
            [sectionPicker showInView:self.view ];
        }else{
            [_table showNormal];
        }
        ParamForEditecard *paramPro = (ParamForEditecard *)[[arrAllIn objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        
        editingParamPorPicker = paramPro;
        indexPathForEditPicker = indexPath;
        // [self.navigationController pushViewController:sectionPicker animated:YES];
        
        
    }else if (editingStyle == UITableViewCellEditingStyleDelete){
        
        [self hiddenKeyboard];
        [_table showNormal];
        
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
            if (paramPro2.forPickerToDel) {
                [paramPro2.toPicker addObject:paramPro.title];
            }
            
            
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

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 2&&indexPath.row == 1) {
//        [self hiddenKeyboard];
//        if (!areaPicker) {
//            areaPicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self];
//
//            areaPicker.hidden = YES;
//
//        }
//        if (areaPicker.hidden) {
//            [areaPicker showInView:self.navigationController.view ];
//        }else{
//            [_table showNormal];
//        }
//    }
//}



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
        [self hiddenKeyboard];
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
    if (!sectionPicker.hidden) {
        [sectionPicker cancelPicker:NO];
    }
    if (!areaPicker.hidden) {
        [areaPicker cancelPicker:NO];
    }
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
        [textField resignFirstResponder];
        [_table showNormal];
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

#pragma mark - hiddenKeyboard

- (void)hiddenKeyboard
{
    for (NSMutableArray *arrPro in arrAllIn) {
        for( ParamForEditecard *paraPro in arrPro){
            UIView *viewPro = [self.view viewWithTag:paraPro.tag];
            if ([viewPro isKindOfClass:[UITextField class]]) {
                if ([viewPro isFirstResponder]) {
                    [viewPro resignFirstResponder];
                    return;
                }
                
            }
        }
    }
    if (!sectionPicker.hidden) {
        [sectionPicker cancelPicker:NO];
    }
    if (!areaPicker.hidden) {
        [areaPicker cancelPicker:NO];
    }
}

#pragma mark - local picker
- (void)showLocalPicker:(NSIndexPath *)indexPath
{
    CGRect rectForKey = [_table cellForRowAtIndexPath:indexPath].frame;
    rectForKey = CGRectMake(rectForKey.origin.x, rectForKey.origin.y+30, rectForKey.size.width, rectForKey.size.height);
    [_table goToInsetForKeyboard:rectForKey];
    
    [self hiddenKeyboard];
    if (!areaPicker) {
        areaPicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self];
        
        areaPicker.hidden = YES;
        
    }
    if (areaPicker.hidden) {
        [areaPicker showInView:self.view ];
    }else{
        [_table showNormal];
    }
}


- (void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    if (picker.locate.district) {
        locationStr = [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
    }else{
        locationStr = [NSString stringWithFormat:@"%@ %@", picker.locate.state, picker.locate.city];
    }
    
    
    
    [_table reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:2]]  withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - save card

- (NSString *)mobiles
{
    NSMutableString *mobiles = [[NSMutableString alloc]initWithCapacity:[section1Arr count]];
    for (ParamForEditecard *paramPro in section1Arr) {
        if (paramPro.value && [paramPro.title isEqualToString:@"手机"]) {
            [mobiles appendFormat:@"%@%@", KHH_SEPARATOR, paramPro.value];
        }
    }
    if([mobiles hasPrefix:[NSString stringWithFormat:@"%@", KHH_SEPARATOR]]){
        [mobiles deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    return mobiles;
}

- (NSString *)phones
{
    NSMutableString *phones = [[NSMutableString alloc]initWithCapacity:[section1Arr count]];
    for (ParamForEditecard *paramPro in section1Arr) {
        if (paramPro.value && [paramPro.title isEqualToString:@"电话"]) {
            [phones appendFormat:@"%@%@", KHH_SEPARATOR, paramPro.value];
        }
    }
    if([phones hasPrefix:[NSString stringWithFormat:@"%@", KHH_SEPARATOR]]){
        [phones deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    return phones;
}

- (NSString *)faxs
{
    NSMutableString *faxs = [[NSMutableString alloc]initWithCapacity:[section1Arr count]];
    for (ParamForEditecard *paramPro in section1Arr) {
        if (paramPro.value && [paramPro.title isEqualToString:@"传真"]) {
            [faxs appendFormat:@"%@%@", KHH_SEPARATOR, paramPro.value];
        }
    }
    if([faxs hasPrefix:[NSString stringWithFormat:@"%@", KHH_SEPARATOR]]){
        [faxs deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    return faxs;
}

- (NSString *)mails
{
    NSMutableString *mails = [[NSMutableString alloc]initWithCapacity:[section1Arr count]];
    for (ParamForEditecard *paramPro in section1Arr) {
        if (paramPro.value && [paramPro.title isEqualToString:@"邮箱"]) {
            [mails appendFormat:@"%@%@", KHH_SEPARATOR, paramPro.value];
        }
    }
    if([mails hasPrefix:[NSString stringWithFormat:@"%@", KHH_SEPARATOR]]){
        [mails deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    return mails;
    
}

#pragma mark - value section2

- (NSString *)company
{
    for (ParamForEditecard *paramPro in section2Arr) {
        if (paramPro.value && [paramPro.title isEqualToString:@"公司"]) {
            return  paramPro.value;
        }
    }
    return @"";
}

- (NSString *)address
{
    NSString *strPro = locationStr?locationStr:@"";
    for (ParamForEditecard *paramPro in section2Arr) {
        if (paramPro.value && [paramPro.title isEqualToString:@"地址"]) {
            return  [NSString stringWithFormat:@"%@ %@",strPro,paramPro.value];
        }
    }
    return strPro;
}

- (NSString *)zipCode
{
    for (ParamForEditecard *paramPro in section2Arr) {
        if (paramPro.value && [paramPro.title isEqualToString:@"邮编"]) {
            return  paramPro.value;
        }
    }
    return @"";
}

- (void)toAddressCard
{
    if (locationStr) {
        if ([locationStr rangeOfString:@"国外"].location == 0) {
            NSArray *splitArr = [locationStr componentsSeparatedByString:@" "];
            icard.addressCountry = splitArr[1];
        }else{
            icard.addressCountry = @"中国";
            NSArray *splitArr = [locationStr componentsSeparatedByString:@" "];
            icard.addressProvince = splitArr[0];
            if ([splitArr count] == 2) {
                icard.addressCity = splitArr[0];
                icard.addressDistrict  = splitArr[1];
            }else{
                icard.addressCity = splitArr[1];
                icard.addressDistrict  = splitArr[2];
            }
        }
    }
    NSString *strPro = ((ParamForEditecard *)section2Arr[2]).value;
    icard.addressOther = strPro?strPro:@"";
    icard.addressZip = [self zipCode];
}

- (NSString *)companyEmail
{
    for (ParamForEditecard *paramPro in section2Arr) {
        if (paramPro.value && [paramPro.title isEqualToString:@"公司邮箱"]) {
            return  paramPro.value;
        }
    }
    return @"";
}

#pragma mark - value section3

- (NSString *)itemSection3:(NSString *)item
{
    for (ParamForEditecard *paramPro in section3Arr) {
        if (paramPro.value && [paramPro.title isEqualToString:item]) {
            return  paramPro.value;
        }
    }
    return @"";
}

- (void)toIcardSection3
{
    
    icard.web = [self itemSection3:@"网页"];
    icard.qq = [self itemSection3:@"QQ"];
    icard.msn = [self itemSection3:@"MSN"];
    icard.aliWangWang = [self itemSection3:@"旺旺"];
    icard.businessScope = [self itemSection3:@"业务范围"];
    icard.bankAccountBank = [self itemSection3:@"开户行"];
    icard.bankAccountNumber = [self itemSection3:@"银行帐号"];
    icard.bankAccountName = [self itemSection3:@"户名"];
    icard.moreInfo = [self itemSection3:@"其它信息"];
    
}
#pragma mark - validate

- (Boolean)validate:(NSString *)name mobiles:(NSString *)mobiles phones:(NSString *)phones  faxs:(NSString *)faxs mails:(NSString *)mails company:(NSString *)company address:(NSString *)address
{
    //姓名检查
    if (name.length <= 0) {
        [self warnAlertMessage:@"名片上的姓名为空!"];
        return NO;
    }
    
    // 对是否为空或格式进行判断，然后把手机，电话，传真，邮箱保存起来
    if (mobiles.length==0 && phones.length==0) {
        //[self showMessage:@"名片上的电话未空!请至少填写一个手机号码或者电话号码!" withTitile:nil];
        [self warnAlertMessage:@"名片上的电话未空!请至少填写一个手机号码或者电话号码!"];
        return NO;
    }
    
    if(company.length==0 && (address.length == 0 || [address isEqualToString:KhhMessageAddressEditNotice]) ){
        //[self showMessage:@"名片上的公司信息为空!请至少填写公司或地址中的一项!" withTitile:nil];
        [self warnAlertMessage:@"名片上的公司信息为空!请至少填写公司或地址中的一项!"];
        return NO;
    }
    
    //    //////////////////////validate//////////////////////
    //validate mobile
    for(NSString *str in [mobiles componentsSeparatedByString:KHH_SEPARATOR]){
        if(str.length>0 && ![str isValidMobilePhoneNumber]){
            //[self showMessage:@"手机格式错误!" withTitile:nil];
            [self warnAlertMessage:@"手机格式错误!!"];
            return NO;
        }
    }
    
    //    //validate phone
    for(NSString *str in [phones componentsSeparatedByString:KHH_SEPARATOR]){
        if(str.length>0 && ![str isValidTelephoneNUmber]){
            //[self showMessage:@"电话格式错误!" withTitile:nil];
            [self warnAlertMessage:@"电话格式错误!"];
            return NO;
        }
    }
    
    //validate fax
    for(NSString *str in [faxs componentsSeparatedByString:KHH_SEPARATOR]){
        if(str.length>0 && ![str isValidTelephoneNUmber]){
            //[self showMessage:@"传真格式错误!" withTitile:nil];
            [self warnAlertMessage:@"传真格式错误!"];
            return NO;
        }
    }
    
    //validate email
    for(NSString *str in [mails componentsSeparatedByString:KHH_SEPARATOR]){
        if(str.length>0 && ![str isValidEmail]){
            //[self showMessage:@"邮箱格式错误!" withTitile:nil];
            [self warnAlertMessage:@"邮箱格式错误!"];
            return NO;
        }
    }
    return YES;
}

- (void)rightBarButtonClick:(id)sender
{
    [self saveCardInfo];
}

- (void)saveCardInfo
{
    
    [self hiddenKeyboard];
    [_table setContentInset:UIEdgeInsetsMake(0,0,0,0)];   
    NSString *name = ((ParamForEditecard *)section0Arr[0]).value;
    name = name?name:@"";
    name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *mobiles = [self mobiles];
    NSString *phones = [self phones];
    NSString *faxs = [self faxs];
    NSString *mails = [self mails];
    
    NSString *company = [self company];
    NSString *address = [self address];
    
    if (![self validate:name mobiles:mobiles phones:phones faxs:faxs mails:mails company:company address:address]) {
        return;
    }
    //姓名去除前后空格
    
    NSString *job = ((ParamForEditecard *)section0Arr[1]).value;;
    
    // NSString *group = [_fieldValue objectAtIndex:2];
    icard = [[InterCard alloc]init];
    icard.name = name;
    icard.title = job?job:@"";
    icard.mobilePhone = mobiles;
    icard.telephone = phones;
    icard.fax = faxs;
    icard.email = mails;
    icard.templateID = @(1);
    [self toAddressCard];
    
    icard.companyEmail = [self companyEmail];
    icard.companyName = company;
    
    
    [self toIcardSection3];
    icard.cardType = kCardType_Person;
    icard.cardSource = kCardSource_Client_SelfBuild;
    icard.templateID = [NSNumber numberWithInt:1];
    icard.modelType = KHHCardModelTypePrivateCard;
    // id，version，userid,templateID付给InterCard，否则不能通过
    //    self.interCard.id = _glCard.id;
    //    self.interCard.version = _glCard.version;
    //    self.interCard.userID = _glCard.userID;
    //    self.interCard.templateID = _glCard.template.id;
    
#warning 20130114因项目时间紧，本地数据库未改动，添加的名片类型、名片来源需要在这里赋值
    //20121225
    //头像字段没考虑，所以保存后要及时同步一下
    // 保存到数据库或调用网络接口
    //为了避免保存失败，先给这个临时card给值 InterCard
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
   
    //    if ([_glCard isKindOfClass:[MyCard class]]) {
    //        //设置名片类型及名片来源
    //        self.interCard.cardType = kCardType_Person;
    //        self.interCard.cardSource = kCardSource_Person;
    //
    //        self.progressHud.labelText = KHHMessageModifyCard;
    //        [self.dataCtrl modifyMyCardWithInterCard:self.interCard];
    //    }else if ([_glCard isKindOfClass:[PrivateCard class]]){
    //        //设置名片类型及名片来源
    //        self.interCard.cardType = kCardType_Person;
    //        self.interCard.cardSource = kCardSource_Client_SelfBuild;
    //
    //        self.progressHud.labelText = KHHMessageModifyCard;
    //        [self.dataCtrl modifyPrivateCardWithInterCard:self.interCard];
    //    }else if (self.type == KCardViewControllerTypeNewCreate){
    //        //设置名片类型及名片来源
    //        self.interCard.cardType = kCardType_Person;
    //        self.interCard.cardSource = kCardSource_Client_SelfBuild;
    //
    //        //修改
    //        self.progressHud.labelText = KHHMessageCreateCard;
    //        //暂时这样写 templateID不确定
    //        self.interCard.templateID = self.cardTemp.id;
    //        //        NSLog(@"..%@",self.cardTemp);
    //        //        NSLog(@"..%@",self.interCard);
    //        [self.dataCtrl createPrivateCardWithInterCard:self.interCard];
    //        //[[NetClient sharedClient]CreatePrivateCard:self.interCard delegate:self];
    //    }
    if (_toEditCard) {
        icard.id = _toEditCard.id;
         _hud.labelText = @"修改名片...";
        [[KHHDataNew sharedData] doUpdateCard:icard delegate:self];
    }else{
         _hud.labelText = @"创建名片...";
        [[KHHDataNew sharedData] doAddCard:icard delegate:self];
    }
    
}

#pragma mark - add delegate

- (void)addCardForUISuccess:(NSDictionary *)dict
{
    [_hud hide:YES];
    icard.id =  dict[@"id"];
    [PrivateCard processIObject:icard];
    [[KHHDataNew sharedData] saveContext];
    if (_addCardSuccess) {
        _addCardSuccess();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addCardForUIFailed:(NSDictionary *)dict
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"创建失败" message:dict[kInfoKeyErrorMessage] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    [_hud hide:YES];
}

#pragma mark - update delegate
- (void)updateCardForUISuccess
{
    [_hud hide:YES];
    
    [PrivateCard processIObject:icard];
    [[KHHDataNew sharedData] saveContext];
    if (_updateCardSuccess) {
        _updateCardSuccess();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateCardForUIFailed:(NSDictionary *)dict
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"修改失败" message:dict[kInfoKeyErrorMessage] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    [_hud hide:YES];
}
@end
