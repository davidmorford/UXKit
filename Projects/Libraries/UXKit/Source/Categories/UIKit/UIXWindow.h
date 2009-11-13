
/*!
@project    UXKit
@header     UIXWindow.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Jonathan Saggau
*/

#import <UIKit/UIKit.h>

@interface UIWindow (UIXWindow)

	-(UIView *) findFirstResponder;

	-(UIView *) findFirstResponderInView:(UIView *)topView;

@end
