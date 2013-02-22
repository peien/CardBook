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

#import "KHHFullFrameController.h"
#import "KHHUpperView.h"
#import "KHHForWhereCell.h"
#import "KHHBMapLocationController.h"
#import "KHHHomeViewController.h"
#import "CustomBadge.h"
#import "KHHCalendarViewController.h"
#import "MBProgressHUD.h"

#import "KHHDataNew+Card.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "KHHActionSheet.h"


@interface KHHPlanViewController ()
{
    
    CGRect rectForKey;
    NSMutableArray *inputsForKeyboard;
    
    UIImageView *rotaView;
    UIButton *objectBtn;
    NSMutableArray *cardsArr;
    
    BMKAddrInfo *_addrInfo;
    NSMutableDictionary *_dicTemp;
    MBProgressHUD *_hud;
    
    //for edit for imgs
    NSMutableDictionary *_iPlan;
    
    //for collect sign
    planCollectSign _type;
}
@end

@implementation KHHPlanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil

{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        table = [[KHHInputTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        table.delegate = self;
        table.dataSource = self;
        table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        table.hiddenDelgate = self;
        
        // table.backgroundView = nil;
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.datePicker = nil;
    self.memoPicker = nil;
    self.remindPicker = nil;
    self.areaPicker = nil;
    self.paramDic = nil;
    
    _dicTemp = nil;
    if (inputsForKeyboard) {
        [inputsForKeyboard removeAllObjects];
        inputsForKeyboard = nil;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    self.view.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-100);
    //self.title =  @"新建计划";
    [self doUIRightButton];
    // NSLog(@"%f",);
    
    NSLog(@"%f,%f,%f,%f,%f,%f",self.navigationController.view.frame.size.height,self.view.frame.size.height,self.navigationController.view.frame.origin.y,self.view.frame.origin.y,self.navigationController.navigationBar.frame.size.height,self.navigationController.navigationBar.frame.origin.y);
    table.frame =  CGRectMake(0, 0, 320, self.view.bounds.size.height-44-50);
    
    inputsForKeyboard = [[NSMutableArray alloc]initWithCapacity:10];
    [self.view addSubview:table];
    
    if (!_dicTemp) {
        _dicTemp = [[NSMutableDictionary alloc]init];
        [_dicTemp setValue:[KHHDateUtil nowDate] forKey:@"date"];
    }
    
    if (![_dicTemp objectForKey:@"date"]) {
        [_dicTemp setValue:[KHHDateUtil nowDate] forKey:@"date"];
    }
    
    if (![_dicTemp objectForKey:@"time"]) {
        [_dicTemp setValue:[KHHDateUtil strTimeFromDate:[NSDate new]] forKey:@"time"];
    }
    
    
    KHHUpperView *upView = [[KHHUpperView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-44-50, 320, 50)];
    [self.view addSubview:upView];
    //    upView.upperBtn.enabled =  [self where] == -1||[_dicTemp objectForKey:@"where"]?YES:NO;
    [upView.upperBtn addTarget:self action:@selector(uper) forControlEvents:UIControlEventTouchUpInside];
    
    //weakself = self;
    
}


- (void)doUIRightButton
{
    [self.rightBtn setTitle:@"日历" forState:0];
    [self.rightBtn setTitle:@"日历" forState:1];
}

- (void)rightBarButtonClick:(id)sender
{
    KHHCalendarViewController *calVC = [[KHHCalendarViewController alloc] initWithNibName:nil bundle:nil];
    calVC.card = [[KHHDataNew sharedData]allMyCards][0];
    [self.navigationController pushViewController:calVC animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.datePicker||self.areaPicker||self.memoPicker||self.remindPicker) {
        [self cancelLocatePicker];
    }
    
}

- (void)dateChanged
{
    [_dicTemp setValue:[KHHDateUtil strFromDate:[_datePicker date]] forKey:@"date"];
    [_dicTemp setValue:[KHHDateUtil strTimeFromDate:[_datePicker date]] forKey:@"time"];
    [table reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:[self date] inSection:0],[NSIndexPath indexPathForRow:[self time] inSection:0],nil]  withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self cancelLocatePicker];
    NSLog(@"MemoryWarning");
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _paramDic.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    UITableViewCell *cell;
    if (indexPath.row == [self target]) {
        CellIdentifier = @"Target";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[KHHTargetCell alloc]init];
            ((KHHTargetCell *)cell).headStr = @"对象";
            ((KHHTargetCell *)cell).placeStr = @"请选择拜访对象";
            ((KHHTargetCell *)cell).field.delegate = self;
            ((KHHTargetCell *)cell).field.tag = 10020;
            
            
        }
        if ([_dicTemp objectForKey:@"target"]) {
            ((KHHTargetCell *)cell).field.text = [_dicTemp objectForKey:@"target"];
        }
        {
            objectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            objectBtn.frame = CGRectMake(265, 5, 35, 35);
            [objectBtn addTarget:self action:@selector(objectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [objectBtn setBackgroundImage:[UIImage imageNamed:@"contact_select.png"] forState:UIControlStateNormal];
            [cell addSubview:objectBtn];
        }
        
        
    }
    if (indexPath.row == [self date]||indexPath.row  == [self time]) {
        CellIdentifier = @"Date";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[KHHDateCell alloc]init];
        }
        if (indexPath.row == [self date]) {
            ((KHHDateCell *)cell).headStr = @"日期";
            if ([_dicTemp objectForKey:@"date"]) {
                ((KHHDateCell *)cell).dateStr = [_dicTemp objectForKey:@"date"];
            }else{
                ((KHHDateCell *)cell).dateStr = [KHHDateUtil nowDate];
            }
        }
        if (indexPath.row == [self time]) {
            ((KHHDateCell *)cell).headStr = @"时间";
            if ([_dicTemp objectForKey:@"time"]) {
                ((KHHDateCell *)cell).dateStr = [_dicTemp objectForKey:@"time"];
            }else{
                ((KHHDateCell *)cell).dateStr = [KHHDateUtil strTimeFromDate:[NSDate new]];
            }
        }
        
        
    }
    if (indexPath.row == [self local0]) {
        CellIdentifier = @"Location";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[KHHLocationCell alloc]init];
        }
        ((KHHLocationCell *)cell).headStr = @"位置";
        ((KHHLocationCell *)cell).field.delegate = self;
        ((KHHLocationCell *)cell).field.tag = 10021;
        if ([_dicTemp objectForKey:@"location"]) {
            ((KHHLocationCell *)cell).locationStr = [_dicTemp objectForKey:@"location"];
        }else{
            ((KHHLocationCell *)cell).locationStr = @"请选择省市地";
        }
        if ([_dicTemp objectForKey:@"street"]) {
            ((KHHLocationCell *)cell).street = [_dicTemp objectForKey:@"street"];
        }
        
    }
    if (indexPath.row == [self img]) {
        CellIdentifier = @"Image";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[KHHImageCell alloc]init];
        }
        ((KHHImageCell *)cell).headStr = @"图片";
        [((KHHImageCell *)cell).imageBtn addTarget:self action:@selector(addImg) forControlEvents:UIControlEventTouchUpInside];
        
        if ([_dicTemp objectForKey:@"imgArr"]) {
            NSArray* imgArr = [_dicTemp objectForKey:@"imgArr"];
            ((KHHImageCell *)cell).imgArr = imgArr;
        }
    }
    if (indexPath.row == [self memo]||indexPath.row == [self remind]) {
        CellIdentifier = @"Memo";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[KHHMemoCell alloc]init];
        }
        if (indexPath.row == [self memo]) {
            
            ((KHHMemoCell *)cell).headStr = @"备注";
            ((KHHMemoCell *)cell).indexpath = indexPath;
            ((KHHMemoCell *)cell).pickerDelegate = self;
            if ([_dicTemp objectForKey:@"memo"]) {
                ((KHHMemoCell *)cell).butTitle = [_dicTemp objectForKey:@"memo"];
            }else{
                ((KHHMemoCell *)cell).butTitle = @"请选择";
            }
        }
        if (indexPath.row == [self remind]) {
            ((KHHMemoCell *)cell).headStr = @"提醒";
            ((KHHMemoCell *)cell).indexpath = indexPath;
            ((KHHMemoCell *)cell).pickerDelegate = self;
            if ([_dicTemp objectForKey:@"remind"]) {
                ((KHHMemoCell *)cell).butTitle = [_dicTemp objectForKey:@"remind"];
            }else{
                ((KHHMemoCell *)cell).butTitle = @"不提醒";
            }
            
        }
    }
    if (indexPath.row == [self descript]) {
        CellIdentifier = @"Target";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[KHHTargetCell alloc]init];
            ((KHHTargetCell *)cell).headStr = @"说明";
            ((KHHTargetCell *)cell).placeStr = @"请输入文字记录(400字内)";
            ((KHHTargetCell *)cell).field.delegate = self;
            ((KHHTargetCell *)cell).field.tag = 10022;
        }
        if ([_dicTemp objectForKey:@"descript"]) {
            ((KHHTargetCell *)cell).field.text = [_dicTemp objectForKey:@"descript"];
        }
    }
    
    if (indexPath.row == [self where]) {
        CellIdentifier = @"where";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[KHHForWhereCell alloc]init];
            KHHForWhereCell *cellPro = (KHHForWhereCell *)cell;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateLocation:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [cellPro.rotaView addGestureRecognizer:tap];
            rotaView = cellPro.rotaView;
            if (![_dicTemp objectForKey:@"where"]) {
                [self updateLocation:tap];
            }
        }
        if ([_dicTemp objectForKey:@"where"]) {
            ((KHHForWhereCell *)cell).locStrPro = [_dicTemp objectForKey:@"where"];
        }
    }
    
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)updateLocation:(UITapGestureRecognizer *)sender
{
    [rotaView startAnimating];
    
    [[KHHBMapLocationController sharedController] doGetLocation:^(BMKAddrInfo *addrInfo) {
        // NSLog(@"locStr%@",_addrInfo.strAddr);
        _addrInfo = addrInfo;
        [_dicTemp setValue:addrInfo.strAddr forKey:@"where"];
        [table reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self where] inSection:0]]  withRowAnimation:UITableViewRowAnimationNone];
        [rotaView stopAnimating];
        
    } fail:^{
        [rotaView stopAnimating];
        
    }];
}

