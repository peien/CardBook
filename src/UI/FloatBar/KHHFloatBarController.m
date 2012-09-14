//
//  KHHFloatBarController.m
//  CardBook
//
//  Created by 孙铭 on 8/7/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHFloatBarController.h"

@interface KHHFloatBarController ()

@end

@implementation KHHFloatBarController
@synthesize segmentedControl = _segmentedControl;
@synthesize delegate = _delegate;
@synthesize isFour = _isFour;
@synthesize viewF = _viewF;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.contentSizeForViewInPopover = CGSizeMake(240, 44);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
      _segmentedControl.selectedSegmentIndex = 2;
    
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _viewF = _viewF;
}

//- (IBAction)segmentCtrlValueChanged:(id)sender
//{
//    UISegmentedControl *segCtrl = (UISegmentedControl *)sender;
//    if ([_delegate respondsToSelector:@selector(segmentCtrlValueChanged:)]) {
//        [_delegate segmentCtrlValueChanged:segCtrl.selectedSegmentIndex];
//    }
//}

- (IBAction)BtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if ([_delegate respondsToSelector:@selector(BtnTagValueChanged:)]) {
        [_delegate BtnTagValueChanged:btn.tag];
    }

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
