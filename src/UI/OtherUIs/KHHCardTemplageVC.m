//
//  KHHCardTemplageVC.m
//  CardBook
//
//  Created by 王国辉 on 12-10-26.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.

#import "KHHCardTemplageVC.h"
#import "KHHData+UI.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "KHHClasses.h"

#define UIIMAGE_WIDTH  140
#define UIIMAGE_HEIGHT 100
@interface KHHCardTemplageVC ()
@property (strong, nonatomic) NSArray *tempArr;

@end

@implementation KHHCardTemplageVC
@synthesize tempArr;
@synthesize editCardVC;
@synthesize card;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.leftBtn.hidden = NO;
        self.rightBtn.hidden = YES;
        [self.leftBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        self.title = @"选择模板";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithRed:241 green:238 blue:232 alpha:1.0]];
    self.tempArr = [[KHHData sharedData] allPublicTemplates];
    //DLog(@"tempArr is ====== %@",tempArr);
    DLog(@"tempArr num is ======%d",tempArr.count)
    UIScrollView *scrol = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    scrol.backgroundColor = [UIColor lightGrayColor];
    int page = 0;
    int col = (self.view.frame.size.width - 2*UIIMAGE_WIDTH)/3;
    int row = (self.view.frame.size.height-30 - 3*UIIMAGE_HEIGHT)/4;
    for (int i = 0; i< self.tempArr.count; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.userInteractionEnabled = YES;
        imgView.frame = CGRectMake(col + i%2*(UIIMAGE_WIDTH + col), row + i/2*(row+UIIMAGE_HEIGHT)- i/6*(row+UIIMAGE_HEIGHT)*3 + i/6*460, UIIMAGE_WIDTH, UIIMAGE_HEIGHT);
        imgView.tag = i + 100;
        CardTemplate *cardTemp = [self.tempArr objectAtIndex:i];
        if (cardTemp.domainTypeValue == 1 && cardTemp.isFullValue) {
            [imgView setImageWithURL:[NSURL URLWithString:cardTemp.bgImage.url] placeholderImage:nil];
        }
        [scrol addSubview:imgView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedOneTemplate:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [imgView addGestureRecognizer:tap];
        
        if (i%6 == 0) {
            page = i/6+1;
        }else {
            page = i/6;
        }
        scrol.pagingEnabled = YES;
        scrol.contentSize = CGSizeMake(320, page*460);
    }
    [self.view addSubview:scrol];
}

- (void)selectedOneTemplate:(UITapGestureRecognizer *)sender{
    UIImageView *imgView = (UIImageView *)[sender view];
    CardTemplate *tem = [self.tempArr objectAtIndex:imgView.tag - 100];
    self.editCardVC.glCard.template = tem;
    self.editCardVC.cardTemp = tem;
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)viewDidUnload{
    [super viewDidUnload];
    self.tempArr = nil;
    self.editCardVC = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
