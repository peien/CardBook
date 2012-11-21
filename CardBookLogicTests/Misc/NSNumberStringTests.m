//
//  NSNumberStringTests.m
//  CardBook
//
//  Created by 孙铭 on 12-9-18.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "NSNumberStringTests.h"
#import "NSNumber+SM.h"

@implementation NSNumberStringTests
- (void)setUp
{
    [super setUp];
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}

- (void)testNumberFromString
{
    NSString *strEmpty = @"";
    NSString *strNil = nil;
    NSString *strNull = [NSNull null];
    NSString *strOther = @"x111";
    NSString *strInt = @"1234";
    NSString *strFloat = @"135.978";

    DLog(@"[II] nil = %@", nil);
    
    DLog(@"[II] NSNumber from empty string = %@", [NSNumber numberFromString:strEmpty]);
    STAssertEquals(0, [[NSNumber numberFromString:strEmpty] integerValue], nil);
    
    DLog(@"[II] NSNumber from nil string = %@", [NSNumber numberFromString:strNil]);
    STAssertEquals(0, [[NSNumber numberFromString:strNil] integerValue], nil);
    
    DLog(@"[II] NSNumber from null string = %@", [NSNumber numberFromString:strNull]);
    STAssertEquals(0, [[NSNumber numberFromString:strNull] integerValue], nil);
    
    DLog(@"[II] NSNumber from Other string = %@", [NSNumber numberFromString:strOther]);
    STAssertEquals(0, [[NSNumber numberFromString:strOther] integerValue], nil);
    
    DLog(@"[II] NSNumber from integer string = %@", [NSNumber numberFromString:strInt]);
    STAssertEquals(1234, [[NSNumber numberFromString:strInt] integerValue], nil);
    
    DLog(@"[II] NSNumber from float string = %@", [NSNumber numberFromString:strFloat]);
    STAssertTrue([[NSNumber numberFromString:strFloat] isEqualToNumber:[NSNumber numberWithDouble:135.978]], nil);
}
@end
