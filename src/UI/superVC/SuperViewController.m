//
//  SuperViewController.m
//  CardBook
//
//  Created by gh w on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SuperViewController.h"
#import "KHHMessageViewController.h"
#import "KHHEditMSGViewController.h"
#import "KHHHomeViewController.h"
#import "DetailInfoViewController.h"
#import "KHHDataNew+Card.h"

#define TEXT_NEW_MESSAGE_COMMING NSLocalizedString(@"您有新消息到了,可到消息界面查看新消息。",nil)

@implementation SuperViewController
{
    NSNumber *_reseaveCardId;
}
@synthesize leftBtn;
@synthesize rightBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        rightBtn = [UIButton buttonWithType:UIBarButtonItemStylePlain];
        [rightBtn setBackgroundImage:[[UIImage imageNamed:@"titlebtn_normal.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:2] forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [rightBtn addTarget:self action:@selector(rightBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.frame = CGRectMake(0, 0, 70, 30);
        UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem = rightBar;
        
        leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setBackgroundImage:[[UIImage imageNamed:@"titlebtn_normal.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:2] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(leftBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        leftBtn.frame = CGRectMake(0, 0, 70, 30);
        [leftBtn setTitle:KHHMessageBack forState:UIControlStateNormal];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        self.navigationItem.leftBarButtonItem = leftBar;
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    leftBtn = nil;
    rightBtn = nil;
}

- (void)rightBarButtonClick:(id)sender
{

}
- (void)leftBarButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - KHHDataMessageDelegate

- (void)reseaveMsgForUIFailed:(NSDictionary *)dict
{

}

- (void)reseaveMsgForUISuccess:(Boolean)haveNewMsg

{
    if (haveNewMsg) {
        //当前页不是消息界面时要弹出新消息到了的框
        if (!([self isMemberOfClass:[KHHMessageViewController class]]
              || [self isMemberOfClass:[KHHEditMSGViewController class]])) {
            //showalert
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新消息"
                                                            message:TEXT_NEW_MESSAGE_COMMING
                                                           delegate:self
                                                  cancelButtonTitle:@"以后看"
                                                  otherButtonTitles:@"查看", nil];
            alert.tag = KHHAlertMessage;
            [alert show];
        }else{
            [(KHHMessageViewController *)[self.navigationController.viewControllers lastObject] refreshTable];
        }
    }
    
}

#pragma mark - alert delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!alertView || !alertView.tag) {
        return;
    }
    KHHAlertType type = alertView.tag;
    switch (type) {
       
        case KHHAlertMessage:
        {
            if (buttonIndex == 1) {
                [self gotoMessageListViewController];
            }
            break;
        }
        case KHHAlertContact:
        {
            if (buttonIndex == 1) {
                [self gotoDetailContactController];
            }
            break;
        }
            
            default:
            break;
    }
}

- (void)gotoMessageListViewController
{
    KHHMessageViewController *messageVC = [[KHHMessageViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:messageVC animated:YES];
}

- (void)gotoDetailContactController
{
    
    DetailInfoViewController *detailVC = [[DetailInfoViewController alloc] initWithNibName:nil bundle:nil];
    detailVC.card = [[KHHDataNew sharedData] receivedCardByID:_reseaveCardId];
    [[KHHDataNew sharedData] doMarkIsRead:(ReceivedCard *)detailVC.card  delegate:self];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - KHHDataSyncContactDelegate

- (void)touchCardForUISuccess:(NSDictionary *)dict
{
    if ([self isMemberOfClass:[KHHHomeViewController class]]
        )
    {
        ((KHHHomeViewController *)self).isNeedReloadTable = YES;
        [((KHHHomeViewController *)self) reloadTable];
    }
        _reseaveCardId = dict[@"card"][@"cardId"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新名片"
                                                        message:@"收到一张新名片"
                                                       delegate:self
                                              cancelButtonTitle:@"以后看"
                                              otherButtonTitles:@"查看", nil];
        alert.tag = KHHAlertContact;
        [alert show];    
}

- (void)touchCardForUIFailed:(NSDictionary *)dict
{
    
}

@end
