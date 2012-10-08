//
//  KHHNetworkAPIAgentGroupTests.m
//  CardBook
//
//  Created by 孙铭 on 9/5/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPIAgentGroupTests.h"
#import "KHHNetworkAPIAgent+Group.h"
#import "KHHNetworkAPIAgent+Card.h"
#import "NSObject+Notification.h"

typedef enum {
    TestCaseGroupHasRequiredAttributes,
    TestCaseParametersFromGroup,
    TestCaseCreateGroupParameters,
    TestCaseCreateGroupSuccess,
    TestCaseCreateGroupFailure,
    TestCaseUpdateGroupParameters,
    TestCaseUpdateGroupSuccessNoChange,
    TestCaseUpdateGroupSuccessName,
    TestCaseUpdateGroupSuccessParent,
    TestCaseUpdateGroupSuccessNameAndParent,
    TestCaseUpdateGroupFailure,
    TestCaseDeleteGroupParameters,
    TestCaseDeleteGroupSuccess,
    TestCaseDeleteGroupFailure,
    TestCaseCardIDsWithinGroupParameters,
    TestCaseCardIDsWithinGroupSuccess,
    TestCaseCardIDsWithinGroupFailure,
    TestCaseMoveCardsParameters,
    TestCaseMoveCardsSuccess,
    TestCaseMoveCardsFailure,
} TestCaseType;

