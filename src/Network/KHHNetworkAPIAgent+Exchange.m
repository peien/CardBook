//
//  KHHNetworkAPIAgent+Exchange.m
//  CardBook
//
//  Created by 孙铭 on 8/29/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPIAgent+Exchange.h"
#import "KHHNetworkAPIAgent+Card.h"
#import "Card.h"

@implementation KHHNetworkAPIAgent (Exchange)
/**
 摇手机交换名片 shakeExchangeCardService.shakeExchangeCardNew
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=171
 */
- (void)exchangeCard:(Card *)card
      withCoordinate:(CLLocationCoordinate2D)coordinate {
    ALog(@"[II] 用于交换的名片 id = %@, version = %@", card.id, card.version);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:6];
    [parameters setObject:[[card valueForKey:kAttributeKeyID] stringValue]
                   forKey:@"shakeInfo.card.cardId"];
    [parameters setObject:[[card valueForKey:kAttributeKeyVersion] stringValue]
                   forKey:@"shakeInfo.card.version"];
    [parameters setObject:[NSString stringWithFormat:@"%f", coordinate.longitude]
                   forKey:@"shakeInfo.longitude"];
    [parameters setObject:[NSString stringWithFormat:@"%f", coordinate.latitude]
                   forKey:@"shakeInfo.latitude"];
    [parameters setObject:@(15*1000).stringValue
                   forKey:@"shakeInfo.invalidTime"];
    [parameters setObject:@"true"
                   forKey:@"shakeInfo.hasGps"];
    
    [self postAction:@"exchangeCard"
               query:@"shakeExchangeCardService.shakeExchangeCardNew"
          parameters:parameters
             success:nil];
}
/**
 发送名片到手机 sendCardService.sendCard
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=177
 */
- (void)sendCard:(Card *)card
        toPhones:(NSArray *)numbers {
    NSString *action = kActionNetworkSendCardToPhone;
    ALog(@"[II] 发送名片 id = %@, version = %@", card.id, card.version);
    ALog(@"[II] 发送到手机号 phone numbers = %@", numbers);

    NSString *ID = [[card valueForKey:kAttributeKeyID] stringValue];
    NSString *version = [[card valueForKey:kAttributeKeyVersion] stringValue];
    NSString *numberstr = [numbers componentsJoinedByString:@";"];
    NSDictionary *parameters = @{
            @"mobiles" : (numberstr? numberstr: @""),
            @"cardId" : (ID? ID: @""),
            @"version" : (version? version: @"")
    };
    
    [self postAction:action
               query:@"sendCardService.sendCard"
          parameters:parameters
             success:nil];
}
/**
 回赠名片 sendCardService.sendCardByReceiverId
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=191
 */
- (void)sendCard:(Card *)card
          toUser:(NSString *)userID {
    ALog(@"[II] 回赠名片 id = %@, version = %@", card.id, card.version);
    ALog(@"[II] 回赠给 userID = %@", userID);
    
    NSString *ID = card.id.stringValue;
    NSString *version = card.version.stringValue;
    NSDictionary *parameters = @{
            @"receiverId" : (userID? userID: @""),
            @"cardId" : (ID? ID: @""),
            @"version" : (version? version: @"")
    };
    [self postAction:@"sendCardToUser"
               query:@"sendCardService.sendCardByReceiverId"
          parameters:parameters
             success:nil];
}

@end
