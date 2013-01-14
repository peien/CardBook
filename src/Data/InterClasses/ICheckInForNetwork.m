//
//  ICheckInForNetWork.m
//  CardBook
//
//  Created by 王定方 on 13-1-13.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "ICheckInForNetwork.h"
#import "NSNumber+SM.h"
#import "NSString+SM.h"

@implementation ICheckInForNetwork

@end

@implementation ICheckInForNetwork (KHHTransformation)
//从json解析成ICheckInForNetWork 对象
- (id)updateWithJSON:(NSDictionary *)json
{
    if (!json) {
        return self;
    }
    
    self.userID = [NSNumber numberFromObject:[json valueForKey:JSONDataKeyUID] zeroIfUnresolvable:NO];
    self.cardID = [NSNumber numberFromObject:[json valueForKey:JSONDataKeyCID] zeroIfUnresolvable:NO];
    self.version = [NSString stringFromObject:[json valueForKey:JSONDataKeyVersion]];
    self.deviceToken = [NSString stringFromObject:[json valueForKey:JSONDataKeyDeviceToken]];
    self.latitude = [NSNumber numberFromObject:[json valueForKey:[json valueForKey:JSONDataKeyLatitude]] zeroIfUnresolvable:NO];
    self.longitude =[NSNumber numberFromObject:[json valueForKey:[json valueForKey:JSONDataKeyLongitude]] zeroIfUnresolvable:NO];
    self.memo = [NSString stringFromObject:[json valueForKey:JSONDataKeyCol1]];
    self.leaveTime = [NSString stringFromObject:[json valueForKey:JSONDataKeyLeaveTime]];
    self.country = [NSString stringFromObject:[json valueForKey:JSONDataKeyCountry]];
    self.province = [NSString stringFromObject:[json valueForKey:JSONDataKeyProvince]];
    self.city = [NSString stringFromObject:[json valueForKey:JSONDataKeyCity]];
    self.address = [NSString stringFromObject:[json valueForKey:JSONDataKeyAddress]];
    self.userName = [NSString stringFromObject:[json valueForKey:JSONDataKeyUserName]];
    //图片url
    NSString *imageUrls = [NSString stringFromObject:[json valueForKey:JSONDataKeyCol2]];
    if (imageUrls.length > 0) {
        self.imageUrls = [imageUrls componentsSeparatedByString:KHH_SEPARATOR];
    }
    return self;
}
@end