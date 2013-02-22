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

- (void)doDeleteInEdit:(id<KHHNetAgentMessageDelegate>)delegate messages:(NSArray *)messages
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
       // [delegate deleDone];
    }
}

- (void)doDelete:(id<KHHNetAgentMessageDelegate>) delegate messages:(NSArray *)messages
{
    if (![self networkStateIsValid]) {
        [self setYES:messages];
       // [delegate deleFail];
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
                                                 //   [delegate deleDone];
                                                    
                                                }else{
                                                    [self setYES:messages];
                                                  //  [delegate deleFail];
                                                    
                                                }
                                                
                                                
                                            }
                                            failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                            {
                                                [self setYES:messages];
                                              //  [delegate deleFail];
                                            }];
    
    // 实际发送请求
   
    [[NetClient sharedClient] enqueueHTTPRequestOperation:reqOperation];
    
}

- (void)reseaveMessage:(id<KHHNetAgentMessageDelegate>) delegate

{
    
    if (![self networkStateIsValid]) {
        if ([delegate respondsToSelector:@selector(reseaveMsgFailed:)]) {
            NSDictionary *dict = [self networkUnableFailedResponseDictionary];
            [delegate reseaveMsgFailed:dict];
        }
        return;
        
    } 
   
    NSString *path = @"message/msgsIos";
    // 处理返回数据的block
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *op, id response) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:response];
        if ([[responseDict objectForKey:@"errorCode"]intValue]!=0) {
            [delegate reseaveMsgFailed:responseDict];            
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
            [delegate reseaveMsgSuccess:YES];
        }else{
            [delegate reseaveMsgSuccess:NO];
        }
    };
    
    //其它操作失败block
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"reseaveMsgFailed:"];
    
    [self getPath:path parameters:nil success:success failure:failed];
    
    
}


- (void)setYES:(NSArray *)messages
{
    for (KHHMessage *msg in messages) {
        msg.isReadValue = NO;
    }
}

@end
