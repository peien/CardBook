//
//  KHHSendToViewController.m
//  CardBook
//
//  Created by 王国辉 on 12-8-22.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "KHHSendToViewController.h"
#import "KHHShowHideTabBar.h"
#import <AddressBookUI/AddressBookUI.h>
#import "NSString+Validation.h"
#import "JSTokenField.h"
#import "_Card.h"
#import "KHHNetWorkAPIAgent+Card.h"

#define TheScrollMaxHeight 180
#define TheScrollMinHeight 42
#define TheScrollHeightPadding 5

#define textCardSent NSLocalizedString(@"名片已发出", @"")
#define textOK NSLocalizedString(@"确定", @"")

@implementation CardReceiver
@synthesize name = _name;
@synthesize mobile = _mobile;
- (CardReceiver *)initWithName:(NSString *)name andMobile:(NSString *)mobile
{
    self = [super init];
    if (self) {
        if (name) {
            _name = [[NSString alloc] initWithString:name];
        }
        if (mobile) {
            _mobile = [[NSString alloc] initWithString:mobile];
        }
    }
    return self;
}
@end

@interface KHHSendToViewController ()<ABPeoplePickerNavigationControllerDelegate,JSTokenFieldDelegate>
@property (strong, nonatomic) NSMutableArray *theReceivers;
@property (strong, nonatomic) _Card          *theCard;
@end

