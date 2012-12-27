//
//  User.m
//  CardBook
//
//  Created by CJK on 12-12-27.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "User.h"


@implementation User

@synthesize phone = _phone;
@synthesize password = _password;

+ (User *)sharedInstance
{
    static User *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[User alloc]init];
        
    });
    
    return _sharedInstance;
}


- (void)setPhone:(NSString *)phone
{
    if (!_phone || [_phone isEqualToString:phone]) {
        
        [[NSUserDefaults standardUserDefaults] setValue:phone forKey:@"kPhone"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _phone = _phone;
    }
}

- (void)setPassword:(NSString *)password
{
    if (!_password || [_password isEqualToString:password]) {
        NSString *enc =[[NetClient sharedClient].netFromPlist.dic valueForKeyPath:@"security.secKeyEncry"];        
        NSString *encPass = [Encryptor encryptBase64String:password
                                                 keyString:enc];
        [[NSUserDefaults standardUserDefaults] setValue:encPass forKey:@"kPassword"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _password = password;        
    }
}



- (NSString *)phone
{
    if (!_phone) {
        _phone = [[NSUserDefaults standardUserDefaults] valueForKey:@"kPhone"];
    }
    return _phone;
}

- (NSString *)password
{
    if (!_password) {
        _password = [[NSUserDefaults standardUserDefaults] valueForKey:@"kPassword"];
    }
    return _password;
}

@end
