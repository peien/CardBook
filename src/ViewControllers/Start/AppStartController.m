//
//  AppStartController.m
//  CardBook
//
//  Created by Sun Ming on 12-10-24.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "AppStartController.h"
#import "UIViewController+SM.h"
#import "KHHKeys.h"
#import "KHHLog.h"
#import "KHHNetworkAPI.h"
#import "KHHNotifications.h"
#import "IntroViewController.h"
#import "LaunchImageViewController.h"
#import "AppLoginController.h"

#import "LoginActionViewController.h"
#import "KHHDefaults.h"
#import "KHHNetworkAPIAgent+Statistics.h"
#import "Reachability.h"
#import "KHHFilterPopup.h"
#import "KHHUser.h"
#import "KHHManagementViewController.h"


#define titleCreateAccountSucceeded NSLocalizedString(@"用户注册成功", nil)
#define titleCreateAccountFailed    NSLocalizedString(@"用户注册失败", nil)
#define titleLoginFailed            NSLocalizedString(@"登录失败", nil)
#define titleResetPasswordSucceeded NSLocalizedString(@"重置密码成功", nil)
#define titleResetPasswordFailed    NSLocalizedString(@"重置密码失败", nil)
#define titleSyncFailed             NSLocalizedString(@"同步数据出错", nil)
#define textNotAllDataAvailable     NSLocalizedString(@"部分数据可能暂时无法使用。", nil)
#define textWillAutoLogin           NSLocalizedString(@"将自动登录...", nil)
#define textWillSync                NSLocalizedString(@"登录成功,为了能正常使用软件，强烈建议您花点时间与服务器同步一下数据,是否立即与服务器同步数据?", nil)

static const NSTimeInterval AppStart_TransitionDuration = 0.5f;
static const UIViewAnimationOptions AppStart_AnimationOptions =UIViewAnimationOptionTransitionCrossDissolve;

#pragma mark -
@interface AppStartController () <KHHFilterPopupDelegate>
@property (nonatomic, strong) UIViewController *actionController;
@property (nonatomic, strong) UIViewController *createAccountController;

@property (nonatomic, strong) UIViewController *previousController;
@property (nonatomic, strong) UIViewController *introController;
@property (nonatomic, strong) UIViewController *launchController;
@property (nonatomic, strong) NSDictionary     *OfflineLoginUserInfoDict;
@property (nonatomic, strong) UIViewController *manageController;
@end

#pragma mark - 动作
@interface AppStartController (Actions)
- (void)createAccount:(NSNotification *)noti;// 注册
- (void)login;
- (void)resetPassword:(NSNotification *)noti;
- (void)sync;
@end
#pragma mark - 界面切换
@interface AppStartController (ShowViews)
- (void)showActionView;
- (void)showCreateAccountView;
- (void)showIntroView;
- (void)showLaunchImage;
- (void)showLoginView;

@end

@implementation AppStartController {
    Reachability *r;
}
@synthesize OfflineLoginUserInfoDict = _OfflineLoginUserInfoDict;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.actionController = [[LoginActionViewController alloc]
                                 initWithNibName:nil
                                 bundle:nil];
        
        self.changeActionTitleDelegate = (LoginActionViewController *)self.actionController;
        
        AppRegisterController *registView = [[AppRegisterController alloc]
                                             initWithNibName:nil
                                             bundle:nil];
        registView.delegate = self;
        self.createAccountController = [[UINavigationController alloc]
                                        initWithRootViewController:registView];
        AppLoginController *loginView  = [[AppLoginController alloc]
                                          initWithNibName:nil
                                          bundle:nil];
        loginView.delegate = self;
        self.loginController = [[UINavigationController alloc]
                                initWithRootViewController:loginView];
        
        [self addChildViewController:self.actionController];
        
        [self addChildViewController:self.createAccountController];
        
        [self addChildViewController:self.loginController];
        
        KHHManagementViewController *manPro = [[KHHManagementViewController alloc]initWithNibName:@"KHHManagementViewController" bundle:nil];
        self.manageController = [[UINavigationController alloc]initWithRootViewController:manPro];
        [self addChildViewController:self.manageController];
        
        [self observeNotificationName:nAppSkipIntro
                             selector:@"showLoginView"];
        [self observeNotificationName:nAppShowPreviousView
                             selector:@"showPreviousView"];
        // 登录
        [self observeNotificationName:nAppLogMeIn
                             selector:@"login"];
        [self observeNotificationName:nNetworkLoginSucceeded
                             selector:@"handleNetworkLoginSucceeded:"];
        [self observeNotificationName:nNetworkLoginFailed
                             selector:@"handleNetworkLoginFailed:"];
        // 注册
        [self observeNotificationName:nAppShowCreateAccount
                             selector:@"showCreateAccountView"];
        [self observeNotificationName:nAppCreateThisAccount
                             selector:@"createAccount:"];
        [self observeNotificationName:nNetworkCreateAccountSucceeded
                             selector:@"handleNetworkCreateAccountSucceeded:"];
        [self observeNotificationName:nNetworkCreateAccountFailed
                             selector:@"handleNetworkCreateAccountFailed:"];
        
        // 重置密码
        [self observeNotificationName:nAppResetMyPassword
                             selector:@"resetPassword:"];
        [self observeNotificationName:nNetworkResetPasswordSucceeded
                             selector:@"handleNetworkResetPasswordSucceeded:"];
        [self observeNotificationName:nNetworkResetPasswordFailed
                             selector:@"handleNetworkResetPasswordFailed:"];
        // 同步
        [self observeNotificationName:nDataSyncAllSucceeded
                             selector:@"handleSyncSucceeded:"];
        [self observeNotificationName:nDataSyncAllFailed
                             selector:@"handleSyncFailed:"];
        
        //save loginToServer
        [self observeNotificationName:KHHSaveLogin
                             selector:@"saveLoginToServer"];
        
    }
    return self;
}