#pragma mark - buttons actions

- (void)addImg{
    [table showNormal];
    [self hiddenKeyboard];
    if ([_dicTemp objectForKey:@"imgArr"]&&[[_dicTemp objectForKey:@"imgArr"] count]>=4) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"最多4张图片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:nil, nil];
    
    [actSheet addButtonWithTitle:@"本地相册"];
    [actSheet addButtonWithTitle:@"拍照"];
    actSheet.tag = 10010;
    [actSheet showInView:self.view];
    
}

- (void)showLarge:(UIView *)img
{
    KHHFullFrameController *fullVC = [[KHHFullFrameController alloc] initWithNibName:nil bundle:nil];
    fullVC.image = ((KHHImgViewInCell *)img).image;
    [self.navigationController pushViewController:fullVC animated:YES];
}

- (void)doDelete:(UIView *)img
{
    KHHActionSheet *actSheet = [[KHHActionSheet alloc] initWithTitle:@""
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:nil, nil];
    [actSheet.dic setValue:img forKey:@"img"];
    [actSheet.dic setValue:((KHHImgViewInCell *)img).attachmentId forKey:@"attachmentId"];
    [actSheet addButtonWithTitle:@"删除图片"];
    actSheet.tag = 10011;
    [actSheet showInView:self.view];
}

