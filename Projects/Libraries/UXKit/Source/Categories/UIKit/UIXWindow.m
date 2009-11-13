
#import <UXKit/UIXWindow.h>

@implementation UIWindow (UIXWindow)

	-(UIView *) findFirstResponder {
		return [self findFirstResponderInView:self];
	}

	-(UIView *) findFirstResponderInView:(UIView *)topView {
		if ([topView isFirstResponder]) {
			return topView;
		}
		
		for (UIView *subView in topView.subviews) {
			if ([subView isFirstResponder]) {
				return subView;
			}
			
			UIView *firstResponderCheck = [self findFirstResponderInView:subView];
			if (firstResponderCheck != nil) {
				return firstResponderCheck;
			}
		}
		return nil;
	}

@end
