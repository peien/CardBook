//
//  KHHFloatBarController.h
//  CardBook
//
//  Created by 孙铭 on 8/7/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol KHHFloatBarControllerDelegate<NSObject>
- (void)BtnTagValueChanged:(NSInteger)index;
@end

@interface KHHFloatBarController : UIViewController
@property (nonatomic, weak)   IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet UIView *viewF;
@property (assign, nonatomic) id<KHHFloatBarControllerDelegate>delegate;
@property (assign, nonatomic) bool isFour;
//- (IBAction)BtnTagValueChanged:(id)sender;
- (IBAction)BtnClick:(id)sender;
@end
