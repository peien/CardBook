//
//  UIViewController+SM.m
//
//  Created by 孙铭 on 12-9-13.
//

#import "UIViewController+SM.h"

@implementation UIViewController (SMNavigation)
- (void)pushViewControllerClass:(Class)vcClass animated:(BOOL)animated {
    [self.navigationController pushViewController:[[vcClass alloc] initWithNibName:nil bundle:nil]
                                         animated:animated];
}
@end
@implementation UIViewController (SMAlert)
- (void)alertWithTitle:(NSString *)title message:(NSString *)message {
    [self alertWithTitle:title
                 message:message
                delegate:self
       cancelButtonTitle:NSLocalizedString(@"OK", nil)];
}

- (void)alertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle {
    UIAlertView *alert = 
    [[UIAlertView alloc] initWithTitle:title
                               message:message
                              delegate:delegate
                     cancelButtonTitle:cancelButtonTitle
                     otherButtonTitles:nil];
    [alert show];
}

@end