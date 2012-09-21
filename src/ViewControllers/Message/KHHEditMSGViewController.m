//
//  KHHEditMSGViewController.m
//  CardBook
//
//  Created by 王国辉 on 12-9-14.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "KHHEditMSGViewController.h"
#import "KHHNetworkAPIAgent+Message.h"

@interface KHHEditMSGViewController ()
@property (assign, nonatomic) bool edit;
@property (strong, nonatomic) NSMutableArray *selectItemArray;
@property (strong, nonatomic) NSMutableArray *delMessageArr;
@end

@implementation KHHEditMSGViewController
@synthesize edit = _edit;
@synthesize theTable = _theTable;
@synthesize selectItemArray = _selectItemArray;
@synthesize delMessageArr = _delMessageArr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.navigationItem.leftBarButtonItem = nil;
        self.leftBtn.hidden = YES;
        [self.rightBtn setTitle:@"删除" forState:UIControlStateNormal];
        
    }
    return self;
}
- (void)rightBarButtonClick:(id)sender
{
//    _edit = !_edit;
//    [_theTable setEditing: _edit animated:YES];
//    [self.rightBtn setTitle:_edit?@"保存":@"编辑" forState:UIControlStateNormal];
    [self delMessageFromArray];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _selectItemArray = [[NSMutableArray alloc] initWithCapacity:0];
    _delMessageArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i<7; i++) {
        [_selectItemArray addObject:[NSNumber numberWithBool:NO]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"indexPath%d",indexPath.row];
    if ([[_selectItemArray objectAtIndex:indexPath.row] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *state = [_selectItemArray objectAtIndex:indexPath.row];
    if ([state isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        state = [NSNumber numberWithBool:NO];
    }else{
        state = [NSNumber numberWithBool:YES];
    }
    [_selectItemArray replaceObjectAtIndex:indexPath.row withObject:state];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}
// 删除消息
- (void)delMessageFromArray
{
    for (int i = 0; i<7; i++) {
        if ([[_selectItemArray objectAtIndex:i] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            //从消息数组里找出对应要删除 消息
            //[_delMessageArr addObject:<#(id)#>];
        }
    }
    
    KHHNetworkAPIAgent *messageAgent = [[KHHNetworkAPIAgent alloc] init];
    [messageAgent deleteMessages:_delMessageArr];
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:YES];
    //_theTable.editing = !_theTable.editing;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _theTable = nil;
    _selectItemArray = nil;
    _delMessageArr = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
