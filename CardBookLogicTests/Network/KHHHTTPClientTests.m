//
//  KHHHTTPClientTests.m
//  CardBook
//
//  Created by 孙铭 on 9/4/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHHTTPClientTests.h"

@interface KHHHTTPClientTests ()
@property (nonatomic, strong) KHHHTTPClient *testClient;
@end

@implementation KHHHTTPClientTests
- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    self.testClient = [KHHHTTPClient sharedClient];
}

- (void)tearDown
{
    // Tear-down code here.
    self.testClient = nil;
    [super tearDown];
}

- (void)testSharedClient
{
    KHHHTTPClient *newClient = [KHHHTTPClient sharedClient];
    STAssertEqualObjects(self.testClient, newClient, nil);
}
@end