#pragma mark - textFiled delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 10020) {
        if ([string isEqualToString:@""]) {
            textField.text = @"";
            [cardsArr removeAllObjects];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [table showNormal];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
    if (textField.tag == 10022) {
        [_dicTemp setValue:textField.text forKey:@"descript"];
    }else if(textField.tag == 10020){
        [_dicTemp setValue:textField.text forKey:@"target"];
    }else{
        [_dicTemp setValue:textField.text forKey:@"street"];
    }
    
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
    if (!self.remindPicker.hidden) {
        [self.remindPicker cancelPicker:NO];
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
    
    [self.remindPicker cancelPicker:YES];
    
    self.remindPicker = nil;
}

- (void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    if (picker.locate.district) {
        [_dicTemp setValue:[NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district] forKey:@"location"];
    }else{
        [_dicTemp setValue:[NSString stringWithFormat:@"%@ %@", picker.locate.state, picker.locate.city] forKey:@"location"];
    }
    
    [table reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self local0] inSection:0]]  withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSLog(@"%d",indexPath.row);
    
    if (indexPath.row == [self date]||indexPath.row == [self time]||indexPath.row == [self local0]||indexPath.row == [self memo]||indexPath.row == [self remind]) {
        rectForKey = [tableView cellForRowAtIndexPath:indexPath].frame;
        rectForKey = CGRectMake(rectForKey.origin.x, rectForKey.origin.y+30, rectForKey.size.width, rectForKey.size.height);
        [table goToInsetForKeyboard:rectForKey];
    }
    
    if (indexPath.row == [self img]) {
        [self hiddenKeyboard];
        [table showNormal];
    }
    if (indexPath.row == [self date]||indexPath.row == [self time]) {
        [self hiddenKeyboard];
        if (!self.datePicker) {
            self.datePicker = [[ KHHDatePicker alloc] initWithFrame:CGRectMake(0.0,300-200.0,320.0,200.0)];
            
            [self.datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
            self.datePicker.hidden = YES;
            [self addRes:_datePicker];
        }
        if (self.datePicker.hidden) {
            [self.datePicker showInView:self.view ];
        }else{
            [table showNormal];
        }
        
        return;
        
    }
    if (indexPath.row == [self local0]) {
        
        [self hiddenKeyboard];
        if (!self.areaPicker) {
            self.areaPicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self];
            self.areaPicker.hidden = YES;
            [self addRes:_areaPicker];
        }
        if (self.areaPicker.hidden) {
            [self.areaPicker showInView:self.view ];
        }else{
            [table showNormal];
        }
        return;
    }
    
    if (indexPath.row == [self memo] ) {
        [self hiddenKeyboard];
        if (!self.memoPicker) {
            self.memoPicker = [[ KHHMemoPicker alloc] initWithFrame:CGRectMake(0.0,460-200.0,320.0,200.0)];
            self.memoPicker.hidden = YES;
            self.memoPicker.tag = 10030;
            self.memoPicker.memoArr = [_paramDic valueForKeyPath:@"memo.titles"];
            __block KHHPlanViewController *weakself = self;
            self.memoPicker.showTitle = ^(NSString *title, int tag){
                [weakself showTitle:title tag:tag];
            };
            [self addRes:_memoPicker];
        }
        if (self.memoPicker.hidden) {
            [self.memoPicker showInView:self.view ];
        }else{
            [table showNormal];
        }
        
        return;
    }
    if (indexPath.row == [self remind]) {
        [self hiddenKeyboard];
        if (!self.remindPicker) {
            self.remindPicker = [[ KHHMemoPicker alloc] initWithFrame:CGRectMake(0.0,460-200.0,320.0,200.0)];
            self.remindPicker.hidden = YES;
            self.remindPicker.memoArr = [_paramDic valueForKeyPath:@"remind.titles"];
            self.remindPicker.tag = 10031;
            __block KHHPlanViewController *weakself = self;
            self.remindPicker.showTitle = ^(NSString *title, int tag){
                [weakself showTitle:title tag:tag];
            };
            [self addRes:_remindPicker];
        }
        if (self.remindPicker.hidden) {
            [self.remindPicker showInView:self.view ];
        }else{
            [table showNormal];
        }
        
        return;
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self local0]) {
        return 60;
    }
    if (indexPath.row == [self img]) {
        return 60;
    }
    return 45;
}

