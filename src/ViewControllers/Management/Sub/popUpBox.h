//
//  popUpBox.h
//  popUpDemo
//
//  Created by bbk on 11-6-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface popUpBox : UIView<UITableViewDelegate, UITableViewDataSource> {
	UINavigationBar *myNavigationBar;
	UILabel			*selectContentLabel;
	UIButton		*hiddenButton;
	UITableView		*popUpBoxTableView;
	NSArray		    *popUpBoxDatasource;
	UIAlertView		*myAlertView;
}

@property(nonatomic, retain) UINavigationBar *myNavigationBar;
@property(nonatomic, retain) UILabel *selectContentLabel;
@property(nonatomic, retain) UIButton *hiddenButton;
@property(nonatomic, retain) UITableView *popUpBoxTableView;
@property(nonatomic, retain) NSArray *popUpBoxDatasource;
@property(nonatomic, retain) UIAlertView *myAlertView;

@end
