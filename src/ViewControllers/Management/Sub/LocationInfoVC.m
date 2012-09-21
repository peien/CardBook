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

#define UPDATE_LOCATION_BTN_TAG     4401
@interface LocationInfoVC ()<CLLocationManagerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,
                            UIImagePickerControllerDelegate,UITextFieldDelegate>

@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) CLLocationManager *localM;
@property (strong, nonatomic) UIImageView       *imgview;
@property (assign, nonatomic) int               currentTag;
@property (assign, nonatomic) int               index;

@end

@implementation LocationInfoVC
@synthesize theTable = _theTable;
@synthesize isGetLocationInfo = _isGetLocationInfo;
@synthesize currentLocation = _currentLocation;
@synthesize localM = _localM;
@synthesize imgArray = _imgArray;
@synthesize imgview = _imgview;
@synthesize currentTag = _currentTag;
@synthesize index = _index;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"位置信息";
        [self.rightBtn setTitle:@"足迹" forState:UIControlStateNormal];
    }
    return self;
}

- (void)rightBarButtonClick:(id)sender
{
    FootPrintViewController *footVC = [[FootPrintViewController alloc] initWithNibName:@"FootPrintViewController" bundle:nil];
    [self.navigationController pushViewController:footVC animated:YES];
}

- (void)takePhotoBtnClick:(id)sender
{
    
}

- (void)recordBtnClick:(id)sender
{
    
}
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    _currentLocation = newLocation;
    [manager stopUpdatingLocation];
    UIButton *btn = (UIButton *)[self.view viewWithTag:UPDATE_LOCATION_BTN_TAG];
    [btn setTitle:@"更新位置" forState:UIControlStateNormal];
    
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        [manager stopUpdatingHeading];
        [manager stopUpdatingLocation];
    }else if (error.code == kCLErrorHeadingFailure) {
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _isGetLocationInfo = YES;
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
    footView.backgroundColor = [UIColor clearColor];
    UIButton *takePhotoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    takePhotoBtn.frame = CGRectMake(40, 35, 240, 37);
    [takePhotoBtn setTitle:@"上传位置" forState:UIControlStateNormal];
    [takePhotoBtn addTarget:self action:@selector(uploadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:takePhotoBtn];
    _theTable.tableFooterView = footView;
    _imgArray = [[NSMutableArray alloc] init];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [KHHShowHideTabBar hideTabbar];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        return 65;
    }
    if (indexPath.row == 4) {
        return 70;
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
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = UITextAlignmentLeft;
            textField.leftViewMode = UITextFieldViewModeAlways;
            textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textField.userInteractionEnabled = YES;
            textField.font = [UIFont systemFontOfSize:15.0f];
            textField.delegate = self;
            [cell.contentView addSubview:label];
            [cell.contentView addSubview:textField];
            if (indexPath.row == 0) {
                label.text = @"日期:";
                textField.text = @"";
            }else if (indexPath.row == 1){
                label.text = @"时间:";
            }else if (indexPath.row == 2){
                label.text = @"备注:";
            }else if (indexPath.row == 3){
                label.text = @"位置:";
                for (int i = 0; i<2; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    if (i== 0 || i == 1) {
                        [btn setBackgroundImage:[UIImage imageNamed:@"locationImg.png"] forState:UIControlStateNormal];
                    }
                    btn.frame = CGRectMake(265, 2+i*(5+30), 30, 30);
                    btn.tag = i + 778;
                    [cell.contentView addSubview:btn];
                }
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
            _imgview.tag = i + 100;
            _imgview.frame = CGRectMake(25+i*(10 + 60), 5, 60, 60);
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
- (void)addImageBtnClick:(id)sender
{
    _index = 1;
    UIActionSheet *actView = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [actView addButtonWithTitle:@"本地相册"];
    [actView addButtonWithTitle:@"拍照"];
    [actView showInView:self.view];

}
- (void)uploadBtnClick:(id)sender
{

}
- (void)longPressFunctionTwo:(UILongPressGestureRecognizer*)sender
{
    _index = 2;
    if (sender.state == UIGestureRecognizerStateBegan) {
        UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        [actSheet addButtonWithTitle:@"设为头像"];
        [actSheet addButtonWithTitle:@"删除图片"];
        [actSheet showInView:self.view];
        UIImageView *imgview = (UIImageView *)[sender view];
        _currentTag = imgview.tag;
    }
}
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
        if (buttonIndex == 1) {
            // 设为头像;
        }else if (buttonIndex == 2){
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
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
