//
//  KHHFloatBarController.m
//  CardBook
//
//  Created by 孙铭 on 8/7/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHFloatBarController.h"
#import "MapController.h"
#import "KHHVisitRecoardVC.h"
#import "KHHBMapViewController.h"
#import <MessageUI/MessageUI.h>

@interface KHHFloatBarController ()<UIImagePickerControllerDelegate, UIActionSheetDelegate,
                                    UINavigationControllerDelegate,MFMessageComposeViewControllerDelegate>
@property UIActionSheet *actSheet;

@end

@implementation KHHFloatBarController
@synthesize isFour = _isFour;
@synthesize viewF = _viewF;
@synthesize viewController = _viewController;
@synthesize popover = _popover;
@synthesize type = _type;

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
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _viewF = nil;
    self.actSheet = nil;
    _popover = nil;
    
}

- (IBAction)BtnClick:(UIButton *)sender
{

    switch (sender.tag) {
            
        case 0:
            [self callPhone];
            break;
        case 1:
            [self sendMessage];
            break;
        case 2:
            [self takePhotos];
            break;
        case 3:
            [self goToMapVC];
            break;
        case 4:
            [self newVisitRecoard];
            break;
        default:
            break;
    }
    

}
//打电话
- (void)callPhone
{
    _type = 1;
    self.actSheet = [[UIActionSheet alloc] initWithTitle:@"选择号码" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [self.actSheet addButtonWithTitle:@"15123568754"];
    [self.actSheet showInView:_viewController.view];
    [self.popover dismissPopoverAnimated:YES];

}
//发短信
- (void)sendMessage
{
    _type = 2;
    self.actSheet = [[UIActionSheet alloc] initWithTitle:@"选择号码" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [self.actSheet addButtonWithTitle:@"15123568754"];
    [self.actSheet showInView:_viewController.view];
    [self.popover dismissPopoverAnimated:YES];
    
}

//拍照
- (void)takePhotos
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePickCtrl = [[UIImagePickerController alloc] init];
        imagePickCtrl.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickCtrl.delegate = self;
        imagePickCtrl.allowsEditing = NO;
        [self.viewController presentModalViewController:imagePickCtrl animated:YES];
    }
    [self.popover dismissPopoverAnimated:YES];

}
//定位
- (void)goToMapVC
{
    [self.popover dismissPopoverAnimated:YES];
    MapController *mapVC = [[MapController alloc] initWithNibName:nil bundle:nil];
    mapVC.companyAddr = @"浙江滨江区南环路4280号元光德大厦501室";
    mapVC.companyName = @"浙江金汉弘";
    [self.viewController.navigationController pushViewController:mapVC animated:YES];
//    KHHBMapViewController *mapVC = [[KHHBMapViewController alloc] initWithNibName:nil bundle:nil];
//    [self.navigationController pushViewController:mapVC animated:YES];

}
//新建拜访纪录
- (void)newVisitRecoard
{
    KHHVisitRecoardVC *newVisVC = [[KHHVisitRecoardVC alloc] initWithNibName:nil bundle:nil];
    newVisVC.style = KVisitRecoardVCStyleNewBuild;
    newVisVC.isNeedWarn = YES;
    [self.viewController.navigationController pushViewController:newVisVC animated:YES];
    [self.popover dismissPopoverAnimated:YES];

}
- (void)saveImage:(UIImage *)image
{
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self performSelector:@selector(saveImage:) withObject:image afterDelay:0.5];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark UIActionSheetDele
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    if (buttonIndex == 0) {
        return;
    }
    if (_type == 1) {
        
        NSString *phone = [actionSheet buttonTitleAtIndex:buttonIndex];
        NSString *urlSting = [NSString stringWithFormat:@"tel://%@",phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlSting]];
    }else if (_type == 2){
        NSString *phone = [actionSheet buttonTitleAtIndex:buttonIndex];
        Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
        if (messageClass != nil) {
            if ([messageClass canSendText]) {
                MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc] init];
                messageVC.messageComposeDelegate = self;
                messageVC.body = @"发送短信内容1122";
                //号码：
                messageVC.recipients = [NSArray arrayWithObjects:phone,nil];
                [self.viewController presentModalViewController:messageVC animated:YES];
            }else{
                // 不支持发送短信;
            }
        }else{
            //系统版本过低，只有ios4.0以上才支持程序内发送短信;
        }
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultSent:
            break;
        case MessageComposeResultCancelled:
            break;
        case MessageComposeResultFailed:
            break;
        default:
            break;
    }
    [self.viewController dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
