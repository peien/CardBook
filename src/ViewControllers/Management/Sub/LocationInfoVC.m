//
//  LocationInfoVC.m
//  CardBook
//
//  Created by 王国辉 on 12-8-9.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "LocationInfoVC.h"
#import <CoreLocation/CoreLocation.h>
#import "FootPrintViewController.h"
#import "KHHShowHideTabBar.h"
#import "KHHAddImageCell.h"
#import "KHHFullFrameController.h"
#import "KHHNetworkAPIAgent+EnterpriseManagement.h"
#import "KHHLocationController.h"
#import "MBProgressHUD.h"
#import "KHHData+UI.h"
#import "Card.h"
#import "Address.h"
#import "ICheckIn.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


#define UPDATE_LOCATION_BTN_TAG     4401
#define TEXTFIELD_DATE_TAG          5501
#define TEXTFIELD_TIME_TAG          5502
#define TEXTFIELD_NOTE_TAG          5503
#define TEXTFIELD_LOCATION_TAG      5504

@interface LocationInfoVC ()<UIActionSheetDelegate,UINavigationControllerDelegate,
                            UIImagePickerControllerDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIImageView       *imgview;
@property (assign, nonatomic) int               currentTag;
@property (assign, nonatomic) int               index;
@property (strong, nonatomic) NSArray           *imageArray;
@property (strong, nonatomic) UIImageView       *updateImageView;
@property (strong, nonatomic) UIImageView       *tapImgview;
@property (strong, nonatomic) NSString          *date;
@property (strong, nonatomic) NSString          *time;
@property (strong, nonatomic) KHHData           *dataCtrl;
@property (strong, nonatomic) Card              *card;
@property (strong, nonatomic) ICheckIn          *checkIn;
@property (strong, nonatomic) NSNumber          *locationLatitude;
@property (strong, nonatomic) NSNumber          *locationLongitude;
@property (assign, nonatomic) bool              isFirstLocation;
@property (strong, nonatomic) NSString          *address;
@property (strong, nonatomic) CLPlacemark       *placeMark;

@end

@implementation LocationInfoVC
@synthesize theTable = _theTable;
@synthesize imgArray = _imgArray;
@synthesize imgview = _imgview;
@synthesize currentTag = _currentTag;
@synthesize index = _index;
@synthesize imageArray;
@synthesize updateImageView;
@synthesize tapImgview;
@synthesize date;
@synthesize time;
@synthesize dataCtrl;
@synthesize card;
@synthesize checkIn;
@synthesize locationLatitude;
@synthesize locationLongitude;
@synthesize isFirstLocation;
@synthesize address;
@synthesize placeMark;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"签到", nil);
        
        self.rightBtn.hidden = YES;
        self.dataCtrl = [KHHData sharedData];
        self.card = [[self.dataCtrl allMyCards] lastObject];
        self.checkIn = [[ICheckIn alloc] initWithCard:card];
    }
    return self;
}

