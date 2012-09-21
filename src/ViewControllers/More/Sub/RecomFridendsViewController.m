//
//  RecomFridendsViewController.m
//  LoveCard
//
//  Created by gh w on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RecomFridendsViewController.h"
#import "ShareSinaViewController.h"

@interface RecomFridendsViewController ()<MFMessageComposeViewControllerDelegate>

@end

@implementation RecomFridendsViewController
@synthesize theTable = _theTable;
@synthesize ItemArray = _ItemArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"推荐给好友";
        self.navigationItem.rightBarButtonItem = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _ItemArray = [NSArray arrayWithObjects:@"写信息",@"分享到新浪微薄",@"分享给QQ好友", nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _theTable = nil;
    _ItemArray = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        cell.textLabel.textAlignment = UITextAlignmentLeft;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.text = [_ItemArray objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self gotoSendSMS];

    }else if (indexPath.row ==1) {
        ShareSinaViewController *shareVC = [[ShareSinaViewController alloc] initWithNibName:@"ShareSinaViewController" bundle:nil];
        [self.navigationController pushViewController:shareVC animated:YES];
    }

}

- (void) gotoSendSMS
{
    if (MFMessageComposeViewController.canSendText) {
        MFMessageComposeViewController *smsVC = [[MFMessageComposeViewController alloc] init];
        smsVC.messageComposeDelegate = self;
        smsVC.body = [NSString stringWithFormat:@"我正在手机上用“爱心卡包“，可收录个人专属的会员卡和银行卡。推荐大家用一下，下载地址:%@",nil];
        [self presentModalViewController:smsVC animated:YES];
    } else {
        [[[UIAlertView alloc] 
           initWithTitle:nil 
           message:NSLocalizedString(@"您的设备不支持发送短信！", @"SMS is not available!") 
           delegate:nil 
           cancelButtonTitle:NSLocalizedString(@"OK", @"OK") 
           otherButtonTitles:nil] 
           show];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissModalViewControllerAnimated:YES];
    
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
    else if (result == MessageComposeResultSent)
        NSLog(@"Message sent");  
    else 
        NSLog(@"Message failed");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