- (void)saveLoginToServer{
    [((KHHNetworkAPIAgent *)_agent) saveToken];
}

- (void)dealloc {
    
    [self stopObservingAllNotifications];
}//dealloc

- (void)changeFrom:(int)from to:(int)to leftDown:(Boolean)leftDown;
{
    UIViewAnimationOptions optionsPro = AppStart_AnimationOptions;

    if (leftDown) {
        optionsPro = UIViewAnimationOptionTransitionFlipFromLeft;
    }else{
        optionsPro = UIViewAnimationOptionTransitionFlipFromRight;
    }
    
    
    UIViewController *fromV = [self.childViewControllers objectAtIndex:from];
    UIViewController *toV = [self.childViewControllers objectAtIndex:to];
    [self transitionFromViewController:fromV toViewController:toV duration:0.5 options:optionsPro animations:nil completion:nil];
}

#pragma mark - 从这里开始
- (void)viewDidLoad
{
    [super viewDidLoad];
    DLog(@"[II] viewDidLoad...");
    
    [self.view addSubview:self.actionController.view];
    [self.view addSubview:self.createAccountController.view];
    [self.view addSubview:self.loginController.view];
    [self.view addSubview:self.manageController.view];
    // 先显示 Launch Image。
    //  [self showLaunchImage];
    
    // 判断是否是首次启动。首次启动显示引导页。
    if ([self.defaults isFirstLaunch]) {
        [self showIntroView];
        return;
    }
    
    // 不是首次启动
    // 如果满足条件则自动登录，否则手动登录。
    
//    if ([KHHUser shareInstance].username&&[KHHUser shareInstance].password) {
//        [self login];
//    }else{
//        [self showLoginView];
//    }
    if (![KHHUser shareInstance].sessionId||[@"" isEqualToString:[KHHUser shareInstance].sessionId]) {
        [self showLoginView];
    }else{
        [self changeToManageView];
    }
    
    //    if ([self.defaults isAutoLogin]   // 是否允许自动登录
    //        && [self.defaults isLoggedIn] // 是否已登录
    //        && self.defaults.currentUser.length
    //        && self.defaults.currentPassword.length) {
    //        // 自动登录
    //        [self login];
    //    } else {
    //        // 手动登录
    //        [self showLoginView];
    //    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (KHHAlertSync == alertView.tag) {
        if (0 == buttonIndex) {
            //同步
            [self sync];
        }else {
            // 进主界面。
            [self postNowNotificationName:nAppShowMainView];
        }
        return;
    }
    
    NSString *title = alertView.title;
    if ([title isEqualToString:titleCreateAccountSucceeded]) {
        [self login];//注册成功, 直接登录。
    } else if ([title isEqualToString:titleCreateAccountFailed]
               || [title isEqualToString:titleResetPasswordFailed]
               || [title isEqualToString:titleResetPasswordSucceeded]) {
        [self showPreviousView];
    } else if ([title isEqualToString:titleLoginFailed]) {
        [self showLoginView];
    }
}


