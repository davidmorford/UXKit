
#import <UXKit/UXViewController.h>
#import <UXKit/UXTableViewController.h>
#import <UXKit/UXURLRequestQueue.h>
#import <UXKit/UXSearchDisplayController.h>
#import <UXKit/UXStyleSheet.h>
#import <UXKit/UXNavigator.h>

@implementation UXViewController

	@synthesize navigationBarStyle		= _navigationBarStyle;
	@synthesize navigationBarTintColor	= _navigationBarTintColor;
	@synthesize statusBarStyle			= _statusBarStyle;
	@synthesize isViewAppearing			= _isViewAppearing;
	@synthesize hasViewAppeared			= _hasViewAppeared;
	@synthesize autoresizesForKeyboard	= _autoresizesForKeyboard;

	#pragma mark SPI

	-(void) resizeForKeyboard:(NSNotification *)notification appearing:(BOOL)appearing {
		NSValue *v1 = [notification.userInfo objectForKey:UIKeyboardBoundsUserInfoKey];
		CGRect keyboardBounds;
		[v1 getValue:&keyboardBounds];
		
		NSValue *v2 = [notification.userInfo objectForKey:UIKeyboardCenterBeginUserInfoKey];
		CGPoint keyboardStart;
		[v2 getValue:&keyboardStart];
		
		NSValue *v3 = [notification.userInfo objectForKey:UIKeyboardCenterEndUserInfoKey];
		CGPoint keyboardEnd;
		[v3 getValue:&keyboardEnd];
		
		BOOL animated = keyboardStart.y != keyboardEnd.y;
		if (animated) {
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:UX_TRANSITION_DURATION];
		}
		
		if (appearing) {
			[self keyboardWillAppear:animated withBounds:keyboardBounds];
			
			[self retain];
			[NSTimer scheduledTimerWithTimeInterval:UX_TRANSITION_DURATION
											 target:self 
										   selector:@selector(keyboardDidAppearDelayed:)
										   userInfo:[NSValue valueWithCGRect:keyboardBounds] 
											repeats:NO];
		}
		else {
			[self keyboardWillDisappear:animated withBounds:keyboardBounds];
			
			[self retain];
			[NSTimer scheduledTimerWithTimeInterval:UX_TRANSITION_DURATION
											 target:self 
										   selector:@selector(keyboardDidDisappearDelayed:)
										   userInfo:[NSValue valueWithCGRect:keyboardBounds] 
											repeats:NO];
		}
		
		if (animated) {
			[UIView commitAnimations];
		}
	}

	-(void) keyboardDidAppearDelayed:(NSTimer *)timer {
		NSValue *value = timer.userInfo;
		CGRect keyboardBounds;
		[value getValue:&keyboardBounds];
		
		[self keyboardDidAppear:YES withBounds:keyboardBounds];
		[self autorelease];
	}

	-(void) keyboardDidDisappearDelayed:(NSTimer *)timer {
		NSValue *value = timer.userInfo;
		CGRect keyboardBounds;
		[value getValue:&keyboardBounds];
		
		[self keyboardDidDisappear:YES withBounds:keyboardBounds];
		[self autorelease];
	}


	#pragma mark <NSObject>

	-(id) init {
		if (self = [super init]) {
			_frozenState				= nil;
			_navigationBarStyle			= UIBarStyleDefault;
			_navigationBarTintColor		= nil;
			_statusBarStyle				= UIStatusBarStyleDefault;
			_hasViewAppeared			= NO;
			_isViewAppearing			= NO;
			_autoresizesForKeyboard		= NO;
			self.navigationBarTintColor = UXSTYLEVAR(navigationBarTintColor);
		}
		return self;
	}

	-(void) awakeFromNib {
		[self init];
	}

	-(void) dealloc {
		UXLOG(@"DEALLOC %@", self);
		
		[[UXURLRequestQueue mainQueue] cancelRequestsWithDelegate:self];
		
		UX_SAFE_RELEASE(_navigationBarTintColor);
		UX_SAFE_RELEASE(_frozenState);
		
		// Removes keyboard notification observers for
		self.autoresizesForKeyboard = NO;
		
		// You would think UIViewController would call this in dealloc, but it doesn't!
		// I would prefer not to have to redundantly put all view releases in dealloc and
		// viewDidUnload, so my solution is just to call viewDidUnload here.
		// DPM - This is WRONG! According to Apple and myself. DO NOT DO THIS!
		//[self viewDidUnload];
		UX_SAFE_RELEASE(_searchController);
		
		[super dealloc];
	}


	#pragma mark @UIResponder

	-(void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
		if ((event.type == UIEventSubtypeMotionShake) && [UXNavigator navigator].supportsShakeToReload) {
			[[UXNavigator navigator] reload];
		}
	}


	#pragma mark @UIViewController

	-(void) loadView {
		[super loadView];
		CGRect frame					= self.wantsFullScreenLayout ? UXScreenBounds() : UXNavigationFrame();
		self.view						= [[[UIView alloc] initWithFrame:frame] autorelease];
		self.view.autoresizesSubviews	= YES;
		self.view.autoresizingMask		= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.view.backgroundColor		= UXSTYLEVAR(backgroundColor);
	}

	-(void) viewDidUnload {
		[super viewDidUnload];
		UX_SAFE_RELEASE(_searchController);
	}

	-(void) viewWillAppear:(BOOL)animated {
		[super viewWillAppear:animated];

		_isViewAppearing = YES;
		_hasViewAppeared = YES;
		
		[UXURLRequestQueue mainQueue].suspended = YES;
		
		if (!self.popupViewController) {
			UINavigationBar *bar	= self.navigationController.navigationBar;
			bar.tintColor			= _navigationBarTintColor;
			bar.barStyle			= _navigationBarStyle;
			[[UIApplication sharedApplication] setStatusBarStyle:_statusBarStyle animated:YES];
		}
		
		// Ugly hack to work around UISearchBar's inability to resize its text field
		// to avoid being overlapped by the table section index
		//  if (_searchController && !_searchController.active) {
		//    [_searchController setActive:YES animated:NO];
		//    [_searchController setActive:NO animated:NO];
		//  }
	}

	-(void) viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];
		[UXURLRequestQueue mainQueue].suspended = NO;
	}

	-(void) viewWillDisappear:(BOOL)animated {
		[super viewWillDisappear:animated];
		_isViewAppearing = NO;
	}

	-(void) didReceiveMemoryWarning {
		UXLOG(@"MEMORY WARNING FOR %@", self);
		if (_hasViewAppeared && !_isViewAppearing) {
			NSMutableDictionary *state = [[[NSMutableDictionary alloc] init] autorelease]; // ???:
			[self persistView:state];
			self.frozenState = state;
			
			// This will come around to calling viewDidUnload
			[super didReceiveMemoryWarning];
			
			_hasViewAppeared = NO;
		}
		else {
			[super didReceiveMemoryWarning];
		}		
	}

	-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
		UIViewController *popup = [self popupViewController];
		if (popup) {
			return [popup shouldAutorotateToInterfaceOrientation:interfaceOrientation];
		}
		else {
			return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
		}
	}

	-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {
		UIViewController *popup = [self popupViewController];
		if (popup) {
			return [popup willAnimateRotationToInterfaceOrientation:fromInterfaceOrientation
														   duration:duration];
		}
		else {
			return [super willAnimateRotationToInterfaceOrientation:fromInterfaceOrientation
														   duration:duration];
		}
	}

	-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
		UIViewController *popup = [self popupViewController];
		if (popup) {
			return [popup didRotateFromInterfaceOrientation:fromInterfaceOrientation];
		}
		else {
			return [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
		}
	}

	-(UIView *) rotatingHeaderView {
		UIViewController *popup = [self popupViewController];
		if (popup) {
			return [popup rotatingHeaderView];
		}
		else {
			return [super rotatingHeaderView];
		}
	}

	-(UIView *) rotatingFooterView {
		UIViewController *popup = [self popupViewController];
		if (popup) {
			return [popup rotatingFooterView];
		}
		else {
			return [super rotatingFooterView];
		}
	}


	#pragma mark (UIXViewController)

	-(NSDictionary *) frozenState {
		return _frozenState;
	}

	-(void) setFrozenState:(NSDictionary *)frozenState {
		[_frozenState release];
		_frozenState = [frozenState retain];
	}


	#pragma mark [UIKeyboardNotifications]

	-(void) keyboardWillShow:(NSNotification *)notification {
		if (self.isViewAppearing) {
			[self resizeForKeyboard:notification appearing:YES];
		}
	}

	-(void) keyboardWillHide:(NSNotification *)notification {
		if (self.isViewAppearing) {
			[self resizeForKeyboard:notification appearing:NO];
		}
	}


	#pragma mark API

	-(UXTableViewController *) searchViewController {
		return _searchController.searchResultsViewController;
	}

	-(void) setSearchViewController:(UXTableViewController *)searchViewController {
		if (searchViewController) {
			if (!_searchController) {
				UISearchBar *searchBar	= [[[UISearchBar alloc] init] autorelease];
				[searchBar sizeToFit];
				_searchController		= [[UXSearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
			}
			searchViewController.superController		  = self;
			_searchController.searchResultsViewController = searchViewController;
		}
		else {
			_searchController.searchResultsViewController = nil;
			UX_SAFE_RELEASE(_searchController);
		}
	}

	-(void) setAutoresizesForKeyboard:(BOOL)autoresizesForKeyboard {
		if (autoresizesForKeyboard != _autoresizesForKeyboard) {
			_autoresizesForKeyboard = autoresizesForKeyboard;
			
			if (_autoresizesForKeyboard) {
				[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
				[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];
			}
			else {
				[[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIKeyboardWillShowNotification" object:nil];
				[[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIKeyboardWillHideNotification" object:nil];
			}
		}
	}

	-(void) keyboardWillAppear:(BOOL)animated withBounds:(CGRect)bounds {
	
	}

	-(void) keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds {
	
	}

	-(void) keyboardDidAppear:(BOOL)animated withBounds:(CGRect)bounds {
	
	}

	-(void) keyboardDidDisappear:(BOOL)animated withBounds:(CGRect)bounds {
	
	}

@end
