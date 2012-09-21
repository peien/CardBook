//
//  KHHNetworkAPIAgentCardTests.m
//  CardBook
//
//  Created by 孙铭 on 9/6/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPIAgentCardTests.h"
#import "KHHNetworkAPIAgent+Card.h"
#import "NSObject+Notification.h"

typedef enum {
    TestCaseLatestReceivedCard,
//    TestCaseGroupHasRequiredAttributes,
//    TestCaseParametersFromGroup,
//    TestCaseCreateGroupParameters,
//    TestCaseCreateGroupSuccess,
//    TestCaseCreateGroupFailure,
//    TestCaseUpdateGroupParameters,
//    TestCaseUpdateGroupSuccessNoChange,
//    TestCaseUpdateGroupSuccessName,
//    TestCaseUpdateGroupSuccessParent,
//    TestCaseUpdateGroupSuccessNameAndParent,
//    TestCaseUpdateGroupFailure,
//    TestCaseDeleteGroupParameters,
//    TestCaseDeleteGroupSuccess,
//    TestCaseDeleteGroupFailure,
//    TestCaseCardIDsWithinGroupParameters,
//    TestCaseCardIDsWithinGroupSuccess,
//    TestCaseCardIDsWithinGroupFailure,
//    TestCaseMoveCardsParameters,
//    TestCaseMoveCardsSuccess,
//    TestCaseMoveCardsFailure,
} TestCaseType;

@interface KHHNetworkAPIAgentCardTests ()
@property (nonatomic, assign) TestCaseType test;
@property (nonatomic, assign) BOOL running;
@property (nonatomic, strong) KHHNetworkAPIAgent *agent;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation KHHNetworkAPIAgentCardTests
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
- (void)testCardHasRequiredAttributes {
    Card *card = [Card insertInManagedObjectContext:self.managedObjectContext];
    card.idValue = 123;
    card.versionValue = 22;
    card.name = @"孙悟空";
    STAssertTrue(CardHasRequiredAttributes(nil, KHHCardAttributeNone), nil);
    STAssertTrue(CardHasRequiredAttributes(card, KHHCardAttributeNone), nil);
    STAssertTrue(CardHasRequiredAttributes(card, KHHCardAttributeID), nil);
    STAssertTrue(CardHasRequiredAttributes(card, KHHCardAttributeName), nil);
    STAssertTrue(CardHasRequiredAttributes(card, KHHCardAttributeVersion), nil);
    
    STAssertFalse(CardHasRequiredAttributes(nil, KHHCardAttributeName), nil);
    STAssertFalse(CardHasRequiredAttributes(card, KHHCardAttributeTemplateID), nil);
    [self.managedObjectContext deleteObject:card];
}
#pragma mark - deleteReceivedCards
- (void)testDeleteReceivedCards {
    ReceivedCard *rCard = [ReceivedCard insertInManagedObjectContext:self.managedObjectContext];
    rCard.idValue = 152053;
    rCard.versionValue = 10;
    rCard.userIDValue = 11136;
    [self observeNotification:KHHNotificationDeleteReceivedCardsSucceeded
                     selector:@"actionSucceeded:"];
    [self observeNotification:KHHNotificationDeleteReceivedCardsFailed
                     selector:@"actionFailed:"];
    [self.agent deleteReceivedCards:[NSArray arrayWithObject:rCard]];
    [self waitUntilDone];
}
#pragma mark - latestReceivedCard
- (void)testLatestReceivedCard {
    [self observeNotification:KHHNotificationLatestReceivedCardSucceeded
                     selector:@"actionSucceeded:"];
    [self observeNotification:KHHNotificationLatestReceivedCardFailed
                     selector:@"actionFailed:"];
    [self.agent latestReceivedCard];
    [self waitUntilDone];
}
#pragma mark - markReadReceivedCard
- (void)testMarkReadReceivedCard {
    ReceivedCard *rCard = [ReceivedCard insertInManagedObjectContext:self.managedObjectContext];
    rCard.idValue = 152053;
    rCard.versionValue = 10;
    rCard.userIDValue = 11136;
    [self observeNotification:KHHNotificationMarkReadReceivedCardSucceeded
                     selector:@"actionSucceeded:"];
    [self observeNotification:KHHNotificationMarkReadReceivedCardFailed
                     selector:@"actionFailed:"];
    [self.agent markReadReceivedCard:rCard];
    [self waitUntilDone];
}
#pragma mark - receivedCardsAfterDateLastCardExpectedCount
- (void)testReceivedCardsAfterDateLastCardExpectedCount {
    ReceivedCard *rCard = [ReceivedCard insertInManagedObjectContext:self.managedObjectContext];
    rCard.idValue = 152053;
    rCard.versionValue = 10;
    rCard.userIDValue = 11136;
    [self observeNotification:KHHNotificationReceivedCardsAfterDateLastCardExpectedCountSucceeded
                     selector:@"actionSucceeded:"];
    [self observeNotification:KHHNotificationReceivedCardsAfterDateLastCardExpectedCountFailed
                     selector:@"actionFailed:"];
    [self.agent receivedCardsAfterDate:nil lastCard:rCard expectedCount:nil extra:nil];
    [self waitUntilDone];
}
#pragma mark - receivedCardCountAfterDateLastCard
- (void)testReceivedCardCountAfterDateLastCard {
    ReceivedCard *rCard = [ReceivedCard insertInManagedObjectContext:self.managedObjectContext];
    rCard.idValue = 152053;
    rCard.versionValue = 10;
    rCard.userIDValue = 11136;
    [self observeNotification:KHHNotificationReceivedCardCountAfterDateLastCardSucceeded
                     selector:@"actionSucceeded:"];
    [self observeNotification:KHHNotificationReceivedCardCountAfterDateLastCardFailed
                     selector:@"actionFailed:"];
    [self.agent receivedCardCountAfterDate:nil lastCard:nil extra:nil];
    [self waitUntilDone];
}

//#pragma mark - createPrivateCard
//- (void)createPrivateCard
//#pragma mark - updatePrivateCard
//- (void)updatePrivateCard
#pragma mark - deletePrivateCard
//- (void)testDeletePrivateCard {
//    [self observeNotification:KHHNotificationDeletePrivateCardSucceeded
//                     selector:@"actionSucceeded:"];
//    [self observeNotification:KHHNotificationDeletePrivateCardFailed
//                     selector:@"actionFailed:"];
//    [self.agent deletePrivateCard:nil];
//    [self waitUntilDone];
//}
#pragma mark - privateCardsAfterDate
- (void)testPrivateCardsAfterDate {
    [self observeNotification:KHHNotificationPrivateCardsAfterDateSucceeded
                     selector:@"actionSucceeded:"];
    [self observeNotification:KHHNotificationPrivateCardsAfterDateFailed
                     selector:@"actionFailed:"];
    [self.agent privateCardsAfterDate:nil];
    [self waitUntilDone];
}
#pragma mark - Utils
- (void)testZZ {
    DLog(@"[II] ZZ the last test", nil);
}
- (void)actionSucceeded:(NSNotification *)noti {
    [self stopObservingAllNotifications];
    NSInteger code = [[noti.userInfo valueForKey:kInfoKeyErrorCode] integerValue];
    STAssertEquals(code, KHHNetworkStatusCodeSucceeded, nil);
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

