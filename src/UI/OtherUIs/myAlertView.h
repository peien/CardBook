//
//  myAlertView.h
//  LoveCard
//
//  Created by gh w on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    kMyAlertStyleTable,
    kMyAlertStyleButton,
    kMyAlertStyleTextField
}kMyAlertStyle;

@interface myAlertView : UIAlertView<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UIButton *btnAddOwn;
@property (strong, nonatomic) UIButton *btnAddNet;
@property (strong, nonatomic) UITableView *theTable;
@property (assign, nonatomic) kMyAlertStyle alertStyle;
@property (strong, nonatomic) UITextField *Tf;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate style:(kMyAlertStyle)style
  cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;
@end
