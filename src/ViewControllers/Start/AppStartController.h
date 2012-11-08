//
//  AppStartController.h
//  CardBook
//
//  Created by Sun Ming on 12-10-24.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AppStartData <NSObject>
@required
-(void)removeContext;
-(void)startSyncAllData;
@end
@protocol AppStartNetworkAgent <NSObject>
@required
- (void)login:(NSString *)user password:(NSString *)password;
- (void)createAccount:(NSDictionary *)accountDict;
- (void)resetPassword:(NSString *)user;
- (void)authenticateWithUser:(NSString *)user password:(NSString *)password;
@end
@protocol AppStartUserDefaults <NSObject>
@required
- (BOOL)isFirstLaunch;
- (BOOL)isAutoLogin;
- (BOOL)isLoggedIn;
- (void)setLoggedIn:(BOOL)value;
- (NSString *)currentUser;
- (NSString *)currentPassword;
- (NSNumber *)currentAuthorizationID;
- (void)saveLoginOrRegisterResult:(NSDictionary *)info;
@end

@interface AppStartController : UIViewController
@property (nonatomic, strong) id<AppStartNetworkAgent> agent;
@property (nonatomic, strong) id<AppStartData>         data;
@property (nonatomic, strong) id<AppStartUserDefaults> defaults;

#pragma mark - Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
@end