#pragma mark - imagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    if (_iPlan) {
        [self dismissModalViewControllerAnimated:YES];
        _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        _hud.labelText = @"图片添加...";
        [[KHHDataNew sharedData]doAddImg:_iPlan[@"planId"] image:image delegate:self];
        _iPlan[@"image"] = image;
        return;
    }
    
    [self imgArrPro:image URL:nil attachmentId:nil];
    
    [table reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self img] inSection:0]]  withRowAnimation:UITableViewRowAnimationNone];
    [self dismissModalViewControllerAnimated:YES];
    
}


- (void)imgArrPro:(UIImage *)image URL:(NSURL *)url attachmentId:(NSString *)attachmentId
{
    NSMutableArray *imgArr ;
    if ([_dicTemp objectForKey:@"imgArr"]) {
        imgArr = [_dicTemp objectForKey:@"imgArr"];
    }else{
        imgArr = [[NSMutableArray alloc]initWithCapacity:4];
        [_dicTemp setValue:imgArr forKey:@"imgArr"];
    }
    KHHImgViewInCell *img = [[KHHImgViewInCell alloc]init];
    if (image) {
        [img setImage:image];
        
    }
    if (url) {
        //todo for complete
        [img setImageWithURL:url placeholderImage:[UIImage imageNamed:@"ic_shuaxin1"]];
        img.attachmentId = attachmentId;
    }
    
    img.touchDelegate = self;
    [imgArr addObject:img];
}

