//
//  KHHAddGroupMemberVC.m
//  CardBook
//
//  Created by 王国辉 on 12-8-21.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "KHHAddGroupMemberVC.h"
#import "khhClientCellLNPC.h"
#import "SMCheckbox.h"
#import "KHHShowHideTabBar.h"
#import "KHHMySearchBar.h"
@interface KHHAddGroupMemberVC ()<UISearchBarDelegate,UISearchDisplayDelegate,
                                 UITableViewDataSource,UITableViewDelegate,SMCheckboxDelegate>

@property (strong, nonatomic) SMCheckbox *box;

@end

@implementation KHHAddGroupMemberVC
@synthesize searbarCtrl = _searbarCtrl;
@synthesize theTableM = _theTableM;
@synthesize sureBtn = _sureBtn;
@synthesize footView = _footView;
@synthesize cancelBtn = _cancelBtn;
@synthesize numLab = _numLab;
@synthesize isAdd = _isAdd;
@synthesize box = _box;
@synthesize selectedItemArray = _selectedItemArray;
@synthesize addGroupArray = _addGroupArray;
@synthesize resultArray = _resultArray;
@synthesize searchArray = _searchArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.rightBarButtonItem = nil;
        
    }
    return self;
}
- (void)leftBarButtonClick:(id)sender
{
    num = 0;
    [self.navigationController popViewControllerAnimated:YES];
}
//- (void)rightBarButtonClick:(id)sender
//{
//   
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    KHHMySearchBar *searchBar = [[KHHMySearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 37) simple:YES];
    UISearchDisplayController *searCtrl = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searCtrl.delegate = self;
    searCtrl.searchResultsDataSource = self;
    searCtrl.searchResultsDelegate = self;
    self.searbarCtrl = searCtrl;
    [self.view addSubview:searchBar];
    if (_isAdd) {
        [_sureBtn setTitle:NSLocalizedString(@"添加",nil) forState:UIControlStateNormal];
        self.title = NSLocalizedString(@"添加组员", nil);
    }else{
        [_sureBtn setTitle:NSLocalizedString(@"移出",nil) forState:UIControlStateNormal];
        self.title = NSLocalizedString(@"移出组员", nil);
    }
    _selectedItemArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i<12; i++) {
        [_selectedItemArray addObject:[NSNumber numberWithBool:NO]];
    }
    _addGroupArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    //构建搜索表
    _searchArray = [[NSArray alloc] initWithObjects:@"孙悟空",@"孙三",@"孙四", nil];
    _resultArray = [[NSArray alloc] init];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [KHHShowHideTabBar hideTabbar];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _theTableM = nil;
    _footView = nil;
    _searbarCtrl = nil;
    _sureBtn = nil;
    _cancelBtn = nil;
    _numLab = nil;
    _box = nil;
    _addGroupArray = nil;
    _selectedItemArray = nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searbarCtrl.searchResultsTableView ) {
        return [_resultArray count];
    }else
    return 12;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searbarCtrl.searchResultsTableView) {
        return 44;
    }else
    return 66;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searbarCtrl.searchResultsTableView) {
        static NSString *cellID = @"searchID";
        UITableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.textLabel.text = [_resultArray objectAtIndex:indexPath.row];
        return cell;
        
    }else{
        static NSString *cellID = @"CELLID";
        KHHClientCellLNPC *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"KHHClientCellLNPC" owner:self options:nil] objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //        _box = [[[NSBundle mainBundle] loadNibNamed:@"SMCheckbox" owner:self options:nil] objectAtIndex:0];
            //        _box.frame = CGRectMake(280, 10, 35, 35);
            
            
        }
        if ([[_selectedItemArray objectAtIndex:indexPath.row] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            //cell.accessoryType = UITableViewCellAccessoryCheckmark;
            UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkbox_yes.png"]];
            imgView.frame = CGRectMake(280, 10, 30, 30);
            [cell addSubview:imgView];
        }else{
            //cell.accessoryType = UITableViewCellAccessoryNone;
            UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkbox_no.png"]];
            imgView.frame = CGRectMake(280, 10, 30, 30);
            [cell addSubview:imgView];
            
        }
        return cell;
    }
}
int num = 0;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSNumber *state = [_selectedItemArray objectAtIndex:indexPath.row];
    if ([state isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        state = [NSNumber numberWithBool:NO];
        num--;
    }else{
        state = [NSNumber numberWithBool:YES];
        num++;
    }
    NSString *s = [NSString stringWithFormat:@"(%d)",num];
    self.numLab.text = s;
    if (num == 0) {
           self.numLab.hidden = YES;
       }else{
           self.numLab.hidden = NO;
    }
    [_selectedItemArray replaceObjectAtIndex:indexPath.row withObject:state];
    [_theTableM reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [_theTableM deselectRowAtIndexPath:indexPath animated:NO];
}

- (IBAction)sureBtnClick:(id)sender
{
    for (int i = 0; i<12; i++) {
        if ([[_selectedItemArray objectAtIndex:i] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            [_addGroupArray addObject:[_selectedItemArray objectAtIndex:i]];
        }else{
            //[_addGroupArray removeObjectAtIndex:i];
        }
    }
    
    //调用接口
    if (_isAdd) {
       //调用添加组员接口
    }else{
       //调用移出组员接口
    }
    [self.navigationController popViewControllerAnimated:YES];
    num = 0;
    

}
- (IBAction)cancelBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)checkBox:(SMCheckbox *)checkBox valueChanged:(BOOL)newValue
{
//    KHHClientCellLNPC *cell = (KHHClientCellLNPC *)[[checkBox superview] superview];
//    NSNumber *value = [NSNumber numberWithBool:newValue];
//    //DLog(@"checkBox======%@",value);
//    if ([value isEqualToNumber:[NSNumber numberWithBool:YES]]) {
//        cell.selected = YES;
//        num++;
//        DLog(@"num=======%d",num);
//    }else{
//    
//        cell.selected = NO;
//        num--;
//        DLog(@"num======%d",num);
//    }
//    NSString *s = [NSString stringWithFormat:@"(%d)",num];
//    self.numLab.text = s;
//    if (num == 0) {
//        self.numLab.hidden = YES;
//    }else{
//        self.numLab.hidden = NO;
//    }
//    //
//    NSIndexPath *indexPath = [_theTableM indexPathForCell:cell];

}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSPredicate *resultPre = [NSPredicate predicateWithFormat:@"SELF contains[cd]%@",searchString];
    _resultArray = [_searchArray filteredArrayUsingPredicate:resultPre];
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
