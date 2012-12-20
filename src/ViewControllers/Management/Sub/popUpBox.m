//
//  popUpBox.m
//  popUpDemo
//
//  Created by bbk on 11-6-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "popUpBox.h"

@implementation popUpBox
@synthesize myNavigationBar;
@synthesize selectContentLabel;
@synthesize hiddenButton;
@synthesize popUpBoxTableView;
@synthesize popUpBoxDatasource;
@synthesize myAlertView;

-(id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame: frame])) {
		// 添加一个导航栏
		myNavigationBar = [[UINavigationBar alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, frame.size.height)];
		[self addSubview: myNavigationBar];
		
		// 添加一个标签
		selectContentLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, frame.size.height)];
		selectContentLabel.textAlignment = UITextAlignmentCenter;
		selectContentLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:selectContentLabel];
		
		// 添加一个隐藏的按钮
		hiddenButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[hiddenButton setFrame: CGRectMake(0, 0, frame.size.width, frame.size.height)];
		hiddenButton.backgroundColor = [UIColor clearColor];
		[hiddenButton addTarget:self action:@selector(hiddenButtonClicked) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:hiddenButton];
		
		// 添加一个tableView
		popUpBoxTableView = [[UITableView alloc] initWithFrame: CGRectMake(15, 50, 255, 225)];
		popUpBoxTableView.delegate = self;
		popUpBoxTableView.dataSource = self;
		
		// 添加一个alertView
		myAlertView = [[UIAlertView alloc] initWithTitle: @"请选择一个城市" message: @"\n\n\n\n\n\n\n\n\n\n\n" delegate: nil cancelButtonTitle: @"取消" otherButtonTitles: nil];
		[myAlertView addSubview: popUpBoxTableView];
		
    }
	return self;
}

-(void)hiddenButtonClicked {
	[myAlertView show];
}

#pragma mark table data source delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {	
	int n = [popUpBoxDatasource count];
	return n;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"ListCellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	NSString *text = [popUpBoxDatasource objectAtIndex:indexPath.row];
	cell.textLabel.text = text;
	cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
	
	return cell;
}

#pragma mark tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 35.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// 点击使alertView消失
	NSUInteger cancelButtonIndex = myAlertView.cancelButtonIndex;
	[myAlertView dismissWithClickedButtonIndex: cancelButtonIndex animated: YES];
	NSString *selectedCellText = [popUpBoxDatasource objectAtIndex:indexPath.row];
	
	selectContentLabel.text = selectedCellText;			
}

-(void)dealloc {
	[super dealloc];
	[myNavigationBar release];
	[selectContentLabel release];
	[myAlertView release];
	[popUpBoxTableView release];
}
@end