#pragma mark - actionsheet delegate



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 10011) {
        if (buttonIndex == 1 ){
            
            if (_iPlan) {
                _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                _hud.labelText = @"图片删除...";
                _iPlan[@"imgToDele"] = [((KHHActionSheet *)actionSheet).dic valueForKey:@"img"];
                [[KHHDataNew sharedData]doDeleteImg:_iPlan[@"planId"] attachmentId:[((KHHActionSheet *)actionSheet).dic valueForKey:@"attachmentId"] delegate:self];
                return;
            }
            
            [[_dicTemp objectForKey:@"imgArr"]removeObject:[((KHHActionSheet *)actionSheet).dic valueForKey:@"img"] ] ;
            [table reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self img] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        return;
    }
    
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


#pragma mark - memoPicker delegate
- (void)selectPicker:(NSIndexPath *)indexPath
{
    
    rectForKey = [table cellForRowAtIndexPath:indexPath].frame;
    rectForKey = CGRectMake(rectForKey.origin.x, rectForKey.origin.y+30, rectForKey.size.width, rectForKey.size.height);
    [table goToInsetForKeyboard:rectForKey];
    
    if (indexPath.row == [self memo] ) {
        [self hiddenKeyboard];
        if (!self.memoPicker) {
            self.memoPicker = [[ KHHMemoPicker alloc] initWithFrame:CGRectMake(0.0,H460-200.0,320.0,200.0)];
            self.memoPicker.hidden = YES;
            self.memoPicker.memoArr = [_paramDic valueForKeyPath:@"memo.titles"];
            self.memoPicker.tag = 10030;
            __block KHHPlanViewController *weakself = self;
            self.memoPicker.showTitle = ^(NSString *title, int tag){
                [weakself showTitle:title tag:tag];
            };
            [self addRes:_memoPicker];
        }
        if (self.memoPicker.hidden) {
            [self.memoPicker showInView:self.view ];
        }else{
            [table showNormal];
        }
        
        return;
    }
    if (indexPath.row == [self remind]) {
        [self hiddenKeyboard];
        if (!self.remindPicker) {
            self.remindPicker = [[ KHHMemoPicker alloc] initWithFrame:CGRectMake(0.0,H460-200.0,320.0,200.0)];
            self.remindPicker.memoArr = [_paramDic valueForKeyPath:@"remind.titles"];
            self.remindPicker.hidden = YES;
            __block KHHPlanViewController *weakself = self;
            self.remindPicker.showTitle = ^(NSString *title, int tag){
                [weakself showTitle:title tag:tag];
            };
            self.remindPicker.tag = 10031;
            [self addRes:_remindPicker];
        }
        if (self.remindPicker.hidden) {
            [self.remindPicker showInView:self.view ];
        }else{
            [table showNormal];
        }
        
        return;
    }
}

- (void)showTitle:(NSString *)title tag:(int)tag
{
    if(tag == 10030){
        [_dicTemp setValue:title forKey:@"memo"];
        [table reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self memo] inSection:0]]  withRowAnimation:UITableViewRowAnimationNone];
    }
    if(tag == 10031){
        [_dicTemp setValue:title forKey:@"remind"];
        [table reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self remind] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
}