- (void)transitionToViewController:(UIViewController *)toViewController
                           options:(UIViewAnimationOptions)options {
    
    
    if (self.childViewControllers.count) {
        UIViewController *fromVC = self.childViewControllers.lastObject;
        
        if (!toViewController.parentViewController) {
            [self addChildViewController:toViewController];
            [self.view addSubview:toViewController.view];
            //[self.view addSubview:toViewController.view];
        }
        
        [self transitionFromViewController:fromVC
                          toViewController:toViewController
                                  duration:AppStart_TransitionDuration
                                   options:options
                                animations:nil
                                completion:^(BOOL finished) {
//                                    self.previousController = fromVC;
//                                    if (finished) {
//                                        [fromVC.view removeFromSuperview];
//                                        [fromVC removeFromParentViewController];
//                                    }
                                }];
        
    } else {
        [self addChildViewController:toViewController];
        [self.view addSubview:toViewController.view];
    }
       
    
}

- (void)transitionToViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
                           options:(UIViewAnimationOptions)options
{
    if (!toViewController.parentViewController) {
        [self addChildViewController:toViewController];
        [self.view addSubview:toViewController.view];
        //[self.view addSubview:toViewController.view];
    }
    [self transitionFromViewController:fromViewController
                      toViewController:toViewController
                              duration:AppStart_TransitionDuration
                               options:options
                            animations:nil
                            completion:^(BOOL finished) {
                               
                            }];

}


- (void)showPreviousView {
    UIViewController *currentController = self.childViewControllers.lastObject;
    UIViewAnimationOptions options = AppStart_AnimationOptions;
    if (currentController == self.createAccountController) {
        options = UIViewAnimationOptionTransitionFlipFromRight;
    } else if (currentController == self.actionController) {
        options = UIViewAnimationOptionTransitionFlipFromLeft;
    }
    
    [self transitionToViewController:self.previousController
                             options:options];
}




- (void)changeToLoginView:(Boolean)isRightDown
{
    UIViewAnimationOptions options;
    if (isRightDown) {
        options = UIViewAnimationOptionTransitionFlipFromLeft;
    }else{
        options = UIViewAnimationOptionTransitionFlipFromRight;
    }
    
   
//   
//    [self transitionToViewController:self.actionController toViewController: self.loginController options:options];
//    [self transitionToViewController:self.loginController
//                             options:options];
    //[_changeActionTitleDelegate changeToTitle:title];
}

#pragma mark - for actionView

- (void)changeToActionView:(int)from title:(NSString *)title leftDown:(Boolean)leftDown
{
    [self changeFrom:from to:0 leftDown:leftDown];
    [_changeActionTitleDelegate changeToTitle:title];
}


- (void)alertInAction:(NSDictionary *)dic
{
    [_changeActionTitleDelegate showAlert:dic[@"companies"]];
}

- (void)changeToCreateAccountView
{
   
    [self changeFrom:0 to:1 leftDown:NO];
}

- (void)changeToManageView
{
//    KHHManagementViewController *manPro = [[KHHManagementViewController alloc]initWithNibName:@"KHHManagementViewController" bundle:nil];  UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:manPro];
//    nav.view.alpha = 0.0;
//    [self addChildViewController:nav];
//    [self.view addSubview:nav.view];
    
    UIViewController *fromVC = self.actionController;
    
    [UIView animateWithDuration: 0.5
                     animations:^{
                         fromVC.view.alpha = 0.0;
                         self.manageController.view.alpha = 1.0;
                         [self setChildHidden];
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self setChildRemove];
                             [((KHHManagementViewController *)((UINavigationController *)self.manageController).childViewControllers[0]) doInitWithUser];
                         }
                        
//                         [fromVC.view removeFromSuperview];
//                         [fromVC removeFromParentViewController];
                     }];
    
}


- (void)changeTitle:(NSString *)title
{
    [_changeActionTitleDelegate changeToTitle:title];
}

- (void)setChildHidden
{
    if (self.introController) {
        self.introController.view.alpha = 0.0;
    }
    if (self.createAccountController) {
        self.createAccountController.view.alpha = 0.0;
    }
    if (self.loginController) {
        self.loginController.view.alpha = 0.0;
    }
    if (self.actionController) {
        self.actionController.view.alpha = 0.0;
    }
}

