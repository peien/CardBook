//
//  ATestViewController.m
//  CardBook
//
//  Created by Sun Ming on 12-9-24.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "ATestViewController.h"
#import "ICheckIn.h"

@interface ATestViewController (Utils)
- (void)showLabelWithText:(NSString *)text;
@end

@implementation ATestViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil];
    if (self) {
        self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
        _agent = [[KHHNetworkAPIAgent alloc] init];
        _data = [KHHData sharedData];
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // LET'S TEST
    [self testCheckIn];
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
    self.card = [[self.data allMyCards] objectAtIndex:0];
    ICheckIn *iCheckIn = [[ICheckIn alloc] initWithCard:self.card];
    [self.agent checkIn:iCheckIn];
}
@end
@implementation ATestViewController (Utils)
- (void)showLabelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 220, 320, 21)];
    label.text = text;
    DLog(@"[II] label = %@", label);
    [self.view addSubview:label];
}
@end
