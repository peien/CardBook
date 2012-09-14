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
- (BOOL)exchangeCard:(Card *)card
      withCoordinate:(CLLocationCoordinate2D)coordinate {
    if (!CardHasRequiredAttributes(card, KHHCardAttributeID|KHHCardAttributeVersion)) {
        return NO;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:6];
    [parameters setObject:[[card valueForKey:kAttributeKeyID] stringValue]
                   forKey:@"shakeInfo.card.cardId"];
    [parameters setObject:[[card valueForKey:kAttributeKeyVersion] stringValue]
                   forKey:@"shakeInfo.card.version"];
    [parameters setObject:[NSString stringWithFormat:@"%f", coordinate.longitude]
                   forKey:@"shakeInfo.longitude"];
    [parameters setObject:[NSString stringWithFormat:@"%f", coordinate.latitude]
                   forKey:@"shakeInfo.latitude"];
    [parameters setObject:[NSString stringWithFormat:@"%f", KHHTimeOutIntervalExchange]
                   forKey:@"shakeInfo.invalidTime"];
    [parameters setObject:@"yes"
                   forKey:@"shakeInfo.hasGps"];
    [self postAction:@"exchangeCard"
               query:@"shakeExchangeCardService.shakeExchangeCardNew"
          parameters:parameters];
    return YES;
}
/**
 发送名片到手机 sendCardService.sendCard
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=177
 */
- (BOOL)sendCard:(Card *)card
        toPhones:(NSArray *)numbers {
    if (!CardHasRequiredAttributes(card, KHHCardAttributeID
                                   | KHHCardAttributeVersion)) {
        return NO;
    }
    if (0 == numbers.count) {
        return NO;
    }
    for (id num in numbers) {
        if (![num isKindOfClass:[NSString class]] || [num length] == 0) {
            return NO;
        }
    }
    NSString *ID = [[card valueForKey:kAttributeKeyID] stringValue];
    NSString *version = [[card valueForKey:kAttributeKeyVersion] stringValue];
    NSString *numberstr = [numbers componentsJoinedByString:@";"];
    NSDictionary *parameters = @{
            @"mobiles" : (numberstr? numberstr: @""),
            @"cardId" : (ID? ID: @""),
            @"version" : (version? version: @"")
    };
    [self postAction:@"sendCardToPhones"
               query:@"sendCardService.sendCard"
          parameters:parameters];
    return YES;
}
/**
 回赠名片 sendCardService.sendCardByReceiverId
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=191
 */
- (BOOL)sendCard:(Card *)card
          toUser:(NSString *)userID {
    if (!CardHasRequiredAttributes(card, KHHCardAttributeID|KHHCardAttributeVersion)) {
        return NO;
    }
    if (0 == userID.length) {
        return NO;
    }
    NSString *ID = [[card valueForKey:kAttributeKeyID] stringValue];
    NSString *version = [[card valueForKey:kAttributeKeyVersion] stringValue];
    NSDictionary *parameters = @{
            @"receiverId" : (userID? userID: @""),
            @"cardId" : (ID? ID: @""),
            @"version" : (version? version: @"")
    };
    [self postAction:@"sendCardToUser"
               query:@"sendCardService.sendCardByReceiverId"
          parameters:parameters];
    return YES;
}

@end
