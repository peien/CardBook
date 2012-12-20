//
//  KHHFilterPopup.h
//  CardBook
//
//  Created by CJK on 12-12-20.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KHHFilterPopupDelegate <NSObject>
@optional
- (void)selectInAlert:(NSString *)index;
@end

@interface KHHFilterPopup : NSObject <UITableViewDelegate, UITableViewDataSource> {
    
    UITableView	*popUpBoxTableView;
    UIAlertView *alert;
    NSArray *dataArr;
    int seleIndex;
}
@property (nonatomic,strong) id<KHHFilterPopupDelegate> delegate;
+ (KHHFilterPopup *)shareUtil;

- (void)showPopUp:(NSArray *)array index:(int)index delegate:(id<KHHFilterPopupDelegate>)delegate;
- (void)showPopUp:(NSArray *)array index:(int)index Title:(NSString *)title delegate:(id<KHHFilterPopupDelegate>)delegate;

@end
