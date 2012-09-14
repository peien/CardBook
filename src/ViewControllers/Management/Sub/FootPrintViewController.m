//
//  FootPrintViewController.m
//  CardBook
//
//  Created by 王国辉 on 12-8-9.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "FootPrintViewController.h"
#import "FootPrintViewCell.h"
@interface FootPrintViewController ()

@end

@implementation FootPrintViewController
@synthesize theTable = _theTable;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"足迹";
        [self.rightBtn setTitle:@"删除" forState:UIControlStateNormal];

    }
    return self;
}

- (void)rightBarButtonClick:(id)sender
{


}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"";
    FootPrintViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FootPrintViewCell" owner:self options:nil];
        cell = (FootPrintViewCell *)[nib objectAtIndex:0];
    }
    return cell;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