#pragma mark - to select person
- (void)objectBtnClick:(id)sender
{
    KHHHomeViewController *homeVC = [[KHHHomeViewController alloc] initWithNibName:nil bundle:nil];
    homeVC.isNormalSearchBar = YES;
    
    homeVC.appendCardName = ^(Card *card){
        if (!cardsArr) {
            cardsArr = [[NSMutableArray alloc]init];
        }
        if ([cardsArr containsObject:card]) {
            return;
        }
        
        [cardsArr addObject:card];
        NSString *strPro2;
        if ([_dicTemp objectForKey:@"target"]&&![[_dicTemp objectForKey:@"target"] isEqualToString:@""]) {
            strPro2 = [_dicTemp objectForKey:@"target"];
            if (![strPro2 isEqualToString:@""]&&![strPro2 hasSuffix:@";"]) {
                strPro2 = [NSString stringWithFormat:@"%@;",strPro2];
            }
            
        }
        
        
        NSMutableString *strPro = [[NSMutableString alloc]init];
        NSString *name = [NSString stringByFilterNilFromString:card.name];
        if (name.length) {
            [strPro appendString:[NSString stringWithFormat:@"%@",name]];
        }else {
            //名称为空时添加一个空格作为标识
            [strPro appendString:@" "];
        }
        if (card.company && card.company.name && card.company.name.length > 0) {
            NSString *company = [NSString stringByFilterNilFromString:card.company.name];
            if (company.length > 0) {
                [strPro appendString:[NSString stringWithFormat:@"(%@);",company]];
            }
        }
        
        [_dicTemp setValue:[NSString stringWithFormat:@"%@%@",strPro2?strPro2:@"",strPro] forKey:@"target"];
        
        [table reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:[self target] inSection:0],nil]  withRowAnimation:UITableViewRowAnimationNone];
    };
    // homeVC.visitVC = self;
    [self.navigationController pushViewController:homeVC animated:YES];
}

#pragma mark - to init dicTemp

- (void)set_dicTempTarget:(Card *)card
{
    if (!cardsArr) {
        cardsArr = [[NSMutableArray alloc]init];
    }
    if ([cardsArr containsObject:card]) {
        return;
    }
    [cardsArr addObject:card];
    if (!_dicTemp) {
        _dicTemp = [[NSMutableDictionary alloc]init];
    }
    if (card.company && card.company.name && card.company.name.length > 0){
        [_dicTemp setValue: [NSString stringWithFormat:@"%@(%@);",card.name,card.company.name] forKey:@"target"];
        return;
    }
    [_dicTemp setValue: [NSString stringWithFormat:@"%@;",card.name] forKey:@"target"];
    //    [table reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:[self target] inSection:0],nil]  withRowAnimation:UITableViewRowAnimationNone];
    
}

- (void)setTargetStr:(NSString *)target cardsArr:(NSArray *)cardsArrPro
{
    
    
    if (!_dicTemp) {
        _dicTemp = [[NSMutableDictionary alloc]init];
    }
    
    if (target) {
        [_dicTemp setValue: target forKey:@"target"];
    }
    
    if (cardsArrPro) {
        if (!cardsArr) {
            cardsArr = [[NSMutableArray alloc]init];
        }
        [cardsArr setArray:cardsArrPro];
    }
    
    
}