@implementation KHHSendToViewController
@synthesize theScroll = _theScroll;
@synthesize theTokenField = _theTokenField;
@synthesize theBgView = _theBgView;
@synthesize theReceivers = _theReceivers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _theReceivers = [[NSMutableArray alloc] init];
        self.title = NSLocalizedString(@"发生至手机", nil);
        [self.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.rightBtn setTitle:@"发送" forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleTokenFieldFrameDidChange:)
                                                     name:JSTokenFieldFrameDidChangeNotification
                                                   object:nil];

    }
    return self;
}
- (void)leftBarClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightBarButtonClick:(id)sender
{
    //发送成功跳转到前一页,thecard 只是声明了下
#ifdef DEBUG
    NSLog(@"发送按钮！");
#endif
    if ([self tokenFieldShouldReturn:self.theTokenField]) {
#ifdef DEBUG
        NSLog(@"接受者：%@", self.theReceivers);
#endif
        if(_theReceivers.count==0){
            [[[UIAlertView alloc] initWithTitle:@"手机号码为空!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            return;
        }
        
        if (self.theCard) {
            //
            if (self.theReceivers.count) {
                //
                NSMutableString *mobileString = [[NSMutableString alloc] init];
                for (CardReceiver *cr in self.theReceivers) {
                    [mobileString appendFormat:@"%@;",cr.mobile];
                }
                NSRange rangeToDel = {mobileString.length - 1, 1};
                [mobileString deleteCharactersInRange:rangeToDel];
                NSString *cardIdString = self.theCard.id.stringValue;
                NSString *versionString = self.theCard.version.stringValue;
                NSString *cardContent = @"";
#ifdef DEBUG
                NSLog(@"接受者mobileString：%@", mobileString);
#endif
//                [_eCardReq sendCard:mobileString
//                             cardId:cardIdString
//                            version:versionString
//                            context:cardContent];
//              替换接口
                
                [[[UIAlertView alloc] initWithTitle:nil
                                             message:textCardSent
                                            delegate:nil
                                   cancelButtonTitle:textOK
                                   otherButtonTitles:nil] show];
            }
        } else {
            // theCard 为 nil
            NSLog(@"theCard 为 %@", self.theCard);
        }
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.theTokenField = [[JSTokenField alloc] initWithFrame:CGRectMake(0, TheScrollHeightPadding, 310, 32)];
    [self.theScroll addSubview:self.theTokenField];
    self.theTokenField.backgroundColor = [UIColor whiteColor];
    self.theTokenField.delegate = self;
    //self.theTokenField.label.text = @"To:";
    self.theTokenField.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    UIButton *theAddButton = [UIButton buttonWithType:UIButtonTypeCustom];
    theAddButton.frame = CGRectMake(0, 1, 45, 40);
    //[theAddButton setTitle:NSLocalizedString(@"添加", nil) forState:UIControlStateNormal];
    [theAddButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [theAddButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [theAddButton setBackgroundImage:[[UIImage imageNamed:@"addBtnimg.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:0] forState:UIControlStateNormal];
    [theAddButton addTarget:self action:@selector(theAddButtonTapped) forControlEvents:UIControlEventTouchDown];
    self.theTokenField.textField.rightView = theAddButton;
    self.theTokenField.textField.rightViewMode = UITextFieldViewModeAlways;
    
    theBgView_y = self.theBgView.frame.origin.y;
    theScroll_y = self.theScroll.frame.origin.y;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [KHHShowHideTabBar hideTabbar];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _theReceivers = nil;
    _theBgView = nil;
    _theScroll = nil;
    _theTokenField = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)theAddButtonTapped
{
    ABPeoplePickerNavigationController *aPeoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    aPeoplePicker.peoplePickerDelegate = self;
    if ([UIViewController instancesRespondToSelector:@selector(presentViewController:animated:completion:)]) {
        // 5.0 以上
        [self presentViewController:aPeoplePicker animated:YES completion:nil];
    } else{
        [self presentModalViewController:aPeoplePicker animated:YES];
    }
}
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    if ([UIViewController instancesRespondToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        // 5.0 以上
        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    } else{
        [peoplePicker dismissModalViewControllerAnimated:YES];
    }

}
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    // 从通讯录获取姓名和电话
    NSString *aName = (__bridge NSString *)ABRecordCopyCompositeName(person);
    ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSString *aPhone = nil;
    CFIndex n = ABMultiValueGetCount(phones);
    if (0 == n) {
        [[[UIAlertView alloc]
           initWithTitle:nil
           message:NSLocalizedString(@"该联系人无电话", nil)
           delegate:nil
           cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
           otherButtonTitles:nil]
           show];
        CFRelease(phones);
        return NO;
    }
    if (n == 1) {
        NSString *aPhoneRef = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phones,0);
        aPhone = [self retrievePhoneNumberFromString:aPhoneRef];
        if (aPhone.isRegistrablePhone) {
            //
            //            [peoplePicker dismissViewControllerAnimated:YES completion:nil];
            if ([UIViewController instancesRespondToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
                // 5.0 以上
                [peoplePicker dismissViewControllerAnimated:YES completion:nil];
            } else{
                [peoplePicker dismissModalViewControllerAnimated:YES];
            }
            // 生成Receiver并添加为token
           CardReceiver *aReceiver = [[CardReceiver alloc] initWithName:aName andMobile:aPhone];
           [self.theTokenField addTokenWithTitle:(aName.length?aName:aPhone) representedObject:aReceiver];
        } else {
            //
            [[[UIAlertView alloc]
               initWithTitle:nil
               message:NSLocalizedString(@"该联系人的电话号码不是有效的手机号", nil)
               delegate:nil
               cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
               otherButtonTitles:nil]
               show];
        }
        return NO;
    }
    return YES;

}
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    NSString *aName = (__bridge NSString *)ABRecordCopyCompositeName(person);
    NSString *aPhone = nil;
    ABMultiValueRef phones = ABRecordCopyValue(person, property);
    if (identifier != kABMultiValueInvalidIdentifier) {
        NSString *aPhoneRef = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phones, identifier);
        aPhone = [self retrievePhoneNumberFromString:aPhoneRef];
        if (aPhone.isRegistrablePhone) {
            //
            //            [peoplePicker dismissViewControllerAnimated:YES completion:nil];
            if ([UIViewController instancesRespondToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
                // 5.0 以上
                [peoplePicker dismissViewControllerAnimated:YES completion:nil];
            } else{
                [peoplePicker dismissModalViewControllerAnimated:YES];
            }
            // 生成Receiver并添加为token
           CardReceiver *aReceiver = [[CardReceiver alloc] initWithName:aName andMobile:aPhone];
           [self.theTokenField addTokenWithTitle:(aName.length?aName:aPhone) representedObject:aReceiver];
        } else {
            //
            [[[UIAlertView alloc]
               initWithTitle:nil
               message:NSLocalizedString(@"该电话号码不是有效的手机号", nil)
               delegate:nil
               cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
               otherButtonTitles:nil]
               show];
        }
       
    }
    return NO;

}

- (NSString *)retrievePhoneNumberFromString:(NSString *)string
{
    NSMutableString *aPhone = [NSMutableString stringWithCapacity:11];
    NSCharacterSet *numberSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSScanner *scanner = [NSScanner scannerWithString:string];
    while ([scanner isAtEnd] == NO) {
        NSString *tmpString = @"";
        [scanner scanUpToCharactersFromSet:numberSet intoString:NULL];
        if([scanner scanCharactersFromSet:numberSet intoString:&tmpString])
            [aPhone appendString:tmpString];
    }
    return aPhone;
}
- (void)handleTokenFieldFrameDidChange:(NSNotification *)note
{
	if ([[note object] isEqual:self.theTokenField])
	{
		[UIView animateWithDuration:1.0f
						 animations:^{
                             [self resizeTheScroll];
                             CGFloat theContentHeight = self.theScroll.contentSize.height;
                             CGFloat theScrollHeight = self.theScroll.frame.size.height;
                             if (theContentHeight > theScrollHeight) {
                                 CGPoint newPoint = {0, theContentHeight - theScrollHeight};
                                 self.theScroll.contentOffset = newPoint;
                             }
						 }
						 completion:nil];
	}
}
- (void)resizeTheScroll
{
    CGSize theFieldSize = self.theTokenField.frame.size;
    CGSize theContentSize = self.theScroll.contentSize;
    theContentSize.height = theFieldSize.height + (TheScrollHeightPadding * 2);
    self.theScroll.contentSize = theContentSize;
    
    if (theContentSize.height >= TheScrollMinHeight && theContentSize.height <= TheScrollMaxHeight) {
        CGRect aFrame = self.theScroll.frame;
        aFrame.size.height = theContentSize.height;
        self.theScroll.frame = aFrame;
    }
}
- (void)tokenFieldDidEndEditing:(JSTokenField *)tokenField
{
    // 空着，否则会有默认操作
}

- (BOOL)makeTokenAndReceiverFromString:(NSString *)string
{
    if (string.length > 1)
	{
        NSString *aPhone = [self retrievePhoneNumberFromString:string];
        if (aPhone.isRegistrablePhone) {
            // 生成Receiver并添加为token
            CardReceiver *aReceiver = [[CardReceiver alloc] initWithName:@"" andMobile:aPhone];
            [self.theTokenField addTokenWithTitle:aReceiver.mobile representedObject:aReceiver];
            return YES;
        } else {
            //
            [[[UIAlertView alloc]
               initWithTitle:nil
               message:NSLocalizedString(@"未输入可用的手机号", nil)
               delegate:nil
               cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
               otherButtonTitles:nil]
               show];
        }
        return NO;
	}
    return YES;
}
- (BOOL)tokenFieldShouldReturn:(JSTokenField *)tokenField {
    NSString *rawStr = [[tokenField textField] text];
#ifdef DEBUG
    NSLog(@"tokenField textField:%@, length:%d",rawStr,rawStr.length);
#endif
    return [self makeTokenAndReceiverFromString:rawStr];
}
- (void)tokenField:(JSTokenField *)tokenField didAddToken:(NSString *)title representedObject:(id)obj
{
    CardReceiver *aReceiver = (CardReceiver *)obj;
	[self.theReceivers addObject:aReceiver];
	NSLog(@"Added token for < %@ : %@ >\n%@", title, obj, self.theReceivers);
}

- (void)tokenField:(JSTokenField *)tokenField didRemoveTokenAtIndex:(NSUInteger)index
{
	[self.theReceivers removeObjectAtIndex:index];
	NSLog(@"Deleted token %d\n%@", index, self.theReceivers);
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
