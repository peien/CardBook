//
//  KHHDelVisitCalendarVC.m
//  CardBook
//
//  Created by 王国辉 on 12-8-23.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "KHHDelVisitCalendarVC.h"
#import "KHHDelVisitCalendarCell.h"
#import "SMCheckbox.h"

@interface KHHDelVisitCalendarVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation KHHDelVisitCalendarVC
@synthesize theTable = _theTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"拜访日历", nil);
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
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
    _theTable = nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 11;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    KHHDelVisitCalendarCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"KHHDelVisitCalendarCell" owner:self options:nil] objectAtIndex:0];
        //SMCheckbox *checkbox = [[SMCheckbox alloc] initWithFrame:CGRectMake(10, cell.frame.size.height/2, 45, 45)];
        SMCheckbox *checkbox = [[[NSBundle mainBundle] loadNibNamed:@"SMCheckbox" owner:self options:nil] objectAtIndex:0];
        checkbox.frame = CGRectMake(0, 35, 45, 45);
        [cell addSubview:checkbox];
    }
    return cell;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
