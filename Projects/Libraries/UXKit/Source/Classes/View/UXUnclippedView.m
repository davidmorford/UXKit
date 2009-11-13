
#import <UXKit/UXUnclippedView.h>

@implementation UXUnclippedView

	-(void) didMoveToSuperview {
		for (UIView *p = self; p; p = p.superview) {
			// This allows the view to be shown "full screen", and not offset by the toolbar and status bar
			p.clipsToBounds = NO;
			//p.backgroundColor = self.backgroundColor;
		}
	}

	-(void) setFrame:(CGRect)rect {
		[super setFrame:rect];
	}

@end
