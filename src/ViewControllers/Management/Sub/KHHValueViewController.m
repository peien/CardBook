//
//  KHHValueViewController.m
//  CardBook
//
//  Created by 王国辉 on 12-11-13.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHValueViewController.h"
#import "KHHMySearchBar.h"
#import "KHHClientCellLNPCC.h"
#import "KHHClasses.h"
#import "DetailInfoViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "KHHFloatBarController.h"
#import "WEPopoverController.h"
#import "KHHDataAPI.h"

@interface KHHValueViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
@property (strong, nonatomic)   NSArray                     *resultArray;
@property (strong, nonatomic)   NSArray                     *searchArray;
@property (strong, nonatomic)   KHHFloatBarController       *floatBarVC;
@property (strong, nonatomic)   WEPopoverController         *popover;
@property (assign, nonatomic)   BOOL                        isNeedReloadTable;
@property (strong, nonatomic)   KHHData                     *dataCtrl;
@end

@implementation KHHValueViewController
@synthesize generArr;
@synthesize searCtrl = _searCtrl;
@synthesize resultArray = _resultArray;
@synthesize searchArray = _searchArray;
@synthesize floatBarVC;
@synthesize popover;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.rightBtn.hidden = YES;
        self.dataCtrl = [KHHData sharedData];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    KHHMySearchBar *mySearchBar = [[KHHMySearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44) simple:YES showSearchBtn:NO];
    mySearchBar.delegate = self;
    [self.view addSubview:mySearchBar];
    //点击界面上的searchBar时出来新的界面供搜索并显示新数据源(实现searchBar的委托方法)
    UISearchDisplayController *disCtrl = [[UISearchDisplayController alloc] initWithSearchBar:mySearchBar contentsController:self];
    disCtrl.delegate = self;
    disCtrl.searchResultsDataSource = self;
    disCtrl.searchResultsDelegate = self;
    _searCtrl = disCtrl;
    
    self.floatBarVC = [[KHHFloatBarController alloc] initWithNibName:nil bundle:nil];
    self.floatBarVC.viewController = self;
    self.popover = [[WEPopoverController alloc] initWithContentViewController:floatBarVC];
    self.floatBarVC.popover = self.popover;
}

-(void) viewWillAppear:(BOOL)animated {
    if (_isNeedReloadTable) {
        _isNeedReloadTable = NO;
        [self reloadTable];
    }
}

//刷新table
- (void)reloadTable
{
    switch (_valueType) {
        case KHHCustomerVauleFunnel:
        {
            if (_groupID <= 0) {
                self.generArr = [self.dataCtrl cardsofStarts:_value];
            }else {
                self.generArr = [self.dataCtrl cardsofStarts:_value groupId:[NSNumber numberWithLong:_groupID]];
            }
            
        }
            break;
        case KHHCustomerVauleRadar:
        {
            self.generArr = [self.dataCtrl cardsOfstartsForRelation:_value groupID:_groupID];
        }
            break;
        default:
            break;
    }
    
    [self.theTable reloadData];
}

//点击图片弹出横框
- (void)logoBtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    KHHClientCellLNPCC *cell = (KHHClientCellLNPCC *)[[btn superview] superview];
    if (!cell) {
        return;
    }
    NSIndexPath *indexPath = [_theTable indexPathForCell:cell];
    Card *card = [self.generArr objectAtIndex:indexPath.row];
    [self showQuickAction:cell currentCard:card];
}
//显示插件
-(void) showQuickAction:(KHHClientCellLNPCC *) cell currentCard:(Card *) card {
    self.floatBarVC.card = card;
    CGRect cellRect = cell.logoBtn.frame;
    cellRect.origin.x = 98;
    CGRect rect = [cell convertRect:cellRect toView:self.view];
    rect.size.height = 45;
    //DLog(@"[II] logo = %@, frame = %@, converted frame = %@", cell.logoView, NSStringFromCGRect(cell.logoView.frame), NSStringFromCGRect(rect));
    UIPopoverArrowDirection arrowDirection = rect.origin.y < self.view.bounds.size.height/2?UIPopoverArrowDirectionUp:UIPopoverArrowDirectionDown;
    [self.popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:arrowDirection animated:YES];}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searCtrl.searchResultsTableView) {
        return _resultArray.count;
    }
    return self.generArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.searCtrl.searchResultsTableView) {
        static NSString *cellID = @"searchCell";
        UITableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.textLabel.text = [_resultArray objectAtIndex:indexPath.row];
        return cell;
        
    }else{
        static NSString *cellId = @"cellID";
        KHHClientCellLNPCC *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"KHHClientCellLNPCC" owner:self options:nil] objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        Card *card = [self.generArr objectAtIndex:indexPath.row];
        cell.nameLabel.text = card.name;
        cell.positionLabel.text = card.title;
        cell.companyLabel.text =card.company.name;
        [cell.logoBtn setImageWithURL:[NSURL URLWithString:card.logo.url] placeholderImage:[UIImage imageNamed:@"logopic.png"]];
        [cell.logoBtn addTarget:self action:@selector(logoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if ([card isKindOfClass:[ReceivedCard class]]) {
            ReceivedCard *reCard = (ReceivedCard *)card;
            if (reCard.isReadValue) {
                cell.newicon.hidden = YES;
            }else{
                cell.newicon.hidden =  NO;
            }
        }else{
            cell.newicon.hidden = YES;
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _isNeedReloadTable = YES;
    DetailInfoViewController *detailVC = [[DetailInfoViewController alloc] initWithNibName:nil bundle:nil];
    if (tableView == self.searCtrl.searchResultsTableView) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        for (Card *card in self.generArr) {
            if ([cell.textLabel.text isEqualToString:card.name]) {
                self.searCtrl.active = NO;
                detailVC.card = card;
            }
        }
    }else{
        detailVC.card = [self.generArr objectAtIndex:indexPath.row];
    }
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)searcResult{
    _resultArray = [[NSArray alloc] init];
    NSMutableArray *stringArr = [[NSMutableArray alloc] init];
    for (int i = 0; i< self.generArr.count; i++) {
        Card *card = [self.generArr objectAtIndex:i];
        if (card.name.length) {
            [stringArr addObject:card.name];
        }
    }
    _searchArray = stringArr;
}

#pragma mark - UISearchDisplayDelegate
// when we start/end showing the search UI
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    
    for (UIButton *btn in controller.searchBar.subviews) {
        if (btn.tag == 1111 || btn.tag == 2222) {
            btn.hidden = YES;
        }
    }
    [self searcResult];
}

- (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
    
}
- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    for (UIButton *btn in controller.searchBar.subviews) {
        if (btn.tag == 1111 || btn.tag == 2222) {
            btn.hidden = NO;
        }
    }
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    //    CGRect oldFrame = self.searchBar.frame;
    //    self.searchBar.frame = CGRectMake(70, oldFrame.origin.y, 250, oldFrame.size.height);
    
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSPredicate *resultPre = [NSPredicate predicateWithFormat:@"SELF contains[cd]%@",searchString];
    _resultArray = [_searchArray filteredArrayUsingPredicate:resultPre];
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