@interface KHHNetworkAPIAgentGroupTests ()
@property (nonatomic, assign) TestCaseType test;
@property (nonatomic, assign) BOOL running;
@property (nonatomic, strong) KHHNetworkAPIAgent *agent;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation KHHNetworkAPIAgentGroupTests
- (void)setUp
{
    [super setUp];
    self.agent = [[KHHNetworkAPIAgent alloc] init];
    [self.agent authenticateWithFakeID:@"19535276315" // 888888799826
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
- (void)testGroupHasRequiredAttributes {
    Group *group = [Group insertInManagedObjectContext:self.managedObjectContext];
    Group *parent = [Group insertInManagedObjectContext:self.managedObjectContext];
    group.idValue = 123;
    parent.idValue = 124;
    group.parent = parent;
    STAssertTrue(GroupHasRequiredAttributes(nil, KHHGroupAttributeNone), nil);
    STAssertTrue(GroupHasRequiredAttributes(group, KHHGroupAttributeNone), nil);
    STAssertTrue(GroupHasRequiredAttributes(group, KHHGroupAttributeID), nil);
    STAssertTrue(GroupHasRequiredAttributes(group, KHHGroupAttributeParentID), nil);
    
    STAssertFalse(GroupHasRequiredAttributes(nil, KHHGroupAttributeName), nil);
    STAssertFalse(GroupHasRequiredAttributes(group, KHHGroupAttributeName), nil);
    [self.managedObjectContext deleteObject:group];
    [self.managedObjectContext deleteObject:parent];
}
- (void)testParametersFromGroup {
    Group *group = [Group insertInManagedObjectContext:self.managedObjectContext];
    Group *parent = [Group insertInManagedObjectContext:self.managedObjectContext];
    group.idValue = 123;
    parent.idValue = 124;
    group.parent = parent;
    
    NSDictionary *dict;
    // group = nil
    dict = ParametersFromGroup(nil, KHHGroupAttributeAll);
    DLog(@"[II] dict = %@", dict);
    STAssertFalse(nil == dict, nil);
    STAssertTrue([dict count] == 0, nil);
    //
    dict = ParametersFromGroup(group, KHHGroupAttributeNone);
    DLog(@"[II] dict = %@", dict);
    STAssertFalse(nil == dict, nil);
    STAssertTrue([dict count] == 0, nil);
    //
    dict = ParametersFromGroup(group, KHHGroupAttributeAll);
    DLog(@"[II] dict = %@", dict);
    STAssertTrue([dict count] == 2, nil);
    //
    dict = ParametersFromGroup(group, KHHGroupAttributeID);
    DLog(@"[II] dict = %@", dict);
    STAssertTrue([dict count] == 1, nil);
    STAssertTrue([[dict valueForKey:@"group.id"] integerValue] == 123, nil);
    //
    dict = ParametersFromGroup(group, KHHGroupAttributeName);
    DLog(@"[II] dict = %@", dict);
    STAssertFalse(nil == dict, nil);
    STAssertTrue([dict count] == 0, nil);
    //
    dict = ParametersFromGroup(group, KHHGroupAttributeParentID);
    DLog(@"[II] dict = %@", dict);
    STAssertFalse(nil == dict, nil);
    STAssertTrue([[dict valueForKey:@"group.parentId"] integerValue] == 124, nil);
    
    [self.managedObjectContext deleteObject:group];
    [self.managedObjectContext deleteObject:parent];
}
#pragma mark - Create group
- (void)testCreateGroupParameters {
    Group *noname = [Group insertInManagedObjectContext:self.managedObjectContext];
    Group *namedButEmpty = [Group insertInManagedObjectContext:self.managedObjectContext];
    Group *named = [Group insertInManagedObjectContext:self.managedObjectContext];
    namedButEmpty.name = @"";
    named.name = @"孙悟空";
    
    DLog(@"[II] noname = %@", noname);
    DLog(@"[II] namedButEmpty = %@", namedButEmpty);
    DLog(@"[II] named = %@", named);
    
    STAssertFalse([self.agent createGroup:nil], nil);
    STAssertFalse([self.agent createGroup:noname], nil);
    STAssertFalse([self.agent createGroup:namedButEmpty], nil);
//    STAssertTrue([self.agent createGroup:named], nil);
    
    [self.managedObjectContext deleteObject:noname];
    [self.managedObjectContext deleteObject:namedButEmpty];
    [self.managedObjectContext deleteObject:named];
}
- (void)testCreateGroupSuccess {
    self.test = TestCaseCreateGroupSuccess;
    Group *group = [Group insertInManagedObjectContext:self.managedObjectContext];
    group.name = [NSString stringWithFormat:@"打手%@", [NSDate date]];
    DLog(@"[II] group = %@", group);
    [self observeNotificationName:KHHNetworkCreateGroupSucceeded
                            selector:@"actionSucceeded:"];
    [self observeNotificationName:KHHNetworkCreateGroupFailed
                            selector:@"actionFailed:"];
    [self.agent createGroup:group];
    [self.managedObjectContext deleteObject:group];
    [self waitUntilDone];
}
#pragma mark - Update group
- (void)testUpdateGroupParameters {
    Group *noID = [Group insertInManagedObjectContext:self.managedObjectContext];
//    Group *IDButWrong = [Group insertInManagedObjectContext:self.managedObjectContext];
    Group *ID = [Group insertInManagedObjectContext:self.managedObjectContext];
//    IDButWrong.idValue = 12121212;
    ID.idValue = 120;
    
    DLog(@"[II] noID = %@", noID);
//    DLog(@"[II] IDButWrong = %@", IDButWrong);
    DLog(@"[II] ID = %@", ID);
    
    STAssertFalse([self.agent updateGroup:nil newName:nil newParent:nil], nil);
    STAssertFalse([self.agent updateGroup:nil newName:nil newParent:ID], nil);
//    STAssertFalse([self.agent updateGroup:ID newName:nil newParent:nil], nil); // True
    STAssertFalse([self.agent updateGroup:noID newName:nil newParent:ID], nil);
    STAssertFalse([self.agent updateGroup:ID newName:nil newParent:noID], nil);
//    STAssertFalse([self.agent updateGroup:ID newName:nil newParent:ID], nil); // True
    
    [self.managedObjectContext deleteObject:noID];
//    [self.managedObjectContext deleteObject:IDButWrong];
    [self.managedObjectContext deleteObject:ID];
}
- (void)testUpdateGroupSuccessNoChange {
    self.test = TestCaseUpdateGroupSuccessNoChange;
    Group *group = [Group insertInManagedObjectContext:self.managedObjectContext];
    group.idValue = 120;
    DLog(@"[II] group = %@", group);
    [self observeNotificationName:KHHNetworkUpdateGroupSucceeded
                            selector:@"actionSucceeded:"];
    [self observeNotificationName:KHHNetworkUpdateGroupFailed
                            selector:@"actionFailed:"];
    [self.agent updateGroup:group
                    newName:nil
                  newParent:nil];
    [self.managedObjectContext deleteObject:group];
    [self waitUntilDone];
}
- (void)testUpdateGroupSuccessName {
    self.test = TestCaseUpdateGroupSuccessName;
    Group *group = [Group insertInManagedObjectContext:self.managedObjectContext];
    group.idValue = 121;
    group.name = @"呵呵";
    DLog(@"[II] group = %@", group);
    [self observeNotificationName:KHHNetworkUpdateGroupSucceeded
                            selector:@"actionSucceeded:"];
    [self observeNotificationName:KHHNetworkUpdateGroupFailed
                            selector:@"actionFailed:"];
    NSString *name = [NSString stringWithFormat:@"新组名%@", [NSDate date]];
    [self.agent updateGroup:group
                    newName:name
                  newParent:nil];
    [self.managedObjectContext deleteObject:group];
    [self waitUntilDone];
}
- (void)testUpdateGroupSuccessParent {
    self.test =TestCaseUpdateGroupSuccessParent;
    Group *group = [Group insertInManagedObjectContext:self.managedObjectContext];
    group.idValue = 120;
    Group *parent = [Group insertInManagedObjectContext:self.managedObjectContext];
    parent.idValue = 121;
    DLog(@"[II] group = %@, parent = %@", group, parent);
    [self observeNotificationName:KHHNetworkUpdateGroupSucceeded
                     selector:@"actionSucceeded:"];
    [self observeNotificationName:KHHNetworkUpdateGroupFailed
                     selector:@"actionFailed:"];
    [self.agent updateGroup:group
                    newName:nil
                  newParent:parent];
    [self.managedObjectContext deleteObject:group];
    [self waitUntilDone];
}
- (void)testUpdateGroupSuccessNameAndParent {
    self.test = TestCaseUpdateGroupSuccessNameAndParent;
    Group *group = [Group insertInManagedObjectContext:self.managedObjectContext];
    group.idValue = 120;
    Group *parent = [Group insertInManagedObjectContext:self.managedObjectContext];
    parent.idValue = 121;
    DLog(@"[II] group = %@, parent = %@", group, parent);
    [self observeNotificationName:KHHNetworkUpdateGroupSucceeded
                            selector:@"actionSucceeded:"];
    [self observeNotificationName:KHHNetworkUpdateGroupFailed
                            selector:@"actionFailed:"];
    NSString *name = [NSString stringWithFormat:@"新组名%@", [NSDate date]];
    [self.agent updateGroup:group
                    newName:name
                  newParent:parent];
    [self.managedObjectContext deleteObject:group];
    [self waitUntilDone];
}
#pragma mark - Delete group
- (void)testDeleteGroupSuccess {
    self.test = TestCaseDeleteGroupSuccess;
    Group *group = [Group insertInManagedObjectContext:self.managedObjectContext];
    group.idValue = 120;
    DLog(@"[II] group = %@", group);
    [self observeNotificationName:KHHNetworkDeleteGroupSucceeded
                     selector:@"actionSucceeded:"];
    [self observeNotificationName:KHHNetworkDeleteGroupFailed
                     selector:@"actionFailed:"];
    [self.agent deleteGroup:group];
    [self.managedObjectContext deleteObject:group];
    [self waitUntilDone];
}
#pragma mark - CardIDsWithinGroup
- (void)testCardIDsWithinGroupSuccess {
    self.test = TestCaseCardIDsWithinGroupSuccess;
    Group *group = [Group insertInManagedObjectContext:self.managedObjectContext];
    group.idValue = 1;
    DLog(@"[II] group = %@", group);
    [self observeNotificationName:KHHNetworkCardIDsWithinGroupSucceeded
                     selector:@"actionSucceeded:"];
    [self observeNotificationName:KHHNetworkCardIDsWithinGroupFailed
                     selector:@"actionFailed:"];
    [self.agent cardIDsWithinGroup:group];
    [self.managedObjectContext deleteObject:group];
    [self waitUntilDone];
}
#pragma mark - Move cards
- (void)testMoveCardsSuccess {
    MyCard *mCard = [MyCard insertInManagedObjectContext:self.managedObjectContext];
    mCard.idValue = 123456;
    PrivateCard *cCard = [PrivateCard insertInManagedObjectContext:self.managedObjectContext];
    cCard.idValue = 123456;
    ReceivedCard *rCard = [ReceivedCard insertInManagedObjectContext:self.managedObjectContext];
    rCard.idValue = 123456;
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:[Card entityName]];
    NSError *error;
    NSArray *cards = [self.managedObjectContext executeFetchRequest:fetch error:&error];
    DLog(@"[II] cards = %@, error = %@", cards, error);
    for (id card in cards) {
        DLog(@"[II] card class = %@, card isKindOfClass Card = %d", [card class], [card isKindOfClass:[Card class]]);
    }
    Group *fromGroup = [Group insertInManagedObjectContext:self.managedObjectContext];
    fromGroup.idValue = 159;
    Group *toGroup = [Group insertInManagedObjectContext:self.managedObjectContext];
    toGroup.idValue = 160;
    if ([self.agent moveCards:[NSArray arrayWithObjects:mCard, cCard, rCard, nil]
                    fromGroup:fromGroup
                      toGroup:toGroup]) {
        [self observeNotificationName:KHHNetworkMoveCardsSucceeded
                         selector:@"actionSucceeded:"];
        [self observeNotificationName:KHHNetworkMoveCardsFailed
                         selector:@"actionFailed:"];
        [self waitUntilDone];
    }
    [self.managedObjectContext deleteObject:mCard];
    [self.managedObjectContext deleteObject:cCard];
    [self.managedObjectContext deleteObject:rCard];
    [self.managedObjectContext deleteObject:fromGroup];
    [self.managedObjectContext deleteObject:toGroup];
}
#pragma mark - Utils
- (void)testZZ {
    DLog(@"[II] ZZ the last test", nil);
}
- (void)actionSucceeded:(NSNotification *)noti {
    [self stopObservingAllNotifications];
    NSInteger code = [[noti.userInfo valueForKey:kInfoKeyErrorCode] integerValue];
    STAssertEquals(code, KHHNetworkStatusCodeSucceeded, nil);
    if (TestCaseCardIDsWithinGroupSuccess == self.test) {
        NSInteger count = [[noti.userInfo valueForKey:@"count"] integerValue];
        STAssertTrue(count > 0, nil);
    }
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
