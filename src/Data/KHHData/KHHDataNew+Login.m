//
//  KHHData+Login.m
//  CardBook
//
//  Created by CJK on 13-1-14.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew+Login.h"
#import "KHHNetClinetAPIAgent+Login.h"

@implementation KHHDataNew (Login)

- (void)doLogin:(NSString *)username password:(NSString *)password delegate:(id<KHHDataLoginDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent login:username password:password delegate:self];
}

#pragma mark - delegate

- (void)loginSuccess:(NSDictionary *)dict
{
    
    [(id<KHHDataLoginDelegate>)self.delegate loginForUISuccess:dict];
}

- (void)loginFailed:(NSDictionary *)dict
{
    [(id<KHHDataLoginDelegate>)self.delegate loginForUIFailed:dict];
}
@end
