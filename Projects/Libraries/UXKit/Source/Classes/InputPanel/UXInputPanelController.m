
#import <UXKit/UXInputPanelController.h>
#import <UXKit/UXInputPanel.h>

@implementation UXInputPanelController

	@synthesize delegate;
	@synthesize panelView;
	@synthesize contentView;

	#pragma mark UIViewController

	-(void) loadView {
		[super loadView];
		
		CGSize screenSize = UXScreenBounds().size;

		self.view = [[[UIView alloc] init] autorelease];
		contentView = [[UXView alloc] init];
		contentView.style = UXSTYLESHEETPROPERTY(panel);
		[self.view addSubview:contentView];

		contentView.frame	= CGRectMake(0, 0, screenSize.width, 216);
		self.view.frame		= CGRectMake(0, screenSize.height - contentView.height, screenSize.width, contentView.height);
		
		self.view.autoresizingMask		= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	}

	-(void) viewDidUnload {
		[super viewDidUnload];
	}

	-(CGAffineTransform) transformForOrientation {
		return UXRotateTransformForOrientation(UXInterfaceOrientation());
	}

	#pragma mark @UXPopupViewController

	-(void) showInView:(UIView *)aView animated:(BOOL)animated {
		[self retain];
		UXLOG(@"VIEW = %@", aView);
		UXLOG(@"SUPERVIEW = %@", aView.superview);
		UXLOG(@"WINDOW = %@", aView.window);
		UXLOG(@"VIEW CONTROLLER = %@", [aView viewController]);

		[aView addSubview:self.view];
		self.view.alpha = 0.75;
		self.view.frame = CGRectMake(0, CGRectGetMaxY(aView.frame), CGRectGetWidth(aView.frame), 216);
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.25];
		CGRect frame		= self.view.frame;
		frame.origin.y		= CGRectGetMaxY(aView.frame) - self.view.height;
		self.view.frame		= frame;
		[UIView commitAnimations];
	}

	-(void) showAnimationDidStop {
		[self dismissPopupViewControllerAnimated:NO];
	}

	-(void) dismissPopupViewControllerAnimated:(BOOL)animated {
		if (animated) {
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.25];		
			CGRect frame		= self.view.frame;
			frame.origin.y		= CGRectGetMaxY(self.view.superview.frame);
			self.view.frame		= frame;
			[UIView setAnimationDidStopSelector:@selector(showAnimationDidStop)];
			[UIView commitAnimations];
		}
		else {
			UIViewController *superController = self.superController;
			[self.view removeFromSuperview];
			[self release];
			superController.popupViewController = nil;
			[superController viewWillAppear:animated];
			[superController viewDidAppear:animated];
		}
	}

	#pragma mark Destructor

	-(void) dealloc {
		UX_SAFE_RELEASE(panelView);
		UX_SAFE_RELEASE(contentView);
		[super dealloc];
	}

@end
