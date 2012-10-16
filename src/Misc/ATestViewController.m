//
//  ATestViewController.m
//  CardBook
//
//  Created by Sun Ming on 12-9-24.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "ATestViewController.h"
#import "KHHClasses.h"
#import "KHHDataAPI.h"
#import "KHHLocationController.h"

@interface ATestViewController (Utils)
- (void)showLabelWithText:(NSString *)text;
@end

@implementation ATestViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil];
    if (self) {
        self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
        self.view.backgroundColor = [UIColor whiteColor];
        _agent = [[KHHNetworkAPIAgent alloc] init];
        _data = [KHHData sharedData];
        _card = [[self.data allMyCards] objectAtIndex:0];
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(110, 200, 100, 44);
    [self.view addSubview:button];
    
    [button setTitle:@"Action!" forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(testGroups) // TEST
     forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 试验Groups
- (void)testGroups {
    [self showLabelWithText:@"试验Groups"];
//    [self.agent childGroupsOfGroupID:nil
//                          withCardID:nil
//                               extra:nil];
    [self.agent cardIDsInAllGroupWithExtra:nil];
}

#pragma mark - 试验模板显示
- (void)testVisualCardViewController {
    self.view.backgroundColor = [UIColor blackColor];
    self.card = [[self.data allMyCards] objectAtIndex:0];
    if (self.card) {
        self.visualCard = [[KHHVisualCardViewController alloc] initWithNibName:nil bundle:nil];
        [self.view addSubview:self.visualCard.view];
        CGRect newFrame = CGRectMake(10, 100, self.visualCard.view.frame.size.width, self.visualCard.view.frame.size.height);
        self.visualCard.view.frame = newFrame;
        self.visualCard.card = self.card;
    }
}
#pragma mark - 试验取最后一张ReceivedCard
- (void)testPullLatestReceivedCard {
    [self.data pullLatestReceivedCard];
}
#pragma mark - 试验CheckIn
- (void)testCheckIn {
    [self showLabelWithText:@"试验CheckIn"];
    ICheckIn *iCheckIn = [[ICheckIn alloc] initWithCard:self.card];
    if (self.placemark) {
        iCheckIn.placemark = self.placemark;
        iCheckIn.latitude = [NSNumber numberWithDouble:self.location.coordinate.latitude];
        iCheckIn.longitude = [NSNumber numberWithDouble:self.location.coordinate.longitude];
    }
    iCheckIn.memo = @"HELLO你好";
    iCheckIn.imageArray = @[
    [UIImage imageWithContentsOfFile:@"/Users/msun/Sceenshot/1.png"],
    [UIImage imageWithContentsOfFile:@"/Users/msun/Sceenshot/2.png"],
    [UIImage imageWithContentsOfFile:@"/Users/msun/Sceenshot/3.png"],
    ];
    [self.agent checkIn:iCheckIn];
}
#pragma mark - 试验LocationController
- (void)testLocationController {
    [self showLabelWithText:@"试验LocationController"];
    [self observeNotificationName:KHHLocationUpdateSucceeded
                         selector:@"handleLocationUpdateSucceeded:"];
    [[KHHLocationController sharedController] updateLocation];
}
- (void)handleLocationUpdateSucceeded:(NSNotification *)noti {
    static int num = 0;
    num = num + 1;
    ALog(@"[II] 第 %d 次！", num);
    CLPlacemark *placemark = noti.userInfo[kInfoKeyPlacemark];
    if (placemark) {
        self.location = placemark.location;
        self.placemark = placemark;
    }
    [self testCheckIn];
}
@end
@implementation ATestViewController (Utils)
- (void)showLabelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, 320, 21)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    [self.view addSubview:label];
}
@end
