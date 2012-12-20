//
//  KHHBMapViewController.m
//  CardBook
//
//  Created by 王国辉 on 12-9-21.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHBMapViewController.h"
#import "SVGeocoder.h"

static NSInteger KHH_Map_Zoom_Level = 16;

@interface KHHBMapViewController ()
@end

@implementation KHHBMapViewController
//@synthesize mapManager = _mapManager;
@synthesize companyDetailAddr = _companyDtailAddr;
@synthesize companyCity = _companyCity;
@synthesize companyName = _companyName;
@synthesize companyAllAddr = _companyAllAddr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.rightBtn.hidden = YES;
        self.title = @"定位";
    }
    return self;
}
//
//- (void)leftBarButtonClick:(id)sender
//{
//    [_mapManager stop];
//    [self.navigationController popViewControllerAnimated:YES];
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self showMap];
}
-(void)showMap
{
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
    //设置zoom level
    [_mapView setZoomLevel:KHH_Map_Zoom_Level];
    
    //切换到指定地址
    _search = [[BMKSearch alloc] init];
    _mapView.delegate = self;
    _search.delegate = self;
    self.view = _mapView;
    //清除overlay
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
	array = [NSArray arrayWithArray:_mapView.overlays];
	[_mapView removeOverlays:array];
    
    //显示位置
	BOOL flag = [_search geocode:_companyDtailAddr  withCity:_companyCity];
	if (!flag) {
		DLog(@"bmap search failed!");
        [SVGeocoder geocode:_companyAllAddr
                 completion:^(NSArray *placemarks, NSError *error) {
                     if(!error && placemarks){
                         SVPlacemark *placemark = [placemarks objectAtIndex:0];
                         
                         CLLocationCoordinate2D theCoordinate = placemark.coordinate;
                         
                         BMKCoordinateSpan theSpan;               //设定显示范围
                         theSpan.latitudeDelta = 0.1;
                         theSpan.longitudeDelta = 0.1;
                         
                         BMKCoordinateRegion theRegion;           //设置地图显示的中心及范围
                         theRegion.center = theCoordinate;
                         theRegion.span = theSpan;
                         [_mapView setRegion:theRegion];
                         
                         [self addAnnotationToMap:theCoordinate title:_companyName subTitle:nil];
                         
                     }else{
                         //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@""]];
                         CLGeocoder *clgeocoder = [[CLGeocoder alloc] init];
                         [clgeocoder geocodeAddressString:_companyAllAddr completionHandler:^(NSArray *placemarks, NSError *error) {
                             if(!error && placemarks){
                                 CLPlacemark *placemark = [placemarks objectAtIndex:0];
                                 
                                 CLLocationCoordinate2D theCoordinate = placemark.location.coordinate;
                                 
                                 BMKCoordinateSpan theSpan;               //设定显示范围
                                 theSpan.latitudeDelta = 0.1;
                                 theSpan.longitudeDelta = 0.1;
                                 
                                 BMKCoordinateRegion theRegion;           //设置地图显示的中心及范围
                                 theRegion.center = theCoordinate;
                                 theRegion.span = theSpan;
                                 [_mapView setRegion:theRegion];
                                 
                                 [self addAnnotationToMap:theCoordinate title:_companyName subTitle:nil];
                             }else{
                                 //Apple 正向解析地址 错误
//                                 DLog(@"Apple 正向解析地址 错误!");
                                 UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"地理位置解析错误!" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                 [av show];
                             }
                         }];
                     }
                     
                 }];

	}
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
	static NSString *AnnotationViewID = @"annotationViewID";
	
    BMKAnnotationView *annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
		((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
		((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
	
	annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
	annotationView.canShowCallout = YES;
    return annotationView;
}

- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error
{
	if (error == 0) {
//		[self addAnnotationToMap:result.geoPt title:result.strAddr subTitle:nil];
		[self addAnnotationToMap:result.geoPt title:_companyName subTitle:nil];
	}else {
        [[[UIAlertView alloc] initWithTitle:nil message:@"定位失败！" delegate:nil cancelButtonTitle:KHHMessageSure otherButtonTitles:nil, nil] show];
    }
}

//在地图上添加一个标识
-(void) addAnnotationToMap:(CLLocationCoordinate2D) point title:(NSString *) title subTitle:(NSString *) subtitle{
    BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
    item.coordinate = point;
    item.title = title;
    item.subtitle = subtitle;
    [_mapView addAnnotation:item ];
    //地图动画切换的点
    [_mapView setCenterCoordinate:item.coordinate animated:YES];
    
    item = nil;
}

-(void) dealloc {
    _companyAllAddr = nil;
    _companyCity = nil;
    _companyDtailAddr = nil;
    _companyName = nil;
    _search = nil;
    _mapView = nil;
//    [super dealloc];
}


@end
