//
//  ModifyViewController.m
//  LoveCard
//
//  Created by gh w on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ModifyViewController.h"
#define LABEL_CELL_TAG 555
#define TEXTFIELD_CELL_TAG 666
@interface ModifyViewController ()

@end

@implementation ModifyViewController
@synthesize theTable = _theTable;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"完成" 
                                                                     style:UIBarButtonItemStylePlain 
                                                                    target:self 
                                                                    action:@selector(rightBarClick:)];
        self.navigationItem.rightBarButtonItem = rightBar;
        self.title = @"修改密码";
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
    return 3;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 90.0f, 15.0f)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.numberOfLines = 0;
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.contentMode = UIViewContentModeScaleAspectFit;
        label.tag = LABEL_CELL_TAG;
        [cell.contentView addSubview:label];
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(100.0f, 7.0f, 200.0f, 40.0f)];
        textfield.tag = TEXTFIELD_CELL_TAG;
        textfield.font = [UIFont systemFontOfSize:12];
        textfield.adjustsFontSizeToFitWidth = YES;
        [cell.contentView addSubview:textfield];
    }
    UILabel *lab = (UILabel *)[cell.contentView viewWithTag:LABEL_CELL_TAG];
    UITextField *tf = (UITextField *)[cell.contentView viewWithTag:TEXTFIELD_CELL_TAG];
    if (indexPath.row == 0) {
        lab.text = @"旧密码";
        tf.tag = 1122;
        tf.placeholder = @"请输入旧密码";
    }else if (indexPath.row == 1) {
        lab.text = @"新密码";
        tf.tag = 1123;
        tf.placeholder = @"请输入4－12位字符";
    }else if (indexPath.row == 2) {
        lab.text = @"确认密码";
        tf.tag = 1123;
        tf.placeholder = @"请重复密码";
    }
    return cell;

}
- (void)rightBarClick:(id)sender
{

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
