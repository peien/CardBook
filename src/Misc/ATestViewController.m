//
//  ATestViewController.m
//  CardBook
//
//  Created by Sun Ming on 12-9-24.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "ATestViewController.h"
#import "KHHData.h"

@interface ATestViewController ()

@end

@implementation ATestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor blackColor];
    self.data = [KHHData sharedData];
    self.card = [[self.data allMyCards] objectAtIndex:0];
    if (self.card) {
        self.visualCard = [[KHHVisualCardViewController alloc] initWithNibName:nil bundle:nil];
        [self.view addSubview:self.visualCard.view];
        CGRect newFrame = CGRectMake(10, 100, self.visualCard.view.frame.size.width, self.visualCard.view.frame.size.height);
        self.visualCard.view.frame = newFrame;
        self.visualCard.card = self.card;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
