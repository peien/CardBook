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

#define UPDATE_LOCATION_BTN_TAG     4401
@interface LocationInfoVC ()<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) CLLocationManager *localM;

@end

@implementation LocationInfoVC
@synthesize theTable = _theTable;
@synthesize isGetLocationInfo = _isGetLocationInfo;
@synthesize currentLocation = _currentLocation;
@synthesize localM = _localM;
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

//- (void)updateBtnClick:(id)sender
//{
//    UIButton *btn = (UIButton *)sender;
//    [btn setTitle:@"正在定位..." forState:UIControlStateNormal];
//    _localM = [[CLLocationManager alloc] init];
//    if (_localM && [CLLocationManager locationServicesEnabled]) {
//        _localM.delegate = self;
//        _localM.distanceFilter = 100;
//        _localM.desiredAccuracy = kCLLocationAccuracyBest;
//        [_localM startUpdatingLocation];
//    }else {
//        _localM = nil;
//    }
//    
//
//}

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
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, 220, 44)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentRight;
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.userInteractionEnabled = YES;
        textField.font = [UIFont systemFontOfSize:15.0f];
        [cell.contentView addSubview:label];
        [cell.contentView addSubview:textField];
        if (indexPath.row == 0) {
            label.text = @"日期";
            textField.text = @"";
        }else if (indexPath.row == 1){
            label.text = @"时间";
        }else if (indexPath.row == 2){
            label.text = @"备注";
        }else if (indexPath.row == 3){
            label.text = @"位置";
            for (int i = 0; i<2; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                if (i== 0 || i == 1) {
                    [btn setBackgroundImage:[UIImage imageNamed:@"locationImg.png"] forState:UIControlStateNormal];
                }
                btn.frame = CGRectMake(265, 5+i*(8+30), 30, 30);
                btn.tag = i + 778;
                [cell.contentView addSubview:btn];
            }
        }else if (indexPath.row == 4){
            CGRect rect = label.frame;
            rect.origin.x += 55;
            label.frame = rect;
            label.text = @"添加图片";
            UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [addBtn setBackgroundImage:[UIImage imageNamed:@"addBtnimg.png"] forState:UIControlStateNormal];
            addBtn.frame = CGRectMake(10, 3, 45, 45);
            [addBtn addTarget:self action:@selector(addImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:addBtn];

        }

    }
    return cell;

}
- (void)addImageBtnClick:(id)sender
{

}
- (void)uploadBtnClick:(id)sender
{

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
