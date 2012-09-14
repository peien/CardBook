//
//  EmployDetailInfoVC.m
//  CardBook
//
//  Created by 王国辉 on 12-8-13.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "EmployDetailInfoVC.h"
#import "FootPrintViewController.h"
#define RADAR_VIEW_TAG 3201
#define FUNNEL_VIEW_TAG 3202
@interface EmployDetailInfoVC ()
@property (strong, nonatomic) FootPrintViewController *footPVC;
@end

@implementation EmployDetailInfoVC
@synthesize theTable = _theTable;
@synthesize segCtrl = _segCtrl;
@synthesize footPVC = _footPVC;
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
    UIView *radarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 387)];
    radarView.tag = RADAR_VIEW_TAG;
    radarView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:radarView];
    UIView *funnelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 387)];
    funnelView.tag = FUNNEL_VIEW_TAG;
    funnelView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:funnelView];
    _segCtrl.selectedSegmentIndex = 0;
    [self performSelector:@selector(segmentCtrl_ValueChange:) withObject:nil afterDelay:0.1];
    _footPVC = [[FootPrintViewController alloc] initWithNibName:@"FootPrintViewController" bundle:nil];
    _footPVC.view.frame = CGRectMake(0, 0, 320, 387);
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)segmentCtrl_ValueChange:(id)sender
{
    UISegmentedControl *segm = (UISegmentedControl *)sender;
    int index = segm.selectedSegmentIndex;
    switch (index) {
        case 0:
        {
            [self.view addSubview:_footPVC.view];
            [self.view bringSubviewToFront:_footPVC.view];
        }
            break;
        case 1:
        {
            UIView *view = (UIView *)[self.view viewWithTag:RADAR_VIEW_TAG];
            [self.view bringSubviewToFront:view];
        }
            break;
        case 2:
        {
            UIView *view = (UIView *)[self.view viewWithTag:FUNNEL_VIEW_TAG];
            [self.view bringSubviewToFront:view];
        }
            break;
        default:
            break;
    }

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
