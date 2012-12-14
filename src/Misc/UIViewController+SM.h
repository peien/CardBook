//
//  UIViewController+SM.h
//
//  Created by 孙铭 on 12-9-13.
//

#import <UIKit/UIKit.h>

@interface UIViewController (SMNavigation)
- (void)pushViewControllerClass:(Class)vcClass animated:(BOOL)animated;
@end

@interface UIViewController (SMAlert)
- (void)alertWithTitle:(NSString *)title message:(NSString *)message;
- (void)alertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle;
@end