- (void)setChildRemove
{
    if (self.introController) {
        [self.introController.view removeFromSuperview];
        [self.introController removeFromParentViewController];
    }
    if (self.createAccountController) {
        [self.createAccountController.view removeFromSuperview];
        [self.createAccountController removeFromParentViewController];
    }
    if (self.loginController) {
        [self.loginController.view removeFromSuperview];
        [self.loginController removeFromParentViewController];
    }
    if (self.actionController) {
        [self.actionController.view removeFromSuperview];
        [self.actionController removeFromParentViewController];
    }
}


@end

#pragma mark - 动作
@implementation AppStartController (Actions)
- (void)createAccount:(NSNotification *)noti {
    
    [self.defaults setLoggedIn:NO];
    
    // 切换到 ActionView
    [self showActionView];
    
    //发送正在注册消息
   // [self postASAPNotificationName:nAppCreatingAccount];
    
    // 调接口
    NSDictionary *dict = noti.userInfo;
    [self.agent createAccount:dict];
}

- (void)login {
    
    
    // 切换到 ActionView
    // [self showActionView];
    
   // [[KHHDataNew sharedData]doLogin: [KHHUser shareInstance].username password:[KHHUser shareInstance].password  delegate:self];
    // 发“校验网络”消息
    //[self postASAPNotificationName:nAppCheckNetwork];
    
    //注册网络状态变化接受广播(网络为unknown时就去注册，其它状态就不去注册广播了)
    //     r = [Reachability reachabilityWithHostname:@"www.apple.com"];
    //
    //    AFNetworkReachabilityStatus state = [[NetClient sharedClient] networkReachabilityStatus];
    //    if ([r currentReachabilityStatus] == NotReachable) {
    //        [self observeNotificationName:AFNetworkingReachabilityDidChangeNotification selector:@"handleNetworkStatusChanged:"];
    //    }else {
    //        //登录
    //        [self loginWithNetworkStatus:state];
    //    }
}

-(void) handleNetworkStatusChanged:(NSDictionary *) noti {
    //关闭广播接受
    [self stopObservingNotificationName:AFNetworkingReachabilityDidChangeNotification];
    AFNetworkReachabilityStatus state = [[NetClient sharedClient] networkReachabilityStatus];
    [self loginWithNetworkStatus:state];
}

//AFNetworkReachabilityStatusNotReachable 时离线登录
//AFNetworkReachabilityStatusReachableViaWiFi及AFNetworkReachabilityStatusReachableViaWWAN时在线登录
-(void) loginWithNetworkStatus:(AFNetworkReachabilityStatus) status {
    // 调接口
    NSString *user = self.defaults.currentUser;
    NSString *password = self.defaults.currentPassword;
    //添加离线登录
    [[KHHDataNew sharedData]doLogin: user password:password  delegate:self];
    //    if ([r currentReachabilityStatus] == NotReachable) {
    //        //离线登录
    //        // 发“离线登录”消息
    //        [self postASAPNotificationName:nAppOfflineLoggingIn];
    //        [self offlineLogin:user password:password];
    //    }else {
    //        //在线登录
    //        // 发“校验网络”消息
    //        [self postASAPNotificationName:nAppLoggingIn];
    //        [self.agent login:user
    //                 password:password];
    //    }
}

- (void)resetPassword:(NSNotification *)noti {
    DLog(@"[II] 开始重置密码！");
    // 切换到 ActionView
    [self showActionView];
    
    // 发送正在重置消息
    [self postASAPNotificationName:nAppResettingPassword];
    
    // 调接口
    DLog(@"[II] 调用重置密码接口！");
    NSString *user = noti.userInfo[kInfoKeyUser];
    [self.agent resetPassword:user];
}

- (void)sync {
    // DLog(@"[II] 开始同步！");
    [self postASAPNotificationName:nAppSyncing];
    // 开始同步数据
    [self.data removeContext];
    [self.data startSyncAllData];
}

