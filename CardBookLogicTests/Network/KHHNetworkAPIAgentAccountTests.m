//
//  KHHNetworkAPIAgentAccountTests.m
//  CardBook
//
//  Created by 孙铭 on 9/4/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPIAgentAccountTests.h"
#import "KHHNetworkAPIAgent+Account.h"
#import "NSObject+Notification.h"

typedef enum {
    TestCaseLoginParameters,
    TestCaseLoginSuccess,
    TestCaseLoginFailure,
    TestCaseCreateAccountParameters,
    TestCaseCreateAccountSuccess,
    TestCaseCreateAccountFailure,
    TestCaseCreateAccountFailureAlreadyCreated,
    TestCaseResetPasswordParameters,
    TestCaseResetPasswordSuccess,
    TestCaseResetPasswordFailure,
    TestCaseChangePasswordParameters,
    TestCaseChangePasswordSuccess,
    TestCaseChangePasswordFailure,
    TestCaseChangePasswordFailureNotMatch,
} TestCaseType;

@interface KHHNetworkAPIAgentAccountTests ()
@property (nonatomic, strong) KHHNetworkAPIAgent *agent;
@property (nonatomic, assign) TestCaseType test;
@property (nonatomic, assign) BOOL running;
@end
@implementation KHHNetworkAPIAgentAccountTests
- (void)setUp
{
    [super setUp];
    self.agent = [[KHHNetworkAPIAgent alloc] init];
    [self.agent authenticateWithUser:@"19535276315" // 888888799826
                              password:@"123456"];
    self.running = YES;
}

- (void)tearDown
{
    self.agent = nil;
    [super tearDown];
}
#pragma mark - Login
//- (void)testAuthentication {
//#warning TODO
//}
- (void)testLoginParameters {
    // login = nil
    STAssertFalse([self.agent login:nil password:@"123456"], nil);
    // login = @""
    STAssertFalse([self.agent login:@"" password:@"123456"], nil);
    // password = nil
    STAssertFalse([self.agent login:@"13188799821" password:nil], nil);
    // password = @""
    STAssertFalse([self.agent login:@"13188799821" password:@""], nil);
//    //
//    STAssertTrue([self.agent login:@"13188799821" password:@"123456"], nil);
}
- (void)testLoginSuccess {
    self.test = TestCaseLoginSuccess;
    [self observeNotificationName:nNetworkLoginSucceeded
                            selector:@"loginSucceeded:"];
    [self observeNotificationName:nNetworkLoginFailed
                            selector:@"loginFailed:"];
    [self.agent clearAuthorizationHeader];
    [self.agent login:@"888888799826"
             password:@"123456"];
    [self waitUntilDone];
}
- (void)testLoginFailure {
    self.test = TestCaseLoginFailure;
    [self observeNotificationName:nNetworkLoginSucceeded
                            selector:@"loginSucceeded:"];
    [self observeNotificationName:nNetworkLoginFailed
                            selector:@"loginFailed:"];
    [self.agent login:@"13188799821"
             password:@"654321"];
    [self waitUntilDone];
}

