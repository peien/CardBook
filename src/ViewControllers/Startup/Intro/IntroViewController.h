//
//  IntroViewController.h
//
//  Created by Ming Sun on 12-5-2.
//

#import <UIKit/UIKit.h>

@interface IntroViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *theScrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *thePageControl;
@property (nonatomic, weak) IBOutlet UIButton *theButton;
@property (nonatomic, weak) IBOutlet UILabel *theTitleLabel;

- (IBAction)startNow:(id)sender;
@end
