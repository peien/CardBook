//
//  KHHFilterPopup.m
//  CardBook
//
//  Created by CJK on 12-12-20.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHFilterPopup.h"
#import "KHHDataNew+Group.h"
#import "Group.h"
//#import "KHHData+UI.h"
@implementation KHHFilterPopup



+ (KHHFilterPopup *)shareUtil{
    static KHHFilterPopup *_sharedObj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedObj = [[KHHFilterPopup alloc] init];
    });
    return _sharedObj;
}

- (void)showPopUpGroup:(int)index delegate:(id<KHHFilterPopupDelegate>)delegate
{
    arrPro = [[KHHDataNew sharedData]allTopLevelGroups];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    [arr addObject:@"所有"];
    [arrPro enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Group *grp= (Group *)obj;
       [arr addObject: grp.name];
    }];
    [self showPopUp:arr index:index delegate:delegate];
}

- (void)showPopUp:(NSArray *)array index:(int)index delegate:(id<KHHFilterPopupDelegate>)delegate
{
    isSelectGroup = YES;
    [self showPopUp:array index:index Title:@"选择分组" delegate:delegate];
}

- (void)showPopUp:(NSArray *)array index:(int)index Title:(NSString *)title delegate:(id<KHHFilterPopupDelegate>)delegate
{
    isSelectGroup = NO;
    _delegate = delegate;
    dataArr = array;
    seleIndex = index;
    alert= [[UIAlertView alloc] initWithTitle: title message: @"\n\n\n\n\n\n\n\n\n\n\n" delegate: nil cancelButtonTitle: @"取消" otherButtonTitles: nil];
    
    popUpBoxTableView = [[UITableView alloc] initWithFrame: CGRectMake(15, 50, 255, 220)];
  
    popUpBoxTableView.delegate = self;
    popUpBoxTableView.dataSource = self;
    [alert addSubview:popUpBoxTableView];
    [alert show];
    
}

#pragma mark table data source delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int n = [dataArr count];
	return n;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"ListCellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
	}
	
	NSString *text = [dataArr objectAtIndex:indexPath.row];// [popUpBoxDatasource objectAtIndex:indexPath.row];
	cell.textLabel.text = text;
    if (indexPath.row == seleIndex) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    } 
	cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
	
	return cell;
}

#pragma mark tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 40.0f;    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// 点击使alertView消失
	NSUInteger cancelButtonIndex = alert.cancelButtonIndex;
	[alert dismissWithClickedButtonIndex: cancelButtonIndex animated: YES];
	//NSString *selectedCellText = [popUpBoxDatasource objectAtIndex:indexPath.row];
	if (_delegate && [_delegate respondsToSelector:@selector(selectInAlert:)]) {
        if (isSelectGroup) {
            if (indexPath.row == 0) {
                [_delegate performSelector:@selector(selectInAlert:) withObject:nil ];
            } else {
                NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:[arrPro objectAtIndex:indexPath.row-1],@"obj",[NSString stringWithFormat:@"%d",indexPath.row],@"groupIndex", nil];
                [_delegate selectInAlert:dic];
            }
        }else {
            //用户传入的数组信息
            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                                 [dataArr objectAtIndex:indexPath.row],@"selectItem",
                                 [NSString stringWithFormat:@"%d",indexPath.row],@"index",
                                 nil];
            [_delegate selectInAlert:dic];
        }
    } 
    
	//selectContentLabel.text = selectedCellText;
}




@end
