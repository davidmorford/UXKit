
#import <UXKit/UXWebController.h>
#import <UXKit/UXDefaultStyleSheet.h>
#import <UXKit/UXURLCache.h>
#import <UXKit/UXNavigator.h>
#import <UXKit/UXURLMap.h>

@implementation UXWebController

	@synthesize delegate	= _delegate;
	@synthesize headerView	= _headerView;
	@synthesize webView		= _webView;
	@synthesize toolbar		= _toolbar;

	#pragma mark Actions

	-(void) backAction {
		[_webView goBack];
	}

	-(void) forwardAction {
		[_webView goForward];
	}

	-(void) refreshAction {
		[_webView reload];
	}

	-(void) stopAction {
		[_webView stopLoading];
	}

	-(void) shareAction {
		UIActionSheet *sheet = [[[UIActionSheet alloc] initWithTitle:@"" 
															delegate:self
												   cancelButtonTitle:UXLocalizedString(@"Cancel", @"") 
											  destructiveButtonTitle:nil
												   otherButtonTitles:UXLocalizedString(@"Open in Safari", @""), nil] autorelease];
		[sheet showInView:self.view];
	}

	-(void) updateToolbarWithOrientation:(UIInterfaceOrientation)interfaceOrientation {
		_toolbar.height = UXToolbarHeight();
		_webView.height = self.view.height - _toolbar.height;
		_toolbar.top	= self.view.height - _toolbar.height;
	}


	#pragma mark Initializers

	-(id) initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
		if (self = [self init]) {
			NSURLRequest *request = [query objectForKey:@"request"];
			if (request) {
				[self openRequest:request];
			}
			else {
				[self openURL:URL];
			}
		}
		return self;
	}

	-(id) initWithURL:(NSURL *)URL query:(NSDictionary *)query {
		if (self = [self init]) {
			NSURLRequest *request = [query objectForKey:@"request"];
			if (request) {
				[self openRequest:request];
			}
			else {
				[self openURL:URL];
			}
		}
		return self;
	}


	#pragma mark <NSObject>

	-(id) init {
		if (self = [super init]) {
			_delegate		= nil;
			_loadingURL		= nil;
			_webView		= nil;
			_toolbar		= nil;
			_headerView		= nil;
			_backButton		= nil;
			_forwardButton	= nil;
			_stopButton		= nil;
			_refreshButton	= nil;
			self.hidesBottomBarWhenPushed	= YES;
		}
		return self;
	}

	-(void) dealloc {
		_webView.delegate = nil;
		UX_SAFE_RELEASE(_webView);
		UX_SAFE_RELEASE(_toolbar);
		UX_SAFE_RELEASE(_backButton);
		UX_SAFE_RELEASE(_forwardButton);
		UX_SAFE_RELEASE(_refreshButton);
		UX_SAFE_RELEASE(_stopButton);
		UX_SAFE_RELEASE(_activityItem);
		UX_SAFE_RELEASE(_loadingURL);
		UX_SAFE_RELEASE(_headerView);
		[super dealloc];
	}


	#pragma mark @UIViewController

	-(void) loadView {
		[super loadView];
		_webView					= [[UIWebView alloc] initWithFrame:UXToolbarNavigationFrame()];
		_webView.delegate			= self;
		_webView.autoresizingMask	= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_webView.scalesPageToFit	= YES;
		[self.view addSubview:_webView];
		
		UIActivityIndicatorView *spinner	= [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
		[spinner startAnimating];
		_activityItem					= [[UIBarButtonItem alloc] initWithCustomView:spinner];
		
		_backButton						= [[UIBarButtonItem alloc] initWithImage:UXIMAGE(@"bundle://UXKit.bundle/Images/Navigation/backIcon.png") style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
		_backButton.tag					= 2;
		_backButton.enabled				= NO;
		_forwardButton					= [[UIBarButtonItem alloc] initWithImage:UXIMAGE(@"bundle://UXKit.bundle/Images/Navigation/forwardIcon.png") style:UIBarButtonItemStylePlain target:self action:@selector(forwardAction)];
		_forwardButton.tag				= 1;
		_forwardButton.enabled			= NO;
		_refreshButton					= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshAction)];
		_refreshButton.tag				= 3;
		_stopButton						= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopAction)];
		_stopButton.tag					= 3;
		
		UIBarButtonItem *actionButton	= [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAction target:self action:@selector(shareAction)] autorelease];
		UIBarItem *space				= [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
		
		_toolbar						= [[UIToolbar alloc] initWithFrame: CGRectMake(0, self.view.height - UXToolbarHeight(), self.view.width, UXToolbarHeight())];
		_toolbar.autoresizingMask		= UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
		_toolbar.tintColor				= UXSTYLESHEETPROPERTY(navigationBarTintColor);
		_toolbar.items					= [NSArray arrayWithObjects: _backButton, space, _forwardButton, space, _refreshButton, space, actionButton, nil];
		
		[self.view addSubview:_toolbar];
	}

	-(void) viewDidUnload {
		[super viewDidUnload];
		_webView.delegate = nil;
		UX_SAFE_RELEASE(_webView);
		UX_SAFE_RELEASE(_toolbar);
		UX_SAFE_RELEASE(_backButton);
		UX_SAFE_RELEASE(_forwardButton);
		UX_SAFE_RELEASE(_refreshButton);
		UX_SAFE_RELEASE(_stopButton);
		UX_SAFE_RELEASE(_activityItem);
	}

	-(void) viewWillAppear:(BOOL)animated {
		[super viewWillAppear:animated];
		[self updateToolbarWithOrientation:self.interfaceOrientation];
	}

	-(void) viewWillDisappear:(BOOL)animated {
		// If the browser launched the media player, it steals the key window and 
		// never gives it back, so this is a way to try and fix that
		[self.view.window makeKeyWindow];
		[super viewWillDisappear:animated];
	}

	-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
		return UXIsSupportedOrientation(interfaceOrientation);
	}

	-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
		[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
		[self updateToolbarWithOrientation:toInterfaceOrientation];
	}

	-(UIView *) rotatingFooterView {
		return _toolbar;
	}


	#pragma mark (UIXViewController)

	-(BOOL) persistView:(NSMutableDictionary *)state {
		NSString *URLString = self.URL.absoluteString;
		if (URLString.length) {
			[state setObject:URLString forKey:@"URL"];
			return YES;
		}
		else {
			return NO;
		}
		//return [super persistView:state];
	}

	-(void) restoreView:(NSDictionary *)state {
		NSString *URL = [state objectForKey:@"URL"];
		if (URL.length && ![URL isEqualToString:@"about:blank"]) {
			[self openURL:[NSURL URLWithString:URL]];
		}
	}


	#pragma mark <UIWebViewDelegate>

	-(BOOL) webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
		if ([[UXNavigator navigator].URLMap isAppURL:request.URL]) {
			[_loadingURL release];
			_loadingURL = [[NSURL URLWithString:@"about:blank"] retain];
			[[UIApplication sharedApplication] openURL:request.URL];
			return FALSE;
		}
		
		[_loadingURL release];
		_loadingURL				= [request.URL retain];
		_backButton.enabled		= [_webView canGoBack];
		_forwardButton.enabled	= [_webView canGoForward];
		return YES;
	}

	-(void) webViewDidStartLoad:(UIWebView *)aWebView {
		self.title = UXLocalizedString(@"Loading...", @"");
		if (!self.navigationItem.rightBarButtonItem) {
			[self.navigationItem setRightBarButtonItem:_activityItem animated:YES];
		}
		[_toolbar replaceItemWithTag:3 withItem:_stopButton];
		_backButton.enabled		= [_webView canGoBack];
		_forwardButton.enabled	= [_webView canGoForward];
	}

	-(void) webViewDidFinishLoad:(UIWebView *)aWebView {
		UX_SAFE_RELEASE(_loadingURL);
		self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
		if (self.navigationItem.rightBarButtonItem == _activityItem) {
			[self.navigationItem setRightBarButtonItem:nil animated:YES];
		}
		[_toolbar replaceItemWithTag:3 withItem:_refreshButton];
		
		_backButton.enabled		= [_webView canGoBack];
		_forwardButton.enabled	= [_webView canGoForward];
	}

	-(void) webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error {
		UX_SAFE_RELEASE(_loadingURL);
		[self webViewDidFinishLoad:aWebView];
	}


	#pragma mark <UIActionSheetDelegate>

	-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
		if (buttonIndex == 0) {
			[[UIApplication sharedApplication] openURL:self.URL];
		}
	}


	#pragma mark API

	-(NSURL *) URL {
		return _loadingURL ? _loadingURL : _webView.request.URL;
	}

	-(void) openRequest:(NSURLRequest *)request {
		self.view;
		[_webView loadRequest:request];
	}

	-(void) setHeaderView:(UIView *)aHeaderView {
		if (aHeaderView != _headerView) {
			BOOL addingHeader	= !_headerView && aHeaderView;
			BOOL removingHeader = _headerView && !aHeaderView;
			
			[_headerView removeFromSuperview];
			[_headerView release];
			_headerView			= [aHeaderView retain];
			_headerView.frame	= CGRectMake(0, 0, _webView.width, _headerView.height);
			
			self.view;
			UIView *scroller	= [_webView descendantOrSelfWithClass:NSClassFromString(@"UIScroller")];
			UIView *docView		= [scroller descendantOrSelfWithClass:NSClassFromString(@"UIWebDocumentView")];
			[scroller addSubview:_headerView];
			
			if (addingHeader) {
				docView.top += aHeaderView.height;
				docView.height -= aHeaderView.height;
			}
			else if (removingHeader) {
				docView.top -= aHeaderView.height;
				docView.height += aHeaderView.height;
			}
		}
	}

	-(void) openURL:(NSURL *)URL {
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
		[self openRequest:request];
	}

@end
