//
//  KHHDataNew+Register.m
//  CardBook
//
//  Created by CJK on 13-1-15.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew+Register.h"

@implementation KHHDataNew (Register)

- (void)doRegister:(NSString *)username password:(NSString *)password delegate:(id<KHHDataLoginDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent :username password:password delegate:self];
}

#pragma mark - delegate

- (void)registerSuccess:(NSDictionary *)dict
{
    
    [(id<KHHDataRegisterDelegate>)self.delegate registerForUISuccess:dict];
}

- (void)registerFailed:(NSDictionary *)dict
{
    [(id<KHHDataRegisterDelegate>)self.delegate registerForUIFailed:dict];
}

@end
