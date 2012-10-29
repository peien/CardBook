//
//  KHHCardTemplageVC.m
//  CardBook
//
//  Created by 王国辉 on 12-10-26.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.

#import "KHHCardTemplageVC.h"

#define UIIMAGE_WIDTH  140
#define UIIMAGE_HEIGHT 100
@interface KHHCardTemplageVC ()

@end

@implementation KHHCardTemplageVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIScrollView *scrol = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    scrol.backgroundColor = [UIColor grayColor];
    int page = 0;
    int col = (self.view.frame.size.width - 2*UIIMAGE_WIDTH)/3;
    int row = (self.view.frame.size.height-30 - 3*UIIMAGE_HEIGHT)/4;
    for (int i = 0; i< 17; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.userInteractionEnabled = YES;
        imgView.backgroundColor = [UIColor purpleColor];
        imgView.frame = CGRectMake(col + i%2*(UIIMAGE_WIDTH + col), row + i/2*(row+UIIMAGE_HEIGHT)- i/6*(row+UIIMAGE_HEIGHT)*3 + i/6*460, UIIMAGE_WIDTH, UIIMAGE_HEIGHT);
        [scrol addSubview:imgView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedOneTemplate:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [imgView addGestureRecognizer:tap];
        
        if (i%6 == 0) {
            page = i/6;
        }else {
            page = i/6+1;
        }
        scrol.pagingEnabled = YES;
        scrol.contentSize = CGSizeMake(320, page*460);
    }

    [self.view addSubview:scrol];
}

- (void)selectedOneTemplate:(UITapGestureRecognizer *)sender{
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
