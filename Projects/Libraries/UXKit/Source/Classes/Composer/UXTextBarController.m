
#import <UXKit/UXTextBarController.h>
#import <UXKit/UXButton.h>
#import <UXKit/UXNavigator.h>
#import <UXKit/UXDefaultStyleSheet.h>

static CGFloat kMargin	= 1;
static CGFloat kPadding = 5;

@implementation UXTextBarController

	@synthesize delegate	= _delegate;
	@synthesize textEditor	= _textEditor;
	@synthesize postButton	= _postButton;
	@synthesize footerBar	= _footerBar;

	#pragma mark SPI

	-(void) showActivity:(NSString *)activityText {
	
	}

	-(void) showAnimationDidStop {
	}

	-(void) dismiss {
		//[self dismissPopupViewControllerAnimated:NO];
	}

	-(void) dismissAnimationDidStop {
		//[self release];
	}

	-(void) dismissWithCancel {
		if ([_delegate respondsToSelector:@selector(textBarDidCancel:)]) {
			[_delegate textBarDidCancel:self];
		}
		[self dismissPopupViewControllerAnimated:YES];
	}

	
	#pragma mark NSObject

	-(id) initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
		if (self = [super init]) {
			_delegate		= nil;
			_result			= nil;
			_defaultText	= nil;
			_textEditor		= nil;
			_postButton		= nil;
			_footerBar		= nil;
			_previousRightBarButtonItem = nil;
			
			if (query) {
				_delegate		= [query objectForKey:@"delegate"];
				_defaultText	= [[query objectForKey:@"text"] copy];
			}
		}
		return self;
	}

	-(id) init {
		return [self initWithNavigatorURL:nil query:nil];
	}

	-(void) dealloc {
		_delegate = nil;
		UX_SAFE_RELEASE(_textEditor);
		UX_SAFE_RELEASE(_postButton);
		UX_SAFE_RELEASE(_result);
		UX_SAFE_RELEASE(_defaultText);
		UX_SAFE_RELEASE(_footerBar);
		UX_SAFE_RELEASE(_textBar);
		UX_SAFE_RELEASE(_previousRightBarButtonItem);
		[super dealloc];
	}

	
	#pragma mark UIViewController

	-(void) loadView {
		CGSize screenSize = UXScreenBounds().size;
		
		self.view = [[[UIView alloc] init] autorelease];
		_textBar = [[UXView alloc] init];
		_textBar.style = UXSTYLE(textBar);
		[self.view addSubview:_textBar];
		
		[_textBar addSubview:self.textEditor];
		[_textBar addSubview:self.postButton];
		
		[self.postButton sizeToFit];
		_postButton.frame = CGRectMake(screenSize.width - (_postButton.width + kPadding), kMargin + kPadding, _postButton.width, 0);
		
		_textEditor.frame = CGRectMake(kPadding, kMargin, screenSize.width - (_postButton.width + kPadding * 2), 0);
		[_textEditor sizeToFit];
		_postButton.height = _textEditor.size.height - 8;
		
		_textBar.frame = CGRectMake(0, 0, screenSize.width, _textEditor.height + kMargin * 2);
		
		self.view.frame = CGRectMake(0, screenSize.height - (UXKeyboardHeight() + _textEditor.height), screenSize.width, _textEditor.height + kMargin * 2);
		
		if (_footerBar) {
			_footerBar.frame = CGRectMake(0, _textBar.height, screenSize.width, _footerBar.height);
			[self.view addSubview:_footerBar];
			self.view.top -= _footerBar.height;
			self.view.height += _footerBar.height;
		}
		
		self.view.autoresizingMask		= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
		_postButton.autoresizingMask	= UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
		_textEditor.autoresizingMask	= UIViewAutoresizingFlexibleRightMargin;
		_textBar.autoresizingMask		= UIViewAutoresizingFlexibleWidth;
		_footerBar.autoresizingMask		= UIViewAutoresizingFlexibleWidth;
	}

	-(void) viewDidUnload {
		/*
		UX_SAFE_RELEASE(_textBar);
		UX_SAFE_RELEASE(_textEditor);
		UX_SAFE_RELEASE(_postButton);
		*/
		[super viewDidUnload];
	}


	#pragma mark (UIXViewController)

	-(BOOL) persistView:(NSMutableDictionary *)state {
		[state setObject:[NSNumber numberWithBool:YES] forKey:@"__important__"];
		
		NSString *delegate = [[UXNavigator navigator] pathForObject:_delegate];
		if (delegate) {
			[state setObject:delegate forKey:@"delegate"];
		}
		[state setObject:_textEditor.text forKey:@"text"];
		
		NSString *title = self.navigationItem.title;
		
		if (title) {
			[state setObject:title forKey:@"title"];
		}
		
		return [super persistView:state];
	}

	-(void) restoreView:(NSDictionary *)state {
		[super restoreView:state];
		NSString *delegate = [state objectForKey:@"delegate"];
		if (delegate) {
			_delegate = [[UXNavigator navigator] objectForPath:delegate];
		}
		NSString *title = [state objectForKey:@"title"];
		if (title) {
			self.navigationItem.title = title;
		}
		_defaultText = [[state objectForKey:@"text"] retain];
	}


	#pragma mark UXPopupViewController

	-(void) showInView:(UIView *)view animated:(BOOL)animated {
		UIWindow *window		= view.window ? view.window : [UIApplication sharedApplication].keyWindow;
		self.view.transform		= UXRotateTransformForOrientation(UXInterfaceOrientation());
		[window addSubview:self.view];

		if (_defaultText) {
			_textEditor.text = _defaultText;
			UX_SAFE_RELEASE(_defaultText);
		}
		else {
			_defaultText = [_textEditor.text retain];
		}
		
		self.view.top = self.view.window.height;
		
		/*self.view.bottom = CGRectGetMaxY(view.window.frame);
		[self.view.superview frameWithKeyboardSubtracted:0];*/
		
		[_textEditor becomeFirstResponder];
	}

	-(void) dismissPopupViewControllerAnimated:(BOOL)animated {
		if (animated) {
			[_textEditor resignFirstResponder];
			UIViewController *superController = self.superController;
			[self.view removeFromSuperview];
			superController.popupViewController = nil;
			[superController viewWillAppear:animated];
			[superController viewDidAppear:animated];
			//[self performSelector:@selector(release) withObject:nil afterDelay:UX_TRANSITION_DURATION];
		}
		else {
			[_textEditor resignFirstResponder];
			UIViewController *superController = self.superController;
			[self.view removeFromSuperview];
			[self release];
			superController.popupViewController = nil;
			[superController viewWillAppear:animated];
			[superController viewDidAppear:animated];
		}
	}

	
	#pragma mark UXTextEditorDelegate

	-(void) textEditorDidBeginEditing:(UXTextEditor *)textEditor {
		[self retain];
		_originTop = self.view.top;
		
		UIViewController *controller	= self.view.viewController;
		_previousRightBarButtonItem		= [controller.navigationItem.rightBarButtonItem retain];
		[controller.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)] autorelease] animated:YES];
		
		[UIView beginAnimations:nil context:nil];
		{
			[UIView setAnimationDuration:UX_TRANSITION_DURATION];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(showAnimationDidStop)];
			//CGRect navFrame		= UXNavigationFrame();
			self.view.bottom = CGRectGetMaxY(self.view.window.frame) - UXKeyboardHeight();
		}
		[UIView commitAnimations];
		
		UXLOG(@"TEXT BAR VIEW FRAME = %@", NSStringFromCGRect(self.view.frame));
		
		if ([_delegate respondsToSelector:@selector(textBarDidBeginEditing:)]) {
			[_delegate textBarDidBeginEditing:self];
		}
	}

	-(void) textEditorDidEndEditing:(UXTextEditor *)textEditor {
		UIViewController *controller = self.view.viewController;
		[controller.navigationItem setRightBarButtonItem:_previousRightBarButtonItem animated:YES];
		UX_SAFE_RELEASE(_previousRightBarButtonItem);
		
		[UIView beginAnimations:nil context:nil];
		{
			[UIView setAnimationDuration:UX_TRANSITION_DURATION];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(dismissAnimationDidStop)];
			self.view.top = _originTop;
		}
		[UIView commitAnimations];
		
		if ([_delegate respondsToSelector:@selector(textBarDidEndEditing:)]) {
			[_delegate textBarDidEndEditing:self];
		}
	}

	-(void) textEditorDidChange:(UXTextEditor *)textEditor {
		[_postButton setEnabled:textEditor.text.length > 0];
	}

	-(BOOL) textEditor:(UXTextEditor *)textEditor shouldResizeBy:(CGFloat)height {
		CGRect frame		= self.view.frame;
		frame.origin.y		-= height;
		frame.size.height	+= height;
		_textBar.height		+= height;
		_footerBar.top		+= height;
		self.view.frame		= frame;
		return YES;
	}


	#pragma mark UIAlertViewDelegate

	-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
		if (buttonIndex == 0) {
			[self dismissWithCancel];
		}
	}


	#pragma mark API

	-(UXTextEditor *) textEditor {
		if (!_textEditor) {
			_textEditor = [[UXTextEditor alloc] init];
			_textEditor.delegate = self;
			_textEditor.style = UXSTYLE(textBarTextField);
			_textEditor.backgroundColor = [UIColor clearColor];
			_textEditor.autoresizesToText = YES;
			_textEditor.maxNumberOfLines = 6;
			_textEditor.font = [UIFont systemFontOfSize:16];
		}
		return _textEditor;
	}

	-(UXButton *) postButton {
		if (!_postButton) {
			_postButton = [[UXButton buttonWithStyle:@"textBarPostButton:"
											   title:NSLocalizedString(@"Post", @"")] retain];
			[_postButton addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
			[_postButton setEnabled:NO];
		}
		return _postButton;
	}

	-(void) post {
		BOOL shouldDismiss = [self willPostText:_textEditor.text];
		if ([_delegate respondsToSelector:@selector(textBar:willPostText:)]) {
			shouldDismiss = [_delegate textBar:self willPostText:_textEditor.text];
		}
		
		_textEditor.text	= @"";
		_postButton.enabled = NO;
		
		if (shouldDismiss) {
			[self dismissWithResult:nil animated:YES];
		}
		else {
			[self showActivity:[self titleForActivity]];
		}
	}

	-(void) cancel {
		if (!_textEditor.text.isEmptyOrWhitespace
			&& !(_defaultText && [_defaultText isEqualToString:_textEditor.text])) {
			UIAlertView *cancelAlertView = [[[UIAlertView alloc] initWithTitle:UXLocalizedString(@"Cancel", @"")
																	   message:UXLocalizedString(@"Are you sure you want to cancel?", @"")
																	  delegate:self cancelButtonTitle:UXLocalizedString(@"Yes", @"")
															 otherButtonTitles:UXLocalizedString(@"No", @""), nil] autorelease];
			[cancelAlertView show];
		}
		else {
			[self dismissWithCancel];
		}
	}

	-(void) dismissWithResult:(id)result animated:(BOOL)animated {
		[_result release];
		_result = [result retain];
		
		[self dismissPopupViewControllerAnimated:YES];
		//[self dismiss];
		//  [self hideKeyboard];
	}

	-(void) failWithError:(NSError *)error {
		[self showActivity:nil];
		
		NSString *title = [self titleForError:error];
		if (title.length) {
			UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:UXLocalizedString(@"Error", @"")
																 message:title delegate:nil cancelButtonTitle:UXLocalizedString(@"Ok", @"")
													   otherButtonTitles:nil] autorelease];
			[alertView show];
		}
	}

	-(BOOL) willPostText:(NSString *)text {
		return YES;
	}

	-(NSString *) titleForActivity {
		return nil;
	}

	-(NSString *) titleForError:(NSError *)error {
		return nil;
	}

@end
