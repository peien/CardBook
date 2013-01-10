//
//  NetClient+Message.m
//  CardBook
//
//  Created by CJK on 12-12-27.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "NetClient+Message.h"
#import "InMessage.h"
#import "KHHMessage.h"
#import "KHHData.h"


@implementation NetClient (Message)

@dynamic inMsgView;

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
            [[[KHHData sharedData] context] deleteObject:msg];
        }
        [[KHHData sharedData] saveContext];
        
    }
    if ([arrPro count]>0) {
        [self doDelete:delegate messages:arrPro];
    }else{
        [delegate deleDone];
    }
}

- (void)doDelete:(id<delegateMsgForRead>) delegate messages:(NSArray *)messages
{
    if ([self.r currentReachabilityStatus] == NotReachable) {
        [self setYES:messages];
        [delegate deleFail];
        return;
    }
    
    NSDictionary *queryDict = @{ @"method" : @"customFsendService.delete" };
    NSString *path = [NSString stringWithFormat:@"rest?%@",
                      [self queryStringWithDictionary:queryDict]];
    
    NSMutableArray *messageIDs = [NSMutableArray arrayWithCapacity:[messages count]];
    for (id message in messages) {
        [messageIDs addObject:[[message valueForKey:kAttributeKeyID]
                               stringValue]];
    }
    
    NSDictionary *parameters = @{
    @"ids" : [messageIDs componentsJoinedByString:KHH_COMMA]
    };
    
    NSURLRequest *request = [self
                             multipartFormRequestWithMethod:@"POST"
                             path:path
                             parameters:parameters
                             constructingBodyWithBlock:nil];
    AFHTTPRequestOperation *reqOperation = [self
                                            HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
                                            {
                                                NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
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
   
    [self enqueueHTTPRequestOperation:reqOperation];
    
}

- (void)doReseaveMessage:(id<delegateMsgForMain>) delegate

{
    
    NSDictionary *queryDict = @{ @"method" : @"customFsendService.list" };
    NSString *path = [NSString stringWithFormat:@"rest?%@",
                      [self queryStringWithDictionary:queryDict]];
    DLog(@"path%@",path);
    
    NSURLRequest *request = [self
                             multipartFormRequestWithMethod:@"POST"
                             path:path
                             parameters:nil
                             constructingBodyWithBlock:nil];
    AFHTTPRequestOperation *reqOperation = [self
                                            HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
                                            {
                                                NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
                                                NSArray *fsendList = responseDict[@"fsendList"];
                                                NSMutableArray *messageList = [NSMutableArray arrayWithCapacity:fsendList.count];
                                                for (id obj in fsendList) {
                                                    InMessage *im = [[[InMessage alloc] init] updateWithJSON:obj];
                                                    [messageList addObject:im];
                                                    [KHHMessage processIObject:im];
                                                }
                                                [[KHHData sharedData] saveContext];
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
    [self enqueueHTTPRequestOperation:reqOperation];
}


- (void)setYES:(NSArray *)messages
{
    for (KHHMessage *msg in messages) {
        msg.isReadValue = NO;
    }
}
@end