- (void)rightBarButtonClick:(id)sender
{
//    FootPrintViewController *footVC = [[FootPrintViewController alloc] initWithNibName:@"FootPrintViewController" bundle:nil];
//    [self.navigationController pushViewController:footVC animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.isFirstLocation = YES;
    [self getLocalAddress];
    self.view.backgroundColor = [UIColor colorWithRed:241 green:238 blue:232 alpha:1.0 ];
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
    footView.backgroundColor = [UIColor clearColor];
    UIButton *takePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    takePhotoBtn.frame = CGRectMake(40, 35, 240, 37);
    [takePhotoBtn setBackgroundImage:[[UIImage imageNamed:@"tongbu_normal.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 8, 0, 8)] forState:UIControlStateNormal];
    [takePhotoBtn setTitle:@"我要签到" forState:UIControlStateNormal];
    takePhotoBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [takePhotoBtn addTarget:self action:@selector(uploadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:takePhotoBtn];
    _theTable.tableFooterView = footView;
    _imgArray = [[NSMutableArray alloc] init];
    self.imageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"ic_shuaxin1.png"],
                                                [UIImage imageNamed:@"ic_shuaxin2.png"],
                                                [UIImage imageNamed:@"ic_shuaxin3.png"],
                                                [UIImage imageNamed:@"ic_shuaxin4.png"],
                                                [UIImage imageNamed:@"ic_shuaxin5.png"],
                                                [UIImage imageNamed:@"ic_shuaxin6.png"],
                       nil];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _theTable = nil;
    _imgArray = nil;
    _imgview = nil;
    self.imageArray = nil;
    self.updateImageView = nil;
    self.tapImgview = nil;
    self.date = nil;
    self.time = nil;
    self.dataCtrl = nil;
    self.card = nil;
    self.locationLatitude = nil;
    self.locationLongitude = nil;
    self.address = nil;
    self.placeMark = nil;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [KHHShowHideTabBar hideTabbar];
    [self getCurrentDate];
}
//获取现在时间
- (void)getCurrentDate{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
    [dateForm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *showDAte = [dateForm stringFromDate:now];
    self.date = [[showDAte componentsSeparatedByString:@" "] objectAtIndex:0];
    self.time = [[showDAte componentsSeparatedByString:@" "] objectAtIndex:1];
    [_theTable reloadData];

}
#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        return 55;
    }
    if (indexPath.row == 4) {
        return 65;
    }
    return 47;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 4) {
        static NSString *cellID = @"cellID";
        UITableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, 220, 44)];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 70, 44)];
            label.font = [UIFont systemFontOfSize:12];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = UITextAlignmentLeft;
            textField.leftViewMode = UITextFieldViewModeAlways;
            textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textField.userInteractionEnabled = YES;
            textField.font = [UIFont systemFontOfSize:13.0f];
            textField.delegate = self;
            [cell.contentView addSubview:label];
            [cell.contentView addSubview:textField];
            if (indexPath.row == 0) {
                label.text = @"日期:";
                textField.tag = TEXTFIELD_DATE_TAG;
                textField.text = self.date;
            }else if (indexPath.row == 1){
                label.text = @"时间:";
                textField.tag = TEXTFIELD_TIME_TAG;
                textField.text = self.time;
            }else if (indexPath.row == 2){
                label.text = @"备注:";
                textField.placeholder = @"请输入其它备注";
                textField.tag = TEXTFIELD_NOTE_TAG;
            }else if (indexPath.row == 3){
                label.text = @"位置:";
                textField.tag = TEXTFIELD_LOCATION_TAG;
                //textField.text = self.locationAddress;
                textField.enabled = NO;
                textField.text = self.address;
                self.updateImageView = [[UIImageView alloc] initWithImage:[self.imageArray objectAtIndex:0]];
                self.updateImageView.userInteractionEnabled = YES;
                self.updateImageView.frame = CGRectMake(265, 8, 35, 35);
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateLocation:)];
                tap.numberOfTapsRequired = 1;
                tap.numberOfTouchesRequired = 1;
                [self.updateImageView addGestureRecognizer:tap];
                [cell addSubview:self.updateImageView];
            }
        }
        return cell;
    }else if (indexPath.row == 4)
    {
        static NSString *cellID1 = @"CELLID1";
        KHHAddImageCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:cellID1];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"KHHAddImageCell" owner:self options:nil] objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        for (int i = 0; i<[_imgArray count]; i++) {
            _imgview = [[UIImageView alloc] init];
            _imgview.userInteractionEnabled = YES;
            UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFunctionTwo:)];
            longpress.allowableMovement = NO;
            longpress.numberOfTouchesRequired = 1;
            longpress.minimumPressDuration = 0.5;
            [_imgview addGestureRecognizer:longpress];
            UITapGestureRecognizer *tapFull = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFull:)];
            tapFull.numberOfTapsRequired = 1;
            tapFull.numberOfTouchesRequired = 1;
            [_imgview addGestureRecognizer:tapFull];
            _imgview.tag = i + 100;
            _imgview.frame = CGRectMake(20+i*(5 + 60), 0, 60, 60);
            _imgview.image = [_imgArray objectAtIndex:i];
            [cell addSubview:_imgview];
            
        }
        if (_imgArray.count == 4) {
            cell.addBtn.hidden = YES;
            cell.lab.hidden = YES;
        }
        if (_imgArray.count < 4) {
            cell.addBtn.hidden = NO;
            cell.lab.hidden = NO;
        }
        [cell.addBtn addTarget:self action:@selector(addImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    return nil;

}
#pragma mark -
- (void)addImageBtnClick:(id)sender
{
    _index = 1;
    UIActionSheet *actView = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [actView addButtonWithTitle:@"本地相册"];
    [actView addButtonWithTitle:@"拍照"];
    [actView showInView:self.view];

}
//刷新地址
- (void)updateLocation:(id)sender
{
    self.isFirstLocation = NO;
    [self locaIconAnimationIsEnd:NO];
    [self getLocalAddress];
}
//动画
- (void)locaIconAnimationIsEnd:(BOOL)endAnimation{
    self.updateImageView.animationImages = self.imageArray;
    self.updateImageView.animationDuration = 0.3;
    if (endAnimation) {
        [self.updateImageView stopAnimating];
    }else{
        [self.updateImageView startAnimating];
    }
}
//得到地址
- (void)getLocalAddress{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = NSLocalizedString(@"正在获取地址...", nil);
    [self observeNotificationName:KHHLocationUpdateSucceeded selector:@"handleLocationUpdateSucceeded:"];
    [self observeNotificationName:KHHLocationUpdateFailed selector:@"handleLocationUpdateFailed:"];
    KHHLocationController *locaVC = [KHHLocationController sharedController];
    [locaVC updateLocation];
}
//上传地理位置
- (void)uploadBtnClick:(id)sender
{
    [self observeNotificationName:KHHNetworkCheckInSucceeded selector:@"handleCheckInSucceeded:"];
    [self observeNotificationName:KHHNetworkCheckInFailed selector:@"handleCheckInFailed:"];
    UITextField *note = (UITextField *)[self.view viewWithTag:TEXTFIELD_NOTE_TAG];
    self.checkIn.memo = note.text;
    self.checkIn.latitude =  self.locationLatitude;
    self.checkIn.longitude = self.locationLongitude;
    self.checkIn.cardID = self.card.id;
    self.checkIn.placemark = self.placeMark;
    self.checkIn.imageArray = self.imgArray;
    KHHNetworkAPIAgent *agent = [[KHHNetworkAPIAgent alloc] init];
    [agent checkIn:self.checkIn];
}
#pragma mark -
- (void)handleLocationUpdateSucceeded:(NSNotification *)info{
    DLog(@"handleLocationUpdateSucceeded! ====== info is %@",info.userInfo);
    [self stopObservingForUpdateLocation];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    [self performSelector:@selector(stopAnimatingForUPdateLoca) withObject:nil afterDelay:0.5];
    
    self.locationLatitude = [info.userInfo objectForKey:@"locationLatitude"];
    self.locationLongitude = [info.userInfo objectForKey:@"locationLongitude"];
    self.placeMark = [info.userInfo objectForKey:@"placemark"];
    UITextField *addressTf = (UITextField *)[self.view viewWithTag:TEXTFIELD_LOCATION_TAG];
    //NSString *addressString = CFBridgingRelease((__bridge CFTypeRef)(ABCreateStringWithAddressDictionary(self.placeMark.addressDictionary, NO)));
    NSString *addressString = ABCreateStringWithAddressDictionary(self.placeMark.addressDictionary, NO);
    if (addressString.length > 0) {
        addressTf.text = addressString;
    }
    
    if (self.isFirstLocation) {
        self.address = ABCreateStringWithAddressDictionary(self.placeMark.addressDictionary, NO);
        [_theTable reloadData];
    }
    
}
- (void)handleLocationUpdateFailed:(NSNotification *)info{
    DLog(@"handleLocationUpdateFailed! ====== info is %@",info.userInfo);
    [self stopObservingForUpdateLocation];
    //更新失败还显示原来的位置.
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    [self performSelector:@selector(stopAnimatingForUPdateLoca) withObject:nil afterDelay:0.5];
}
- (void)handleCheckInSucceeded:(NSNotification *)info{
    DLog(@"handleCheckInSucceeded! ====== info is %@",info.userInfo);
    [self stopObservingForCheckIn];
    [[[UIAlertView alloc] initWithTitle:nil
                                message:@"签到成功"
                               delegate:self
                      cancelButtonTitle:@"确定"
                      otherButtonTitles:nil, nil] show];
}
- (void)handleCheckInFailed:(NSNotification *)info{
    DLog(@"handleCheckInFailed! ====== info is %@",info.userInfo);
    [self stopObservingForCheckIn];
    [[[UIAlertView alloc] initWithTitle:nil
                                message:@"签到失败"
                               delegate:nil
                      cancelButtonTitle:@"确定"
                      otherButtonTitles:nil, nil] show];
}
- (void)stopObservingForUpdateLocation{
    [self stopObservingNotificationName:KHHLocationUpdateSucceeded];
    [self stopObservingNotificationName:KHHLocationUpdateFailed];
}
- (void)stopObservingForCheckIn{
    [self stopObservingNotificationName:KHHNetworkCheckInSucceeded];
    [self stopObservingNotificationName:KHHNetworkCheckInFailed];
}
#pragma mark -
- (void)stopAnimatingForUPdateLoca{
    [self locaIconAnimationIsEnd:YES];
}
- (void)longPressFunctionTwo:(UILongPressGestureRecognizer*)sender
{
    _index = 2;
    if (sender.state == UIGestureRecognizerStateBegan) {
        UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        [actSheet addButtonWithTitle:@"删除图片"];
        [actSheet showInView:self.view];
        UIImageView *imgview = (UIImageView *)[sender view];
        _currentTag = imgview.tag;
    }
}
- (void)tapFull:(UITapGestureRecognizer *)sender{
    self.tapImgview = (UIImageView *)[sender view];
    KHHFullFrameController *fullVC = [[KHHFullFrameController alloc] initWithNibName:nil bundle:nil];
    fullVC.image = self.tapImgview.image;
    [self.navigationController pushViewController:fullVC animated:YES];
}
#pragma mark -
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    if (self.index == 1) {
        if (buttonIndex == 1) {
            //本地相册
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                UIImagePickerController *imagePickCtrl = [[UIImagePickerController alloc] init];
                imagePickCtrl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePickCtrl.delegate = self;
                [self presentModalViewController:imagePickCtrl animated:YES];
            }
            
        }else if (buttonIndex == 2){
            //拍照
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *imagePickCtrl = [[UIImagePickerController alloc] init];
                imagePickCtrl.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickCtrl.delegate = self;
                imagePickCtrl.allowsEditing = YES;
                [self presentModalViewController:imagePickCtrl animated:YES];
            }
        }
    }
    
    if (self.index == 2){
        if (buttonIndex == 2) {
            //设为头像
        }else if (buttonIndex == 1){
            //删除
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
            [_imgArray removeObjectAtIndex:_currentTag - 100];
            [_theTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        }
    }
}
- (void)handlePickedImage:(UIImage *)image
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    [_imgArray addObject:image];
    [_theTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImage *oriImage = [editingInfo objectForKey:UIImagePickerControllerOriginalImage];
        UIImageWriteToSavedPhotosAlbum(oriImage, nil, nil,nil);
    }
    [self performSelector:@selector(handlePickedImage:) withObject:image afterDelay:0.1];
    [self dismissModalViewControllerAnimated:YES];
    
}
#pragma mark -
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self tableviewAnimationDown];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self tableviewAnimationUp];
}
- (void)tableviewAnimationUp
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect rect = _theTable.frame;
    rect.origin.y = -60;
    _theTable.frame = rect;
    [UIView commitAnimations];

}
- (void)tableviewAnimationDown
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect rect = _theTable.frame;
    rect.origin.y = 0;
    _theTable.frame = rect;
    [UIView commitAnimations];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
       [self.navigationController popViewControllerAnimated:YES]; 
    }

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
