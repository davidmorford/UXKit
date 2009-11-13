
#import <UXKit/UXLauncherViewController.h>
#import <UXKit/UXDefaultStyleSheet.h>
#import <UXKit/UXURLCache.h>

@interface UXLauncherViewController (Private)
	-(void) dismissChildAnimated:(BOOL)animated;
@end

#pragma mark -

@implementation UXLauncherViewController

	@synthesize launcherNavigationController = _launcherNavigationController;
	@synthesize launcherView = _launcherView;

	#pragma mark Initializer

	-(id) init {
		if (self = [super init]) {
			_launcherNavigationController = nil;
			_overlayView = nil;
		}
		return self;
	}

	#pragma mark UIViewController

	-(void) loadView {
		[super loadView];
		_launcherView					= [[UXLauncherView alloc] initWithFrame:self.view.bounds];
		_launcherView.backgroundColor	= UXSTYLEVAR(launcherBackgroundColor);
		self.view						= _launcherView;
	}

	-(void) viewWillAppear:(BOOL)animated {
		[super viewWillAppear:animated];
		[_launcherNavigationController viewWillAppear:animated];
	}

	-(void) viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];
		[_launcherNavigationController viewDidAppear:animated];
	}

	-(void) viewWillDisappear:(BOOL)animated {
		[super viewWillDisappear:animated];
		[_launcherNavigationController viewWillDisappear:animated];
	}

	-(void) viewDidDisappear:(BOOL)animated {
		[super viewDidDisappear:animated];
		[_launcherNavigationController viewDidDisappear:animated];
	}

	-(CGAffineTransform) transformForOrientation {
		return UXRotateTransformForOrientation(UXInterfaceOrientation());
	}


	#pragma mark OverlayView

	-(CGRect) rectForOverlayView {
		return [_launcherView frameWithKeyboardSubtracted:0];
	}

	-(void) addOverlayView {
		if (!_overlayView) {
			CGRect frame						= [self rectForOverlayView];
			_overlayView						= [[UIView alloc] initWithFrame:frame];
			_overlayView.backgroundColor		= [UIColor blackColor];
			_overlayView.alpha					= 0.0f;
			_overlayView.autoresizesSubviews	= YES;
			_overlayView.autoresizingMask		= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
			[_launcherView addSubview:_overlayView];
		}
		self.view.frame				= _overlayView.bounds;
		self.view.autoresizingMask	= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	}

	-(void) resetOverlayView {
		if (_overlayView && !_overlayView.subviews.count) {
			[_overlayView removeFromSuperview];
			UX_SAFE_RELEASE(_overlayView);
		}
	}

	-(void) layoutOverlayView {
		if (_overlayView) {
			_overlayView.frame = [self rectForOverlayView];
		}
	}


	#pragma mark AnimationDelegate

	-(void) showAnimationDidStop {
		//[[_launcherNavigationController topViewController] viewDidAppear:YES];
	}

	-(void) fadeAnimationDidStop {
		[self dismissChildAnimated:NO];
		UX_SAFE_RELEASE(_overlayView);
	}

	-(void) fadeOut {
		UIView *viewToDismiss		= [[_launcherNavigationController topViewController] view];
		viewToDismiss.transform		= CGAffineTransformIdentity;
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:UX_LAUNCHER_HIDE_TRANSITION_DURATION];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(fadeAnimationDidStop)];
		
		viewToDismiss.alpha			= 0;
		viewToDismiss.transform		= CGAffineTransformMakeScale(0.00001, 0.00001);
		_overlayView.alpha			= 0.0f;
		[self resetOverlayView];
		[UIView commitAnimations];
	}

	-(void) launchChild {
		UIView *viewToLaunch		= [[_launcherNavigationController topViewController] view];
		viewToLaunch.transform		= [self transformForOrientation];
		
		[self.superController.view addSubview:[_launcherNavigationController view]];
		_launcherNavigationController.superController = self;
		
		viewToLaunch.frame			= self.view.bounds;
		viewToLaunch.alpha			= 0;
		viewToLaunch.transform		= CGAffineTransformMakeScale(0.00001, 0.00001);
		
		// Add overlay view
		[self addOverlayView];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:UX_LAUNCHER_SHOW_TRANSITION_DURATION];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(showAnimationDidStop)];
		
		viewToLaunch.alpha		= 1.0f;
		viewToLaunch.transform	= CGAffineTransformIdentity;
		_overlayView.alpha		= 0.85f;
		[UIView commitAnimations];
	}

	-(void) addSubcontroller:(UIViewController *)controller animated:(BOOL)animated transition:(UIViewAnimationTransition)transition {
		if (!_launcherNavigationController) {
			_launcherNavigationController					= [[UINavigationController alloc] initWithRootViewController:controller];
			_launcherNavigationController.superController	= self;
			_launcherNavigationController.delegate			= self;
			
			// Add default left-side button in navigation bar
			UIBarButtonItem *launcherBarButtonItem = [[UIBarButtonItem alloc] initWithImage:UXIMAGE(@"bundle://UXKit.bundle/Images/Launcher/launcher.png") 
																					  style:UIBarButtonItemStyleBordered 
																					 target:self 
																					 action:@selector(dismissChild)];
			[controller.navigationItem setLeftBarButtonItem:launcherBarButtonItem];
			[launcherBarButtonItem release];
			
			// Launch child
			[[_launcherNavigationController topViewController] viewWillAppear:animated];
			[self launchChild];
		}
		else {
			[_launcherNavigationController addSubcontroller:controller animated:animated transition:transition];
		}
	}

	-(void) dismissChild {
		[self dismissChildAnimated:YES];
	}

	-(void) dismissChildAnimated:(BOOL)animated {
		if (animated) {
			[self fadeOut];
		}
		else {
			[[_launcherNavigationController topViewController] viewWillDisappear:animated];
			UIView *viewToDismiss = [_launcherNavigationController view];
			[viewToDismiss removeFromSuperview];
			[[_launcherNavigationController topViewController] viewDidDisappear:animated];
			UX_SAFE_RELEASE(_launcherNavigationController);
			[self.superController viewWillAppear:animated];
			[self.superController viewDidAppear:animated];
		}
		[[_launcherNavigationController topViewController] viewDidDisappear:animated];
	}


	#pragma mark UIViewController (UXUIViewController)

	-(void) persistNavigationPath:(NSMutableArray *)path {
		if (_launcherNavigationController) {
			// We have controllers open inside the launcher controller, so persist it
			[_launcherNavigationController persistNavigationPath:path];
		}
	}

	#pragma mark <UINavigationControllerDelegate>

	-(void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
		[viewController viewWillAppear:animated];
	}

	-(void) navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
		[viewController viewDidAppear:animated];
	}

	#pragma mark Destructor

	-(void) dealloc {
		UX_SAFE_RELEASE(_overlayView);
		UX_SAFE_RELEASE(_launcherView);
		UX_SAFE_RELEASE(_launcherNavigationController);
		[super dealloc];
	}

@end
