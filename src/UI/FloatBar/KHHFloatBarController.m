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
#import "Address.h"
#import "Company.h"
#import "NSString+Validation.h"
#import <MessageUI/MessageUI.h>

@interface KHHFloatBarController ()<UIImagePickerControllerDelegate, UIActionSheetDelegate,
                                    UINavigationControllerDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>
@property UIActionSheet *actSheet;

@end

@implementation KHHFloatBarController
@synthesize isFour = _isFour;
@synthesize viewF = _viewF;
@synthesize viewController = _viewController;
@synthesize popover = _popover;
@synthesize type = _type;
@synthesize card;
@synthesize isContactCellClick;
@synthesize contactDic;
@synthesize isJustNormalComunication;

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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isContactCellClick || self.isJustNormalComunication) {
        self.btn2.hidden = YES;
        self.btn3.hidden = YES;
        CGRect rect = self.btn0.frame;
        rect.origin.x = 195;
        self.btn0.frame = rect;

    }else{
        self.btn1.hidden = NO;
        self.btn2.hidden = NO;
        self.btn3.hidden = NO;
        CGRect rect = self.btn0.frame;
        rect.origin.x = 60;
        self.btn0.frame = rect;
    
    }

}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _viewF = nil;
    self.actSheet = nil;
    _popover = nil;
    self.card = nil;
    self.contactDic = nil;
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
    UIActionSheet *act = [[UIActionSheet alloc] initWithTitle:@"选择号码" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    //NSArray *phones = [self.contactDic objectForKey:@"phone"];
    if (self.isContactCellClick) {
        NSArray *phones = [self.contactDic objectForKey:@"phoneArr"];
        if (phones.count > 0) {
            for (int i = 0; i < phones.count; i++) {
                [act addButtonWithTitle:[phones objectAtIndex:i]];
                [act showInView:_viewController.view];
            }
        }
        
    }else{
        if (self.card.mobilePhone.length > 0 || self.card.telephone.length > 0) {
            NSArray *mobielArr = [self.card.mobilePhone componentsSeparatedByString:KHH_SEPARATOR];
            for (int i = 0; i < mobielArr.count; i++) {
                [act addButtonWithTitle:[mobielArr objectAtIndex:i]];
               
            }
             [act showInView:_viewController.view];
        }
    
    
    }
    
    [self.popover dismissPopoverAnimated:YES];
}
//发短信
- (void)sendMessage
{
    _type = 2;
    UIActionSheet *actS = [[UIActionSheet alloc] initWithTitle:@"选择号码" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    if (self.isContactCellClick) {
        NSArray *phones = [self.contactDic objectForKey:@"phoneArr"];
        if (phones.count > 0) {
            for (int i = 0; i < phones.count; i++) {
                [actS addButtonWithTitle:[phones objectAtIndex:i]];
                
            }
            [actS showInView:_viewController.view];
        }
        
    }else{
        if (self.card.mobilePhone.length > 0) {
            NSArray *mobielArray = [self.card.mobilePhone componentsSeparatedByString:KHH_SEPARATOR];
            for (int i = 0; i < mobielArray.count; i++) {
                if ([[mobielArray objectAtIndex:i] isValidMobilePhoneNumber]) {
                    [actS addButtonWithTitle:[mobielArray objectAtIndex:i]];
                    
                }
            }
            [actS showInView:_viewController.view];
        }
    
    }
    
    [self.popover dismissPopoverAnimated:YES];
    
}

//发邮件
- (void)takePhotos
{
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        UIImagePickerController *imagePickCtrl = [[UIImagePickerController alloc] init];
//        imagePickCtrl.sourceType = UIImagePickerControllerSourceTypeCamera;
//        imagePickCtrl.delegate = self;
//        imagePickCtrl.allowsEditing = NO;
//        [self.viewController presentModalViewController:imagePickCtrl animated:YES];
//    }
    if (self.card.email.length > 0) {
        [self sendMail];
    }else{
        [self alertWithTitle:nil msg:@"没有电子邮件地址"];
    }
    [self.popover dismissPopoverAnimated:YES];

}
- (void)sendMail{
    Class mfVC = (NSClassFromString(@"MFMailComposeViewController"));
    if (mfVC != nil) {
        if ([mfVC canSendMail]) {
            MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
            mailPicker.mailComposeDelegate = self;
            [mailPicker setSubject:@"eMail主题"];
            NSArray *emails = [self.card.email componentsSeparatedByString:KHH_SEPARATOR];
            [mailPicker setToRecipients:emails];
            [mailPicker setMessageBody:@"123" isHTML:YES];
            [self.viewController presentModalViewController:mailPicker animated:YES];
            
        }else{
            
        }
        
    }else{
        DLog(@"设备不支持发邮件");
    }
}
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    NSString *msg;
    switch (result) {
        case MFMailComposeResultCancelled:
            //取消
            break;
        case MFMailComposeResultSaved:
            msg = @"邮件保存成功";
            [self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultSent:
            msg = @"邮件发送成功";
            [self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultFailed:
            msg = @"邮件发送失败";
            [self alertWithTitle:nil msg:msg];
        default:
            break;
    }
    [self.viewController dismissModalViewControllerAnimated:YES];

}
- (void) alertWithTitle: (NSString *)_title_ msg: (NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_title_
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:KHHMessageSure
                                          otherButtonTitles:nil];
    [alert show];
}
//定位
- (void)goToMapVC
{
    [self.popover dismissPopoverAnimated:YES];
    MapController *mapVC = [[MapController alloc] initWithNibName:nil bundle:nil];
    if (self.card.address.province.length > 0 || (self.card.address.other.length > 0 || self.card.company.name.length > 0)) {
        NSString *address = [NSString stringWithFormat:@"%@%@",self.card.address.province,self.card.address.other];
        mapVC.companyAddr = address;
        mapVC.companyName = self.card.company.name;
        [self.viewController.navigationController pushViewController:mapVC animated:YES];
    }else{
        [[[UIAlertView alloc] initWithTitle:nil
                                   message:NSLocalizedString(@"没有地址或公司名称可定位", nil)
                                  delegate:nil
                         cancelButtonTitle:NSLocalizedString(KHHMessageSure, nil)
                         otherButtonTitles: nil] show];
    }

    
    //    KHHBMapViewController *mapVC = [[KHHBMapViewController alloc] initWithNibName:nil bundle:nil];
//    [self.navigationController pushViewController:mapVC animated:YES];

}
//新建拜访纪录
- (void)newVisitRecoard
{
    KHHVisitRecoardVC *newVisVC = [[KHHVisitRecoardVC alloc] initWithNibName:nil bundle:nil];
    newVisVC.style = KVisitRecoardVCStyleNewBuild;
    newVisVC.isNeedWarn = YES;
    newVisVC.visitInfoCard = self.card;
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
                //messageVC.body = @"发送短信内容1122";
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
