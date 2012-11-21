//
//  KHHCustomEvaluaView.m
//  CardBook
//
//  Created by 王国辉 on 12-8-24.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "KHHCustomEvaluaView.h"
#import "KHHLabFieldCell.h"
#import "DLStarRatingControl.h"
#import "KHHClasses.h"
#import "KHHDataAPI.h"

@implementation KHHCustomEvaluaView

@synthesize theTableOne = _theTableOne;
@synthesize isFieldValueEdit = _isFieldValueEdit;
@synthesize delegate = _delegate;
@synthesize importFlag = _importFlag;
@synthesize relationEx = _relationEx;
@synthesize customValue = _customValue;
@synthesize card;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma mark -
#pragma mark Table delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    KHHLabFieldCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
       cell = [[[NSBundle mainBundle] loadNibNamed:@"KHHLabFieldCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.fieldName.font = [UIFont systemFontOfSize:12];
        cell.fieldValue.font = [UIFont systemFontOfSize:12];
        cell.fieldValue.delegate = self;
    }
    if (_isFieldValueEdit) {
        cell.fieldValue.enabled = YES;
        cell.fieldValue.placeholder = @"请输入重要标记";
    }else{
        cell.fieldValue.enabled = NO;
    }
    if (indexPath.row == 0) {
        cell.fieldName.text = @"重要标记:";
        cell.fieldValue.text = _importFlag;
    }else if (indexPath.row == 1 || indexPath.row == 2){
        [cell.fieldValue removeFromSuperview];
        DLStarRatingControl *customStarImageControl = [[DLStarRatingControl alloc] initWithFrame:CGRectMake(5, 10, 280, 45)];
        customStarImageControl.backgroundColor = [UIColor clearColor];
        customStarImageControl.delegate = self;
        customStarImageControl.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        customStarImageControl.rating = 3;
        if (_isFieldValueEdit) {
            customStarImageControl.userInteractionEnabled = YES;
        }else
            customStarImageControl.userInteractionEnabled = NO;
        if (indexPath.row == 1) {
            cell.fieldName.text = @"关系拓展:";
            customStarImageControl.rating = _relationEx;
            customStarImageControl.tag = 7788;
        }else if (indexPath.row == 2){
            cell.fieldName.text = @"客户价值:";
            customStarImageControl.rating = _customValue;
            customStarImageControl.tag = 7789;
        }
        [cell.contentView addSubview:customStarImageControl];

    }
    return cell;
}
-(void)newRating:(DLStarRatingControl *)control :(float)rating
{
    DLog(@"tag=====%d rating======%f",control.tag,rating);
    [_delegate handleStarNum:control startNum:rating];

}
#pragma mark -
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [_delegate handleTextfieldValue:textField];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [_delegate handleTextfieldValue:textField];
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_delegate handleTextfieldValue:textField];

}

- (void)reloadTable{
    
    _importFlag = self.card.evaluation.remarks;
    _relationEx = [self.card.evaluation.degree floatValue];
    _customValue = [self.card.evaluation.value floatValue];
    [_theTableOne reloadData];
}

@end
