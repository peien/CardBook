//
//  KHHNetworkAPIAgentEnterpriseManagementTests.m
//  CardBook
//
//  Created by 孙铭 on 9/10/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPIAgentEnterpriseManagementTests.h"
#import "KHHNetworkAPIAgent+Card.h"
#import "KHHNetworkAPIAgent+EnterpriseManagement.h"
#import "NSObject+Notification.h"

typedef enum {
    TestCaseListDepartments,
    //    TestCase,

} TestCaseType;

@interface KHHNetworkAPIAgentEnterpriseManagementTests ()
@property (nonatomic, assign) TestCaseType test;
@property (nonatomic, assign) BOOL running;
@property (nonatomic, strong) KHHNetworkAPIAgent *agent;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation KHHNetworkAPIAgentEnterpriseManagementTests
- (void)setUp
{
    [super setUp];
    self.agent = [[KHHNetworkAPIAgent alloc] init];
    [self.agent authenticateWithUser:@"19535276315" // 888888799826
                              password:@"123456"];
    self.running = YES;
    NSURL *modelURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"CardBook" withExtension:@"momd"];
    self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    self.persistentStoreCoordinator =[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    NSError *error;
    NSURL *storeURL = [NSURL fileURLWithPath:[@"/Users/msun/Desktop/CardBookTest.sqlite" stringByExpandingTildeInPath]];
    DLog(@"[II] storeURL = %@", storeURL);
    [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil
                                                            URL:storeURL
                                                        options:nil
                                                          error:&error];
    DLog(@"[II] error = %@", error);
    self.managedObjectContext = [[NSManagedObjectContext alloc] init];
    [self.managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
}
- (void)tearDown
{
    NSError *error;
    [self.managedObjectContext save:&error];
    DLog(@"[II] error = %@", error);
    self.agent = nil;
    self.managedObjectContext = nil;
    self.persistentStoreCoordinator = nil;
    self.managedObjectModel = nil;
    [super tearDown];
}
#pragma mark -
- (void)testListDepartments {
    [self observeNotificationName:KHHNotificationListDepartmentsSucceeded
                     selector:@"actionSucceeded:"];
    [self observeNotificationName:KHHNotificationListDepartmentsFailed
                     selector:@"actionFailed:"];
    [self.agent listDepartments];
    [self waitUntilDone];
}
#pragma mark - Utils
- (void)testZZ {
    DLog(@"[II] ZZ the last test", nil);
}
- (void)actionSucceeded:(NSNotification *)noti {
    [self stopObservingAllNotifications];
    NSInteger code = [[noti.userInfo valueForKey:kInfoKeyErrorCode] integerValue];
    STAssertEquals(code, KHHErrorCodeSucceeded, nil);
    //    if (TestCaseCardIDsWithinGroupSuccess == self.test) {
    //        NSInteger count = [[noti.userInfo valueForKey:@"count"] integerValue];
    //        STAssertTrue(count > 0, nil);
    //    }
    self.running = NO;
}
- (void)actionFailed:(NSNotification *)noti {
    [self stopObservingAllNotifications];
    NSInteger code = [[noti.userInfo valueForKey:kInfoKeyErrorCode] integerValue];
    STFail([NSString stringWithFormat:@"code = %d",code]);
    self.running = NO;
}
- (void)waitUntilDone {
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    NSDate *limitDate = [NSDate distantFuture];
    while (self.running && [runLoop runMode:NSDefaultRunLoopMode
                                 beforeDate:limitDate]) {
        DLog(@"[II] waiting...", nil);
    }
    DLog(@"[II] DONE!", nil);
}
@end