- (void)setSchedule:(Schedule *)schedulePro type:(planCollectSign)type
{
    _type = type;
    
    if(!_iPlan)
    {
        _iPlan = [[NSMutableDictionary alloc]initWithCapacity:4];
    }
    [_iPlan setValue:[NSString stringWithFormat:@"%lld",schedulePro.idValue] forKey:@"planId"];
    
    if (!_dicTemp) {
        _dicTemp = [[NSMutableDictionary alloc]init];
    }
    [_dicTemp setValue:schedulePro.customer forKey:@"target"];
    if (!cardsArr) {
        cardsArr = [[NSMutableArray alloc]init];
    }
    [cardsArr setArray:[schedulePro.targets allObjects]];
    if (schedulePro.plannedDate) {
        [_dicTemp setValue:[KHHDateUtil strFromDate:schedulePro.plannedDate] forKey:@"date"];
        [_dicTemp setValue:[KHHDateUtil strTimeFromDate:schedulePro.plannedDate] forKey:@"time"];
    }
    
    if ([[schedulePro.images allObjects] count]>0) {
        for (Image *imgDB in [schedulePro.images allObjects]) {
            [self imgArrPro:nil URL:[NSURL URLWithString:imgDB.url] attachmentId:[NSString stringWithFormat:@"%lld",imgDB.idValue]];
        }
    }
    if (schedulePro.address) {
        if (!schedulePro.address.other) {
             [_dicTemp setValue:[NSString stringWithFormat:@"%@ %@", schedulePro.address.province, schedulePro.address.city] forKey:@"location"];
        }else{
            [_dicTemp setValue:[NSString stringWithFormat:@"%@ %@", schedulePro.address.province, schedulePro.address.city] forKey:@"location"];
            _dicTemp[@"street"] = schedulePro.address.other;
        }
        
    }
    if (schedulePro.content) {
        _dicTemp[@"descript"] = schedulePro.content;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

#pragma mark - just self use

- (int)target
{
    if ([_paramDic valueForKeyPath:@"target"]) {
        return [[_paramDic valueForKeyPath:@"target"] integerValue];
    }
    return -1;
}

- (int)date
{
    if ([_paramDic valueForKeyPath:@"date"]) {
        return [[_paramDic valueForKeyPath:@"date"] integerValue];
    }
    return -1;
}

- (int)time
{
    if ([_paramDic valueForKeyPath:@"time"]) {
        return [[_paramDic valueForKeyPath:@"time"] integerValue];
    }
    return -1;
}

- (int)local0
{
    if ([_paramDic valueForKeyPath:@"local0"]) {
        return [[_paramDic valueForKeyPath:@"local0"] integerValue];
    }
    return -1;
}


- (int)img
{
    if ([_paramDic valueForKeyPath:@"img"]) {
        return [[_paramDic valueForKeyPath:@"img"] integerValue];
    }
    return -1;
}

- (int)memo
{
    if ([_paramDic valueForKeyPath:@"memo"]) {
        return [[_paramDic valueForKeyPath:@"memo.row"] integerValue];
    }
    return -1;
}

- (int)remind
{
    if ([_paramDic valueForKeyPath:@"remind"]) {
        return [[_paramDic valueForKeyPath:@"remind.row"] integerValue];
    }
    return -1;
}

- (int)descript
{
    if ([_paramDic valueForKeyPath:@"descript"]) {
        return [[_paramDic valueForKeyPath:@"descript"] integerValue];
    }
    return -1;
}

- (int)where
{
    if ([_paramDic valueForKeyPath:@"where"]) {
        return [[_paramDic valueForKeyPath:@"where"] integerValue];
    }
    return -1;
}


#pragma mark - for uper delegate



- (void)uper
{
    if ([self target]!=-1&&![[_dicTemp objectForKey:@"target"] length]) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"上传失败" message:@"客户不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    NSString * strPro = ((NSString *)[_dicTemp objectForKey:@"target"]);
    if(![[strPro substringFromIndex:[strPro length]-1] isEqualToString:@";"]) {
        [_dicTemp setValue:[NSString stringWithFormat:@"%@;",strPro] forKey:@"target"];
        
    }
    
    if ([self descript]!=-1&&![[_dicTemp objectForKey:@"descript"] length]) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"上传失败" message:@"说明不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if ([self where]!=-1&&!_dicTemp[@"where"]) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"上传失败" message:@"请完成定位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    InterPlan *iplan = [[InterPlan alloc]init];
    
    iplan.planTime = [NSString stringWithFormat:@"%@ %@:00",[_dicTemp objectForKey:@"date"],[_dicTemp objectForKey:@"time"]];
    iplan.cardsArr = cardsArr;
    
    iplan.customerName = [_dicTemp objectForKey:@"target"];
    iplan.content = [_dicTemp objectForKey:@"descript"];
    if (!_iPlan) {
        iplan.imgViews = [_dicTemp objectForKey:@"imgArr"];
    }
    iplan.remindDate = [_dicTemp objectForKey:@"remind"];
    iplan.localStr = [_dicTemp objectForKey:@"location"];
    iplan.address = [_dicTemp objectForKey:@"street"];
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _hud.labelText = @"正在上传...";
    
    if (_type == collect) {
        iplan.id = [NSNumber numberFromString:_iPlan[@"planId"]];
        iplan.addrInfo = _addrInfo;
        iplan.finished = @"true";
        [[KHHDataNew sharedData] doUpdatePlan:iplan delegate:self];
        return;
    }
    if (_iPlan) {
        iplan.id = [NSNumber numberFromString:_iPlan[@"planId"]];
        [[KHHDataNew sharedData] doUpdatePlan:iplan delegate:self];
        return;
    }
    [[KHHDataNew sharedData] doAddPlan:iplan  delegate:self];
    NSLog(@"!!!!!enable");
}

- (void)addPlanForUISuccess
{
    [_hud hide:YES];
    if (_uperSuccess) {
        _uperSuccess();
    }
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"success");
}
- (void)addPlanForUIFailed:(NSDictionary *)dict
{
    [_hud hide:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"上传失败" message:dict[kInfoKeyErrorMessage] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    NSLog(@"Failed");
}

- (void)updatePlanForUISuccess
{
    [_hud hide:YES];
    if (_uperSuccess) {
        _uperSuccess();
    }
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"success");
}
- (void)updatePlanForUIFailed:(NSDictionary *)dict
{
    [_hud hide:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"修改计划失败" message:dict[kInfoKeyErrorMessage] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    NSLog(@"Failed");
}


- (void)deletePlanImgForUISuccess
{
    [_hud hide:YES];
    if (_iPlan) {
        [[_dicTemp objectForKey:@"imgArr"] removeAllObjects];
        for (Image *imgDB in [((Schedule *)[Schedule objectByID:[NSNumber numberFromString:_iPlan[@"planId"]] createIfNone:NO]).images allObjects]) {
            [self imgArrPro:nil URL:[NSURL URLWithString:imgDB.url] attachmentId:[NSString stringWithFormat:@"%lld",imgDB.idValue]];
        }
    }else{
        [[_dicTemp objectForKey:@"imgArr"]removeObject:_iPlan[@"imgToDele"] ] ;
    }
    [table reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self img] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)deletePlanImgForUIFailed:(NSDictionary *)dict
{
    [_hud hide:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"图片删除失败" message:dict[kInfoKeyErrorMessage] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

- (void)addPlanImgForUISuccess
{
    
    [_hud hide:YES];
    if (_iPlan) {
        [_dicTemp[@"imgArr"] removeAllObjects];
        for (Image *imgDB in [((Schedule *)[Schedule objectByID:[NSNumber numberFromString:_iPlan[@"planId"]] createIfNone:NO]).images allObjects]) {
            [self imgArrPro:nil URL:[NSURL URLWithString:imgDB.url] attachmentId:[NSString stringWithFormat:@"%lld",imgDB.idValue]];
        }
    }else{
        [self imgArrPro:_iPlan[@"image"] URL:nil attachmentId:nil];
    }
    
    [table reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self img] inSection:0]]  withRowAnimation:UITableViewRowAnimationNone];
    
}

- (void)addPlanImgForUIFailed:(NSDictionary *)dict
{
    [_hud hide:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"图片添加失败" message:dict[kInfoKeyErrorMessage] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

@end




