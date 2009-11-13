
#import <UXKit/UXPopupViewController.h>

@implementation UXPopupViewController

	#pragma mark <NSObject>

	-(id) init {
		if (self = [super init]) {
			_statusBarStyle = [UIApplication sharedApplication].statusBarStyle;
		}
		return self;
	}

	#pragma mark API

	-(void) showInView:(UIView *)view animated:(BOOL)animated {
	
	}

	-(void) dismissPopupViewControllerAnimated:(BOOL)animated {
	
	}

	#pragma mark <NSObject>

	-(void) dealloc {
		self.superController.popupViewController = nil;
		[super dealloc];
	}

@end
