//
//  IntroViewController.h
//
//  Created by Ming Sun on 12-5-2.
//

#import <UIKit/UIKit.h>

@interface IntroViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *theScrollView;
//是否来自启动页
@property (nonatomic, assign) BOOL isFromStartUp;
@end