#pragma mark - Handlers
- (void)handleNetworkCreateAccountSucceeded:(NSNotification *)noti {
    // 注册成功
    DLog(@"[II] 注册成功，保存用户数据。");
    // 保存用户数据: id,mobile,password
    [self.defaults saveLoginOrRegisterResult:noti.userInfo];
    [self postASAPNotificationName:KHHSaveLogin];
    // 自动登录
    [self alertWithTitle:titleCreateAccountSucceeded
                 message:textWillAutoLogin];
}
- (void)handleNetworkCreateAccountFailed:(NSNotification *)noti {
    DLog(@"[II] 注册失败！");
    KHHErrorCode code = [noti.userInfo[kInfoKeyErrorCode] integerValue];
    NSString *message = noti.userInfo[kInfoKeyErrorMessage];
    [self alertWithTitle:titleCreateAccountFailed
                 message:MessageWithActionAndCode(code, message)];
}
- (void)handleNetworkLoginSucceeded:(NSNotification *)noti {
    // 登陆成功
    BOOL isFirstLogin = [self isFirstLogin];
    // 保存用户数据: id,mobile,password,isAutoReceive
    [self saveUserInfoToDefaults:noti.userInfo];
    // 开始同步
    if (isFirstLogin) {
        //提示要同步数据
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:textWillSync
                                                       delegate:self
                                              cancelButtonTitle:KHHMessageSure
                                              otherButtonTitles:KHHMessageCancle,nil];
        alert.tag = KHHAlertSync;
        [alert show];
    }else {
        //直接进入
        [self handleSyncSucceeded:nil];
    }
}

- (void)handleNetworkLoginFailed:(NSNotification *)noti {
    DLog(@"[II] 登录失败！");
    KHHErrorCode code = [noti.userInfo[kInfoKeyErrorCode] integerValue];
    NSString *message = noti.userInfo[kInfoKeyErrorMessage];
    if (KHHErrorCodeConnectionOffline == code) {
        // 无网络接着离线登录
        [self loginWithNetworkStatus:AFNetworkReachabilityStatusNotReachable];
        //        [self postASAPNotificationName:nAppShowMainView];
    }else {
        [self.defaults setLoggedIn:NO];
        [self alertWithTitle:titleLoginFailed
                     message:MessageWithActionAndCode(code, message)];
    }
}



//判断是否第一次在手机上登录
-(BOOL) isFirstLogin
{
    NSArray* historyList = [self.defaults historyUserList];
    if (!historyList) {
        return YES;
    }
    
    for (NSDictionary* dict in historyList) {
        if (!dict) {
            continue;
        }
        
        NSString* user = dict[KHHDefaultsKeyUser];
        if ([user isEqualToString:[self.defaults currentUser]]) {
            return NO;
        }
    }
    
    return YES;
}

//离线登录
-(void) offlineLogin:(NSString *) user password:(NSString *) password {
    if ([self isOfflineLoginSucess]) {
        //离线登录成功
        //更新用户信息
        [self saveOfflineLoginUserInfo];
        //进入主界面
        [self postNowNotificationName:nAppShowMainView];
    }else {
        //离线登录失败
        //返回
        self.OfflineLoginUserInfoDict = nil;
        [self alertWithTitle:titleLoginFailed message:@"离线登录失败!"];
    }
}

//保存离线登录用户数据
-(void) saveOfflineLoginUserInfo {
    if (!self.OfflineLoginUserInfoDict) {
        return;
    }
    
    NSMutableDictionary *saveInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
    saveInfo[kInfoKeyAuthorizationID] = [self.OfflineLoginUserInfoDict objectForKey:KHHDefaultsKeyAuthorizationID];
    saveInfo[kInfoKeyAutoReceive] = [self.OfflineLoginUserInfoDict objectForKey:KHHDefaultsKeyAutoReceive];
    NSDictionary *companyinfo = [[self.OfflineLoginUserInfoDict objectForKey:KHHDefaultsKeyCompanyList] objectAtIndex:0];
    saveInfo[kInfoKeyCompanyID] = companyinfo[KHHDefaultsKeyID];
    saveInfo[kInfoKeyDepartmentID] = companyinfo[KHHDefaultsKeyDepartmentID];
    saveInfo[kInfoKeyPermission] = companyinfo[KHHDefaultsKeypermission];
    
    //保存到defaults
    [self saveUserInfoToDefaults:saveInfo];
}

-(void) saveUserInfoToDefaults:(NSDictionary *) dict {
    [self.defaults saveLoginOrRegisterResult:dict];
    [self postASAPNotificationName:KHHSaveLogin];
    [self.defaults setLoggedIn:YES];
    // http鉴权
    [self.agent authenticateWithUser:self.defaults.currentAuthorizationID.stringValue
                            password:self.defaults.currentPassword];
}


