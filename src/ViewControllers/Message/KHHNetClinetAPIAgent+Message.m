//
//  KHHNetClinetAPIAgent+Message.m
//  CardBook
//
//  Created by CJK on 12-12-27.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent+Message.h"
#import "InMessage.h"
#import "KHHMessage.h"
//#import "KHHData.h"
#import "KHHNetworkAPIAgent.h"


@implementation KHHNetClinetAPIAgent (Message)

- (void)doDeleteInEdit:(id<delegateMsgForRead>)delegate messages:(NSArray *)messages
{  
    NSMutableArray *arrPro = [[NSMutableArray alloc]init];
    NSMutableArray *arrPro2 = [[NSMutableArray alloc]init];
    for (KHHMessage * msg in messages) {
        if (!msg.isReadValue) {
            [arrPro addObject:msg];
        }else{
            [arrPro2 addObject:msg];
        }
    }
    if ([arrPro2 count]>0) {
        for (KHHMessage *msg in messages) {
            [[[KHHDataNew sharedData] context] deleteObject:msg];
        }
        [[KHHDataNew sharedData] saveContext];
        
    }
    if ([arrPro count]>0) {
        [self doDelete:delegate messages:arrPro];
    }else{
        [delegate deleDone];
    }
}

- (void)doDelete:(id<delegateMsgForRead>) delegate messages:(NSArray *)messages
{
    if (![self networkStateIsValid]) {
        [self setYES:messages];
        [delegate deleFail];
        return;
    }
    
    NSDictionary *queryDict = @{ @"method" : @"customFsendService.delete" };
    //把函数从Netclient中分离，新方法中的url固定参数变化，及签名，故先用老的
    KHHNetworkAPIAgent *agent = [[KHHNetworkAPIAgent alloc] init];
    NSString *path = [NSString stringWithFormat:@"rest?%@",
                      [agent queryStringWithDictionary:queryDict]];
    
    NSMutableArray *messageIDs = [NSMutableArray arrayWithCapacity:[messages count]];
    for (id message in messages) {
        [messageIDs addObject:[[message valueForKey:kAttributeKeyID]
                               stringValue]];
    }
    
    NSDictionary *parameters = @{
    @"ids" : [messageIDs componentsJoinedByString:KHH_COMMA]
    };
    
    NSURLRequest *request = [[NetClient sharedClient]
                             multipartFormRequestWithMethod:@"POST"
                             path:path
                             parameters:parameters
                             constructingBodyWithBlock:nil];
    AFHTTPRequestOperation *reqOperation = [[NetClient sharedClient]
                                            HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
                                            {
                                                NSDictionary *responseDict = [agent JSONDictionaryWithResponse:responseObject];
                                                DLog(@"[II] responseDict = %@", responseDict);
                                                KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
                                                if (code == 0) {
                                                    [delegate deleDone];
                                                    
                                                }else{
                                                    [self setYES:messages];
                                                    [delegate deleFail];
                                                    
                                                }
                                                
                                                
                                            }
                                            failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                            {
                                                [self setYES:messages];
                                                [delegate deleFail];                                                
                                            }];
    
    // 实际发送请求
   
    [[NetClient sharedClient] enqueueHTTPRequestOperation:reqOperation];
    
}

- (void)doReseaveMessage:(id<delegateMsgForMain>) delegate

{
    
    NSDictionary *queryDict = @{ @"method" : @"customFsendService.list" };
    //把函数从Netclient中分离，新方法中的url固定参数变化，及签名，故先用老的
    KHHNetworkAPIAgent *agent = [[KHHNetworkAPIAgent alloc] init];
    NSString *path = [NSString stringWithFormat:@"rest?%@",
                      [agent queryStringWithDictionary:queryDict]];
    DLog(@"path%@",path);
    
    NSURLRequest *request = [[NetClient sharedClient]
                             multipartFormRequestWithMethod:@"POST"
                             path:path
                             parameters:nil
                             constructingBodyWithBlock:nil];
    AFHTTPRequestOperation *reqOperation = [[NetClient sharedClient]
                                            HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
                                            {
                                                
                                                NSDictionary *responseDict = [agent JSONDictionaryWithResponse:responseObject];
                                                if ([responseDict objectForKey:@"errorCode"]!=0) {
                                                    [delegate reseaveFail];

                                                }
                                                NSArray *fsendList = responseDict[@"fsendList"];
                                                NSMutableArray *messageList = [NSMutableArray arrayWithCapacity:fsendList.count];
                                                for (id obj in fsendList) {
                                                    InMessage *im = [[[InMessage alloc] init] updateWithJSON:obj];
                                                    [messageList addObject:im];
                                                    [KHHMessage processIObject:im];
                                                }
                                                [[KHHDataNew sharedData] saveContext];
                                                if (messageList && messageList.count > 0) {
                                                    [delegate reseaveDone:YES];
                                                }else{
                                                    [delegate reseaveDone:NO];
                                                }
                                                
                                                
                                            }
                                            failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                            {
                                                [delegate reseaveFail];
                                            }];
    
    // 实际发送请求
    [[NetClient sharedClient] enqueueHTTPRequestOperation:reqOperation];
}


- (void)setYES:(NSArray *)messages
{
    for (KHHMessage *msg in messages) {
        msg.isReadValue = NO;
    }
}
@end
