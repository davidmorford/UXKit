
#import <UXKit/UXAlertViewController.h>
#import <UXKit/UXNavigator.h>

@interface UXAlertView : UIAlertView {
	UIViewController *_popupViewController;
}

	@property (nonatomic, retain) UIViewController *popupViewController;

@end

@implementation UXAlertView

	@synthesize popupViewController = _popupViewController;

	-(id) initWithFrame:(CGRect)frame {
		if (self = [super initWithFrame:frame]) {
			_popupViewController = nil;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_popupViewController);
		[super dealloc];
	}

	-(void) didMoveToSuperview {
		if (!self.superview) {
			[_popupViewController autorelease];
			_popupViewController = nil;
		}
	}

@end

#pragma mark -

@implementation UXAlertViewController

	@synthesize delegate = _delegate;
	@synthesize userInfo = _userInfo;

	#pragma mark Initializers

	-(id) initWithTitle:(NSString *)aTitle message:(NSString *)aMessage delegate:(id)aDelegate {
		if (self = [super init]) {
			_delegate				= aDelegate;
			_userInfo				= nil;
			_URLs					= [[NSMutableArray alloc] init];
			if (aTitle) {
				self.alertView.title	= aTitle;
			}
			if (aMessage) {
				self.alertView.message	= aMessage;
			}
		}
		return self;
	}

	-(id) initWithTitle:(NSString *)aTitle message:(NSString *)aMessage {
		return [self initWithTitle:aTitle message:aMessage delegate:nil];
	}


	#pragma mark <NSObject>

	-(id) init {
		return [self initWithTitle:nil message:nil delegate:nil];
	}

	-(void) dealloc {
		[(UIAlertView *)self.view setDelegate:nil];
		UX_SAFE_RELEASE(_URLs);
		UX_SAFE_RELEASE(_userInfo);
		[super dealloc];
	}


	#pragma mark @UIViewController

	-(void) loadView {
		UXAlertView *alertView = [[[UXAlertView alloc] initWithTitle:nil 
																 message:nil 
																delegate:self
													   cancelButtonTitle:nil
													   otherButtonTitles:nil] autorelease];
		alertView.popupViewController = self;
		self.view = alertView;
	}


	#pragma mark (UIXViewController)

	-(BOOL) persistView:(NSMutableDictionary *)state {
		return NO;
	}


	#pragma mark @UXPopupViewController

	-(void) showInView:(UIView *)aView animated:(BOOL)animated {
		[self viewWillAppear:animated];
		[self.alertView show];
		[self viewDidAppear:animated];
	}

	-(void) dismissPopupViewControllerAnimated:(BOOL)animated {
		[self viewWillDisappear:animated];
		[self.alertView dismissWithClickedButtonIndex:self.alertView.cancelButtonIndex animated:animated];
		[self viewDidDisappear:animated];
	}


	#pragma mark <UIAlertViewDelegate>

	-(void) alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)aButtonIndex {
		if ([_delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
			[_delegate alertView:anAlertView clickedButtonAtIndex:aButtonIndex];
		}
	}

	-(void) alertViewCancel:(UIAlertView *)anAlertView {
		if ([_delegate respondsToSelector:@selector(alertViewCancel:)]) {
			[_delegate alertViewCancel:anAlertView];
		}
	}

	-(void) willPresentAlertView:(UIAlertView *)anAlertView {
		if ([_delegate respondsToSelector:@selector(willPresentAlertView:)]) {
			[_delegate willPresentAlertView:anAlertView];
		}
	}

	-(void) didPresentAlertView:(UIAlertView *)anAlertView {
		if ([_delegate respondsToSelector:@selector(didPresentAlertView:)]) {
			[_delegate didPresentAlertView:anAlertView];
		}
	}

	-(void) alertView:(UIAlertView *)anAlertView willDismissWithButtonIndex:(NSInteger)aButtonIndex {
		if ([_delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)]) {
			[_delegate alertView:anAlertView willDismissWithButtonIndex:aButtonIndex];
		}
	}

	-(void) alertView:(UIAlertView *)anAlertView didDismissWithButtonIndex:(NSInteger)aButtonIndex {
		NSString *URL	= [self buttonURLAtIndex:aButtonIndex];
		BOOL canOpenURL = YES;
		if ([_delegate respondsToSelector:@selector(alertViewController:didDismissWithButtonIndex:URL:)]) {
			canOpenURL	= [_delegate alertViewController:self didDismissWithButtonIndex:aButtonIndex URL:URL];
		}
		if (URL && canOpenURL) {
			UXOpenURL(URL);
		}
		if ([_delegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)]) {
			[_delegate alertView:anAlertView didDismissWithButtonIndex:aButtonIndex];
		}
	}


	#pragma mark API

	-(UIAlertView *) alertView {
		return (UIAlertView *)self.view;
	}

	-(NSInteger) addButtonWithTitle:(NSString *)aTitle URL:(NSString *)aURL {
		if (aURL) {
			[_URLs addObject:aURL];
		}
		else {
			[_URLs addObject:[NSNull null]];
		}
		return [self.alertView addButtonWithTitle:aTitle];
	}

	-(NSInteger) addCancelButtonWithTitle:(NSString *)aTitle URL:(NSString *)aURL {
		self.alertView.cancelButtonIndex = [self addButtonWithTitle:aTitle URL:aURL];
		return self.alertView.cancelButtonIndex;
	}

	-(NSString *) buttonURLAtIndex:(NSInteger)anIndex {
		id URL = [_URLs objectAtIndex:anIndex];
		return URL != [NSNull null] ? URL : nil;
	}

@end