//离线登录，判断输入的用户名与密码是否正确
-(BOOL) isOfflineLoginSucess
{
    if (!self.defaults.currentUser || !self.defaults.currentPassword) {
        return NO;
    }
    
    NSArray* historyList = [self.defaults historyUserList];
    if (!historyList) {
        return NO;
    }
    
    for (NSDictionary* dict in historyList) {
        if (!dict) {
            continue;
        }
        
        NSString* user = dict[KHHDefaultsKeyUser];
        NSString* psw  = dict[KHHDefaultsKeyPassword];
        if ([user isEqualToString:[self.defaults currentUser]] &&
            [psw isEqualToString:[self.defaults currentPassword]]) {
            //保存用户信息
            self.OfflineLoginUserInfoDict = [[NSDictionary alloc] initWithDictionary:dict];
            return YES;
        }
    }
    
    return NO;
}

- (void)handleNetworkResetPasswordSucceeded:(NSNotification *)noti
{
    DLog(@"[II] 重置密码成功！");
    [self alertWithTitle:titleResetPasswordSucceeded
                 message:NSLocalizedString(@"新密码将通过短信发送给您，请查收！", nil)];
}
- (void)handleNetworkResetPasswordFailed:(NSNotification *)noti {
    DLog(@"[II] 重置密码失败！");
    KHHErrorCode code = [noti.userInfo[kInfoKeyErrorCode] integerValue];
    NSString *message = noti.userInfo[kInfoKeyErrorMessage];
    [self alertWithTitle:titleResetPasswordFailed
                 message:MessageWithActionAndCode(code, message)];
}
- (void)handleSyncSucceeded:(NSNotification *)noti {
    // 进主界面。
    [self postNowNotificationName:nAppShowMainView];
}
- (void)handleSyncFailed:(NSNotification *)noti {
    [self alertWithTitle:titleSyncFailed
                 message:textNotAllDataAvailable];
    // 进主界面。
    [self postNowNotificationName:nAppShowMainView];
}
@end

#pragma mark - 界面切换
@implementation AppStartController (ShowViews)


- (void)showActionView {
    UIViewController *currentController = self.childViewControllers.lastObject;
    if (currentController == self.actionController) {
        return;
    }
    UIViewAnimationOptions options = UIViewAnimationOptionTransitionFlipFromRight;
    [self transitionToViewController:self.actionController
                             options:options];
}
- (void)showCreateAccountView {
    //弹出选择框，供用户选择是注册什么账号（个人、公司）
    NSArray *array = [[NSArray alloc] initWithObjects:KHHMessagePersonalAccount, KHHMessageCompanyAccount, nil];
    [[KHHFilterPopup shareUtil] showPopUp:array index:0 Title:@"选择注册类型" delegate:self];
}
- (void)showIntroView {
    IntroViewController *toVC = [[IntroViewController alloc] init];
    toVC.isFromStartUp = YES;
    self.introController = toVC;  //  [self addChildViewController:self.introController];
    [self.view addSubview:self.introController.view];
    //    [UIView animateWithDuration: 0.5
    //                     animations:^{
    //                         self.loginController.view.alpha = 1.0;
    //                        // self.launchController.view.alpha = 0.0;
    //                     }
    //                     completion:^(BOOL finished) {
    //                         [self.launchController.view removeFromSuperview];
    //                        // [self.launchController removeFromParentViewController];
    //                     }];
    //    [self transitionToViewController:toVC
    //                             options:AppStart_AnimationOptions];
}
- (void)showLaunchImage {
    UIViewController *toVC = [[LaunchImageViewController alloc]
                              initWithNibName:nil
                              bundle:nil];
    self.launchController = toVC;
    [self transitionToViewController:toVC
                             options:AppStart_AnimationOptions];
}
- (void)showLoginView {
    self.loginController.view.alpha = 0.0;
    
    if (self.introController) {
        
        self.loginController.view.alpha = 0.0;
    } else {
        
        self.loginController.view.alpha = 1.0;
    }
    [self.view addSubview:self.loginController.view];
//    [self addChildViewController:self.loginController];
//    [self.view addSubview:self.loginController.view];
    if (self.introController) {
        [UIView animateWithDuration: 0.5
                         animations:^{
                             self.loginController.view.alpha = 1.0;
                             self.introController.view.alpha = 0.0;
                         }
                         completion:^(BOOL finished) {
                             [self.introController.view removeFromSuperview];
                             [self.introController removeFromParentViewController];
                         }];
        
    }
    //    UIViewAnimationOptions options = UIViewAnimationOptionTransitionCrossDissolve;
    //    [self transitionToViewController:self.loginController
    //                             options:options];
}






- (void)loginForUISuccess:(NSDictionary *)userInfo
{
    

}

@end

