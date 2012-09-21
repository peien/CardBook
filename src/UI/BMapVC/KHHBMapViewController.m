//
//  KHHBMapViewController.m
//  CardBook
//
//  Created by 王国辉 on 12-9-21.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHBMapViewController.h"
//#import "BMapKit.h"
//#import "BMKMapView.h"

@interface KHHBMapViewController ()
//@property (strong, nonatomic) BMKMapManager *mapManager;
@end

@implementation KHHBMapViewController
//@synthesize mapManager = _mapManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    _mapManager = [[BMKMapManager alloc] init];
//    BOOL ret = [_mapManager start:@"D75E7E8A5651ADBC9B2C19F4E442A5006457F86F" generalDelegate:nil];
//    if (!ret) {
//        NSLog(@"mapManager start failed!");
//    }
//    [self showMap];
}
-(void)showMap
{
//    BMKMapView *mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
//    self.view = mapView;
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
