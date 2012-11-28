//
//  myAlertView.m
//  LoveCard
//
//  Created by gh w on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "myAlertView.h"

@implementation myAlertView
@synthesize btnAddOwn = _btnAddOwn;
@synthesize btnAddNet = _btnAddNet;
@synthesize alertStyle = _alertStyle;
@synthesize theTable = _theTable;
@synthesize Tf = _Tf;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate style:(kMyAlertStyle)style
  cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles,nil];
    if (self) {
        _alertStyle = style;
        if (_alertStyle == kMyAlertStyleButton) {
            //[self creatMyAlertViewOnButton:delegate];
        }else if (_alertStyle == kMyAlertStyleTable) {
            //[self creatMyAlertViewOnTable];
        }else if (_alertStyle == kMyAlertStyleTextField){
            [self creatMyAlertViewOnTextfield];
        }
    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code

}

//// 创建上面的按扭
//- (void)creatMyAlertViewOnButton:(id)delegate
//{
//    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    _btnAddOwn = btn1;
//    _btnAddOwn.tag = 101;
//    [_btnAddOwn setTitle:@"手动录入" forState:UIControlStateNormal];
//    [_btnAddOwn addTarget:delegate action:@selector(btnAddOwnClick:) forControlEvents:UIControlEventTouchUpInside];
//    _btnAddOwn.frame = CGRectMake(22, 45, 240, 36);
//    [self addSubview:_btnAddOwn];
//    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    _btnAddNet = btn2;
//    _btnAddNet.tag = 102;
//    [_btnAddNet setTitle:@"在线申请" forState:UIControlStateNormal];
//    [_btnAddNet addTarget:delegate action:@selector(btnAddNetClick:) forControlEvents:UIControlEventTouchUpInside];
//    _btnAddNet.frame = CGRectMake(22, 90, 240, 36);
//    [self addSubview:_btnAddNet];
//
//}
//
//// 创建上面的表
//- (void)creatMyAlertViewOnTable
//{
//    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(22, 45, 240, 95) style:UITableViewStylePlain];
//    table.delegate = self;
//    table.dataSource = self;
//    table.showsVerticalScrollIndicator = NO;
//    table.scrollEnabled = NO;
//    _theTable = table;
//    [self addSubview:_theTable];
//}
//创建上面的textfield
- (void)creatMyAlertViewOnTextfield
{
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(22, 45, 240, 36)];
    tf.borderStyle = UITextBorderStyleRoundedRect;
    _Tf = tf;
    [self addSubview:tf];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = nil;
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"爱心卡包帐号";
    }else if (indexPath.row == 1) {
        cell.textLabel.text = @"新浪微博帐号";
    }else {
        cell.textLabel.text = @"爱心号";
    }
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]||[view isKindOfClass:NSClassFromString(@"UIThreePartButton")]) {
            if (view.tag != 101 && view.tag != 102 && _alertStyle == kMyAlertStyleButton) {
                CGRect btnBounds = view.frame;
                btnBounds.origin.y = _btnAddNet.frame.origin.y + _btnAddNet.frame.size.height +7;
                view.frame = btnBounds;
            }else if (_alertStyle == kMyAlertStyleTable) {
                CGRect btnBounds = view.frame;
                btnBounds.origin.y = _theTable.frame.origin.y + _theTable.frame.size.height+3;
                view.frame = btnBounds;
            }else if (_alertStyle == kMyAlertStyleTextField){
                CGRect btnBounds = view.frame;
                btnBounds.origin.y = _Tf.frame.origin.y + _Tf.frame.size.height +7;
                view.frame = btnBounds;
            }

        }
        
    }
    // 220
    CGRect bounds = self.frame;
    bounds.size.height = 180;
    self.frame = bounds;
    
}
@end
