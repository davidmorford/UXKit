
#import <UXKit/UXNavigationController.h>
#import <UXKit/UXView.h>
#import <UXKit/UXActivityLabel.h>
#import <UXKit/UXURLCache.h>

CGFloat const UXNavigationShowTransitionDuration = 0.25;
CGFloat const UXNavigationHideTransitionDuration = 0.3;

#pragma mark -

@interface UXNavigationController ()
	-(void) dismissChildAnimated:(BOOL)animated;
	-(void) setupActivityLabel;
@end

#pragma mark -

@implementation UXNavigationController

	@synthesize contentNavigationController;
	@synthesize activityLabel;

	#pragma mark Initializer

	-(id) init {
		if (self = [super init]) {
			contentNavigationController = nil;
			contentOverlayView = nil;
		}
		return self;
	}


	#pragma mark UIViewController (Loading)

	-(void) loadView {
		[super loadView];
		containerView					= [[UXView alloc] initWithFrame:self.view.bounds];
		containerView.backgroundColor	= [UIColor colorWithWhite:(50.0/100.0) alpha:(100.0/100.0)];
		self.view = containerView;
		[self.navigationController setNavigationBarHidden:TRUE animated:FALSE];
		[self.navigationController setToolbarHidden:TRUE animated:FALSE];
	}

	-(void) viewDidLoad {
		[super viewDidLoad];
	}

	-(void) viewDidUnload {
		[super viewDidUnload];
	}

	#pragma mark UIViewController (Appearing)

	-(void) viewWillAppear:(BOOL)animated {
		[super viewWillAppear:animated];
	}

	-(void) viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];
		if (self.navigationController.navigationBarHidden || self.navigationController.toolbarHidden) {
			[self.navigationController setToolbarHidden:TRUE animated:TRUE];
			[self.navigationController setNavigationBarHidden:TRUE animated:FALSE];
		}
	}

	-(void) viewWillDisappear:(BOOL)animated {
		[super viewWillDisappear:animated];
	}

	-(void) viewDidDisappear:(BOOL)animated {
		[super viewDidDisappear:animated];
	}


	#pragma mark Activity Banner

	-(void) setupActivityLabel {
		self.activityLabel			= [[UXActivityLabel alloc] initWithStyle:UXActivityLabelStyleBlackBanner];
		self.activityLabel.font		= [UIFont boldSystemFontOfSize:15];
		//UIView *lastView			= [self.view.subviews lastObject];
		self.activityLabel.text			= @"Loading...";
		[self.activityLabel sizeToFit];
		CGFloat labelHeight			= activityLabel.height + 20;
		self.activityLabel.frame			= CGRectMake(0, CGRectGetMaxY(self.view.frame) - labelHeight, 320, labelHeight);
		UXLOG(@" Activity Label Frame = %@", NSStringFromCGRect(self.activityLabel.frame));
		[self.view addSubview:self.activityLabel];
		[self.view bringSubviewToFront:self.activityLabel];
	}


	#pragma mark OverlayView

	-(CGRect) rectForOverlayView {
		return [containerView frameWithKeyboardSubtracted:0];
	}

	-(void) addOverlayView {
		if (!contentOverlayView) {
			CGRect frame = [self rectForOverlayView];
			contentOverlayView = [[UIView alloc] initWithFrame:frame];
			contentOverlayView.backgroundColor = [UIColor colorWithWhite:0.18 alpha:1.0];
			contentOverlayView.alpha				= 0.0f;
			contentOverlayView.autoresizesSubviews	= YES;
			contentOverlayView.autoresizingMask		= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
			[containerView addSubview:contentOverlayView];
		}
		self.view.frame				= contentOverlayView.bounds;
		self.view.autoresizingMask	= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	}

	-(void) resetOverlayView {
		if (contentOverlayView && !contentOverlayView.subviews.count) {
			[contentOverlayView removeFromSuperview];
			UX_SAFE_RELEASE(contentOverlayView);
		}
	}

	-(void) layoutOverlayView {
		if (contentOverlayView) {
			contentOverlayView.frame = [self rectForOverlayView];
		}
	}

	-(CGAffineTransform) transformForOrientation {
		return UXRotateTransformForOrientation(UXInterfaceOrientation());
	}


	#pragma mark AnimationDelegate

	-(void) showAnimationDidStop {
		[[contentNavigationController topViewController] viewDidAppear:YES];
	}

	-(void) fadeAnimationDidStop {
		[self dismissChildAnimated:NO];
		UX_SAFE_RELEASE(contentOverlayView);
	}

	-(void) fadeOut {
		UIView *viewToDismiss		= [[contentNavigationController topViewController] view];
		viewToDismiss.transform		= CGAffineTransformIdentity;
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:UXNavigationHideTransitionDuration];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(fadeAnimationDidStop)];
		
		viewToDismiss.alpha			= 0;
		viewToDismiss.transform		= CGAffineTransformMakeScale(0.00001, 0.00001);
		contentOverlayView.alpha	= 0.0f;
		[self resetOverlayView];
		[UIView commitAnimations];
	}

	-(void) launchChild {
		UIView *viewToLaunch		= [[contentNavigationController topViewController] view];
		viewToLaunch.transform		= [self transformForOrientation];
		
		[self.superController.view addSubview:[contentNavigationController view]];
		contentNavigationController.superController = self;
		
		viewToLaunch.frame			= self.view.bounds;
		viewToLaunch.alpha			= 0;
		viewToLaunch.transform		= CGAffineTransformMakeScale(0.00001, 0.00001);
		
		[[contentNavigationController topViewController] viewWillAppear:YES];
		
		// Add overlay view
		[self addOverlayView];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:UXNavigationShowTransitionDuration];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(showAnimationDidStop)];
		
		viewToLaunch.alpha			= 1.0f;
		viewToLaunch.transform		= CGAffineTransformIdentity;
		contentOverlayView.alpha	= 0.85f;
		[UIView commitAnimations];
	}


	#pragma mark Content Navigation

	-(void) addSubcontroller:(UIViewController *)controller animated:(BOOL)animated transition:(UIViewAnimationTransition)transition {
		if (!contentNavigationController) {
			contentNavigationController					= [[UINavigationController alloc] initWithRootViewController:controller];
			contentNavigationController.superController	= self;
			
			// Add default left-side button in navigation bar
			UIBarButtonItem *launcherBarButtonItem = [[UIBarButtonItem alloc] initWithImage:UXIMAGE(@"bundle://launcher.png") 
																					  style:UIBarButtonItemStyleBordered 
																					 target:self 
																					 action:@selector(dismissChild)];
			[controller.navigationItem setLeftBarButtonItem:launcherBarButtonItem];
			[launcherBarButtonItem release];
			
			// Launch child
			[self launchChild];
		}
		else {
			[contentNavigationController pushViewController:controller animated:animated];
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
			UIView *viewToDismiss = [contentNavigationController view];
			[viewToDismiss removeFromSuperview];
			UX_SAFE_RELEASE(contentNavigationController);
			[self.superController viewWillAppear:animated];
			[self.superController viewDidAppear:animated];
		}
	}


	#pragma mark KVO

	-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
		NSString *contextName = (NSString *)context;
		
		UXLOG(@"================================================================================");
		UXLOG(@"ZSNavigationController : %@", contextName);
		UXLOG(@"================================================================================");
		UXLOG(@"KeyPath = %@", keyPath);
		UXLOG(@"Object  = %@", object);
		UXLOG(@"KeyPath = %@", keyPath);
		UXLOG(@"Changed = %@", change);
		UXLOG(@"================================================================================");		
		/*
		if ([keyPath isEqual:@""] == TRUE) {
			id oldValue = (id)[change objectForKey:NSKeyValueChangeOldKey];
			id newValue = (id)[change valueForKey:NSKeyValueChangeNewKey];
			if (newValue != [NSNull null]) {
			}
		}
		*/
		UXLOG(@"================================================================================");		
	}


	#pragma mark UIViewController (UXUIViewController)

	-(void) persistNavigationPath:(NSMutableArray *)path {
		if (contentNavigationController) {
			// We have controllers open inside the launcher controller, so persist it
			[contentNavigationController persistNavigationPath:path];
		}
	}


	#pragma mark <UXNavigatorDelegate>

	-(BOOL) navigator:(UXNavigator *)aNavigator shouldOpenURL:(NSURL *)aURL {
		UXLOG(@"UXNavigatorDelegate shouldOpenURL = %@", aURL);
		return TRUE;
	}

	-(void) navigator:(UXNavigator *)aNavigator willOpenURL:(NSURL *)aURL inViewController:(UIViewController *)aController {
		UXLOG(@"UXNavigatorDelegate willOpenURL = %@", aURL);
	}


	#pragma mark <UXAlertViewControllerDelegate>

	-(BOOL) alertViewController:(UXAlertViewController *)controller didDismissWithButtonIndex:(NSInteger)buttonIndex URL:(NSString *)urlString {
		UXLOG(@"%@", urlString);
		return TRUE;
	}


	#pragma mark <UXActionSheetControllerDelegate>

	-(BOOL) actionSheetController:(UXActionSheetController *)controller didDismissWithButtonIndex:(NSInteger)buttonIndex URL:(NSString *)urlString {
		UXLOG(@"%@", urlString);
		return TRUE;
	}


	#pragma mark Destructor

	-(void) dealloc {
		UX_SAFE_RELEASE(activityLabel);
		UX_SAFE_RELEASE(contentOverlayView);
		UX_SAFE_RELEASE(containerView);
		UX_SAFE_RELEASE(contentNavigationController);
		[super dealloc];
	}

@end
