//
//  MapController.m
//  eCard
//
//  Created by 小龙 李 on 12-4-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MapController.h"
#import "SVGeocoder.h"
#import "KHHShowHideTabBar.h"
#import <CoreLocation/CoreLocation.h>


@interface BaseAnnotation : NSObject <MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;   
@property (nonatomic, copy) NSString *subtitle;   
@property (nonatomic, copy) NSString *title; 
@end

@implementation BaseAnnotation
@synthesize coordinate, title, subtitle;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    return self;
}

@end


@interface MapController ()

@end

@implementation MapController

@synthesize companyAddr = _companyAddr;
@synthesize companyName = _companyName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Map", @"Title for map tab");
        self.rightBtn.hidden = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	_mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
    _mapView.delegate = self;
    
//    CLLocationCoordinate2D theCoordinate;   //设定经纬度
//    theCoordinate.latitude = 24.148926;
//    theCoordinate.longitude = 120.715542;
    
//    MKCoordinateSpan theSpan;               //设定显示范围
//    theSpan.latitudeDelta = 0.1;
//    theSpan.longitudeDelta = 0.1;
//    
//    MKCoordinateRegion theRegion;           //设置地图显示的中心及范围
//    theRegion.center = theCoordinate;
//    theRegion.span = theSpan;
//    
//    [_mapView setMapType:MKMapTypeStandard];
//    [_mapView setRegion:theRegion];
    
    [self.view addSubview:_mapView];
    
//    BaseAnnotation *target = [[[BaseAnnotation alloc] init] autorelease];
//    target.title = @"Company Name";
//    target.subtitle = @"Company Address";
//    target.coordinate = theCoordinate;  //company coordinate
//    [_mapView addAnnotation:target];
    
    [self performSelector:@selector(getCoorDinateFromAddress:) withObject:[NSString stringWithFormat:@"%@ %@", _companyAddr, _companyName] afterDelay:0.1];
}
- (void)viewWillAppear:(BOOL)animated
{
    [KHHShowHideTabBar hideTabbar];
}
     
#pragma mark - GetCoordinate
- (void)getCoorDinateFromAddress:(NSString *)address
{
    __block MKMapView *blockMapView = _mapView;
    [SVGeocoder geocode:address
             completion:^(NSArray *placemarks, NSError *error) {
                 if(!error && placemarks){
                     SVPlacemark *placemark = [placemarks objectAtIndex:0];
                     
                     CLLocationCoordinate2D theCoordinate = placemark.coordinate;
                     
                     MKCoordinateSpan theSpan;               //设定显示范围
                     theSpan.latitudeDelta = 0.1;
                     theSpan.longitudeDelta = 0.1;
                     
                     MKCoordinateRegion theRegion;           //设置地图显示的中心及范围
                     theRegion.center = theCoordinate;
                     theRegion.span = theSpan;
                     
                     [blockMapView setMapType:MKMapTypeStandard];
                     [blockMapView setRegion:theRegion];
                     
                     BaseAnnotation *target = [[BaseAnnotation alloc] init];
                     target.title = _companyName;
                     target.subtitle = _companyAddr;
                     target.coordinate = theCoordinate;  //company coordinate
                     [blockMapView addAnnotation:target];

                     
                 }else{
                     UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"地理位置解析错误!" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                     [av show];
                     
                     //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@""]];
                     
                     CLGeocoder *clgeocoder = [[CLGeocoder alloc] init];
                     [clgeocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
                         if(!error && placemarks){
                             CLPlacemark *placemark = [placemarks objectAtIndex:0];
                             
                             CLLocationCoordinate2D theCoordinate = placemark.location.coordinate;
                             
                             MKCoordinateSpan theSpan;               //设定显示范围
                             theSpan.latitudeDelta = 0.1;
                             theSpan.longitudeDelta = 0.1;
                             MKCoordinateRegion theRegion;           //设置地图显示的中心及范围
                             theRegion.center = theCoordinate;
                             theRegion.span = theSpan;
                             [blockMapView setMapType:MKMapTypeStandard];
                             [blockMapView setRegion:theRegion];
                             BaseAnnotation *target = [[BaseAnnotation alloc] init];
                             target.title = _companyName;
                             target.subtitle = _companyAddr;
                             target.coordinate = theCoordinate;  //company coordinate
                             [blockMapView addAnnotation:target];
                             
                             
                         }else{
                             //Apple 正向解析地址 错误
                         }
                     }];
                 }
                 
             }];
}

#pragma mark - MKMapView Delegate Methods
- (MKAnnotationView *)mapView:(MKMapView *)mView viewForAnnotation:(id <MKAnnotation>)annotation 
{
    if([annotation isKindOfClass:[BaseAnnotation class]]){
        // using default pin as a PlaceMarker to display on map   
        MKPinAnnotationView *targetView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotationForTarget"];   
        targetView.pinColor = MKPinAnnotationColorRed;   //設定大頭釘的顏色，不過只有紅色、紫色、綠色，三種顏色
        targetView.animatesDrop = YES;
        // canShowCallout: to display the callout view by touch the pin   
        targetView.canShowCallout = YES;
        targetView.draggable = NO;
        targetView.selected = YES;
        return targetView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    for(id<MKAnnotation> mk in _mapView.annotations){
        if([[[_mapView viewForAnnotation:mk] reuseIdentifier] isEqualToString:@"annotationForTarget"]){
            [_mapView selectAnnotation:mk animated:YES];
        }
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay 
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
        polylineView.strokeColor = [UIColor blueColor];
        polylineView.lineWidth = 4;
        return polylineView;
    }
    return [[MKOverlayView alloc] initWithOverlay:overlay];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    self.companyName = nil;
    self.companyAddr = nil;
//    [super dealloc];
}

@end