- (void)loginSucceeded:(NSNotification *)noti {
    DLog(@"[II] self = %@", self);
    STAssertEquals(self.test, TestCaseLoginSuccess, nil);
    NSInteger code = [[noti.userInfo valueForKey:kInfoKeyErrorCode] integerValue];
    STAssertEquals(code, KHHErrorCodeSucceeded, nil);
    [self stopObservingAllNotifications];
    self.running = NO;
}
- (void)loginFailed:(NSNotification *)noti {
    DLog(@"[II] self = %@", self);
    STAssertEquals(self.test, TestCaseLoginFailure, nil);
    NSInteger code = [[noti.userInfo valueForKey:kInfoKeyErrorCode] integerValue];
    STAssertEquals(code, KHHErrorCodeFailed, nil);
    [self stopObservingAllNotifications];
    self.running = NO;
}
#pragma mark - Create account
- (void)testCreateAccountParameters {
    // account = nil
    STAssertFalse([self.agent createAccount:nil password:@"123456"], nil);
    // account = @""
    STAssertFalse([self.agent createAccount:@"" password:@"123456"], nil);
    // password = nil
    STAssertFalse([self.agent createAccount:@"88888799821" password:nil], nil);
    // password = @""
    STAssertFalse([self.agent createAccount:@"88888799821" password:@""], nil);
}
- (void)testCreateAccountSuccess {
    self.test = TestCaseCreateAccountSuccess;
    [self observeNotificationName:KHHNetworkCreateAccountSucceeded
                            selector:@"createAccountSucceeded:"];
    [self observeNotificationName:KHHNotificationCreateAccountFailed
                            selector:@"createAccountFailed:"];
    NSString *account = [NSString stringWithFormat:@"888888%d", arc4random() % 10000];
    DLog(@"[II] account = %@", account);
    [self.agent createAccount:account
                     password:@"123456"];
    [self waitUntilDone];
}
//- (void)testCreateAccountFailure {
//    self.testType = TestCaseCreateAccountFailure;
//    [self addObserverForNotification:KHHNotificationCreateAccountSucceeded
//                            selector:@"createAccountSucceeded:"];
//    [self addObserverForNotification:KHHNotificationCreateAccountFailed
//                            selector:@"createAccountFailed:"];
//    [self.agent createAccount:@"18188799821"
//                     password:@"1"];
//    [self waitUntilDone];
//}
- (void)testCreateAccountFailureAlreadyCreated {
    self.test = TestCaseCreateAccountFailureAlreadyCreated;
    [self observeNotificationName:KHHNetworkCreateAccountSucceeded
                            selector:@"createAccountSucceeded:"];
    [self observeNotificationName:KHHNotificationCreateAccountFailed
                            selector:@"createAccountFailed:"];
    [self.agent createAccount:@"13188799821"
                     password:@"123456"];
    [self waitUntilDone];
}
- (void)createAccountSucceeded:(NSNotification *)noti {
    DLog(@"[II] self = %@", self);
    STAssertEquals(self.test, TestCaseCreateAccountSuccess, nil);
    NSInteger code = [[noti.userInfo valueForKey:kInfoKeyErrorCode] integerValue];
    STAssertEquals(code, KHHErrorCodeSucceeded, nil);
    [self stopObservingAllNotifications];
    self.running = NO;
}
- (void)createAccountFailed:(NSNotification *)noti {
    DLog(@"[II] self = %@", self);
    NSInteger code = [[noti.userInfo valueForKey:kInfoKeyErrorCode] integerValue];
    switch (self.test) {
        case TestCaseCreateAccountFailure:
            STAssertEquals(code, KHHErrorCodeFailed, nil);
            break;
        case TestCaseCreateAccountFailureAlreadyCreated:
            STAssertEquals(code, KHHErrorCodeAlreadyCreated, nil);
            break;
        default:
            STFail([NSString stringWithFormat:@"testType = %d",self.test]);
            break;
    }
    [self stopObservingAllNotifications];
    self.running = NO;
}
#pragma mark - Change password
- (void)testChangePasswordParameters {
    // old = nil
    STAssertFalse([self.agent changePassword:nil toNewPassword:@"123456"], nil);
    // old = @""
    STAssertFalse([self.agent changePassword:@"" toNewPassword:@"123456"], nil);
    // new = nil
    STAssertFalse([self.agent changePassword:@"123456" toNewPassword:nil], nil);
    // new = @""
    STAssertFalse([self.agent changePassword:@"123456" toNewPassword:@""], nil);
}
- (void)testChangePasswordSuccess {
    self.test = TestCaseChangePasswordSuccess;
    [self observeNotificationName:KHHNotificationChangePasswordSucceeded
                            selector:@"changePasswordSucceeded:"];
    [self observeNotificationName:KHHNotificationChangePasswordFailed
                            selector:@"changePasswordFailed:"];
    [self.agent changePassword:@"123456" toNewPassword:@"123456"];
    [self waitUntilDone];
}
//- (void)testChangePasswordFailure {
//    self.testType = TestCaseChangePasswordFailure;
//    [self addObserverForNotification:KHHNotificationChangePasswordSucceeded
//                            selector:@"changePasswordSucceeded:"];
//    [self addObserverForNotification:KHHNotificationChangePasswordFailed
//                            selector:@"changePasswordFailed:"];
//    //    [self.agent resetPasswordWithMobileNumber:@"13188799821"];
//    [self.agent changePassword:@"" toNewPassword:@""];
//    [self waitUntilDone];
//}
- (void)testChangePasswordFailureNotMatch {
    self.test = TestCaseChangePasswordFailureNotMatch;
    [self observeNotificationName:KHHNotificationChangePasswordSucceeded
                            selector:@"changePasswordSucceeded:"];
    [self observeNotificationName:KHHNotificationChangePasswordFailed
                            selector:@"changePasswordFailed:"];
    [self.agent changePassword:@"654321" toNewPassword:@"123456"];
    [self waitUntilDone];
}
- (void)changePasswordSucceeded:(NSNotification *)noti {
    DLog(@"[II] self = %@", self);
    STAssertEquals(self.test, TestCaseChangePasswordSuccess, nil);
    NSInteger code = [[noti.userInfo valueForKey:kInfoKeyErrorCode] integerValue];
    STAssertEquals(code, KHHErrorCodeSucceeded, nil);
    [self stopObservingAllNotifications];
    self.running = NO;
}
- (void)changePasswordFailed:(NSNotification *)noti {
    DLog(@"[II] self = %@", self);
    NSInteger code = [[noti.userInfo valueForKey:kInfoKeyErrorCode] integerValue];
    switch (self.test) {
        case TestCaseChangePasswordFailure:
            STAssertEquals(code, KHHErrorCodeFailed, nil);
            break;
        case TestCaseChangePasswordFailureNotMatch:
            STAssertEquals(code, KHHErrorCodeOldPasswordWrong, nil);
            break;
        default:
            STFail([NSString stringWithFormat:@"testType = %d",self.test]);
            break;
    }
    [self stopObservingAllNotifications];
    self.running = NO;
}
#pragma mark - Reset password
- (void)testResetPasswordParameters {
    // phone = nil
    STAssertFalse([self.agent resetPasswordWithMobileNumber:nil], nil);
    // phone = @""
    STAssertFalse([self.agent resetPasswordWithMobileNumber:@""], nil);
}
//- (void)testResetPasswordSuccess {
//    self.testType = TestCaseResetPasswordSuccess;
//    [self addObserverForNotification:KHHNotificationResetPasswordSucceeded
//                            selector:@"resetPasswordSucceeded:"];
//    [self addObserverForNotification:KHHNotificationResetPasswordFailed
//                            selector:@"resetPasswordFailed:"];
//    [self.agent resetPasswordWithMobileNumber:@"13188799821"];
//    [self waitUntilDone];
//}
- (void)testResetPasswordFailure {
    self.test = TestCaseResetPasswordFailure;
    [self observeNotificationName:KHHNotificationResetPasswordSucceeded
                            selector:@"resetPasswordSucceeded:"];
    [self observeNotificationName:KHHNotificationResetPasswordFailed
                            selector:@"resetPasswordFailed:"];
    [self.agent resetPasswordWithMobileNumber:@"8888373737"]; //不存在导致失败
    [self waitUntilDone];
}
- (void)resetPasswordSucceeded:(NSNotification *)noti {
    DLog(@"[II] self = %@", self);
    STAssertEquals(self.test, TestCaseResetPasswordSuccess, nil);
    NSInteger code = [[noti.userInfo valueForKey:kInfoKeyErrorCode] integerValue];
    STAssertEquals(code, KHHErrorCodeSucceeded, nil);
    [self stopObservingAllNotifications];
    self.running = NO;
}
- (void)resetPasswordFailed:(NSNotification *)noti {
    DLog(@"[II] self = %@", self);
    STAssertEquals(self.test, TestCaseResetPasswordFailure, nil);
    NSInteger code = [[noti.userInfo valueForKey:kInfoKeyErrorCode] integerValue];
    STAssertEquals(code, KHHErrorCodeFailed, nil);
    [self stopObservingAllNotifications];
    self.running = NO;
}
#pragma mark - Utils
- (void)testZZ {
    DLog(@"[II] ZZ the last test", nil);
}
- (void)waitUntilDone {
    DLog(@"[II] testType = %d\n running = %d",
         self.test, self.running);
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    NSDate *limitDate = [NSDate distantFuture];
    while (self.running && [runLoop runMode:NSDefaultRunLoopMode
                                 beforeDate:limitDate]) {
        DLog(@"[II] waiting...", nil);
    }
    DLog(@"[II] DONE!", nil);
}
@end
