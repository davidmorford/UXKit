
#import <UXKit/UXActionSheetController.h>
#import <UXKit/UXNavigator.h>

@interface UXActionSheet : UIActionSheet {
	UIViewController *_popupViewController;
}

	@property (nonatomic, retain) UIViewController *popupViewController;

@end

@implementation UXActionSheet

	@synthesize popupViewController = _popupViewController;

	-(id) initWithFrame:(CGRect)frame {
		if (self = [super initWithFrame:frame]) {
			_popupViewController = nil;
		}
		return self;
	}

	-(void) didMoveToSuperview {
		if (!self.superview) {
			[_popupViewController autorelease];
			_popupViewController = nil;
		}
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_popupViewController);
		[super dealloc];
	}

@end

#pragma mark -

@implementation UXActionSheetController

	@synthesize delegate = _delegate;
	@synthesize userInfo = _userInfo;


	#pragma mark Initializer

	-(id) initWithTitle:(NSString *)title {
		return [self initWithTitle:title delegate:nil];
	}

	-(id) initWithTitle:(NSString *)aTitle delegate:(id)aDelegate {
		if (self = [super init]) {
			_delegate	= aDelegate;
			_userInfo	= nil;
			_URLs		= [[NSMutableArray alloc] init];
			if (aTitle) {
				self.actionSheet.title = aTitle;
			}
		}
		return self;
	}


	#pragma mark <NSObject>

	-(id) init {
		return [self initWithTitle:nil delegate:nil];
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_URLs);
		UX_SAFE_RELEASE(_userInfo);
		[super dealloc];
	}


	#pragma mark @UIViewController

	-(void) loadView {
		UXActionSheet *actionSheet = [[[UXActionSheet alloc] initWithTitle:nil 
																	  delegate:self
															 cancelButtonTitle:nil
														destructiveButtonTitle:nil
															 otherButtonTitles:nil] autorelease];
		actionSheet.popupViewController = self;
		self.view = actionSheet;
	}


	#pragma mark (UIXViewController)

	-(BOOL) persistView:(NSMutableDictionary *)state {
		return NO;
	}


	#pragma mark @UXPopupViewController

	-(void) showInView:(UIView *)aView animated:(BOOL)animated {
		[self viewWillAppear:animated];
		[self.actionSheet showInView:aView.window];
		[self viewDidAppear:animated];
	}


	#pragma mark @UXPopupViewController

	-(void) showInViewController:(UIViewController *)aParentViewController animated:(BOOL)animated {
		[self viewWillAppear:animated];
		[self.actionSheet showInView:aParentViewController.view];
		[self viewDidAppear:animated];
	}

	-(void) dismissPopupViewControllerAnimated:(BOOL)animated {
		[self viewWillDisappear:animated];
		[self.actionSheet dismissWithClickedButtonIndex:self.actionSheet.cancelButtonIndex animated:animated];
		[self viewDidDisappear:animated];
	}


	#pragma mark <UIActionSheetDelegate>

	-(void) actionSheet:(UIActionSheet *)anActionSheet clickedButtonAtIndex:(NSInteger)aButtonIndex {
		if ([_delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
			[_delegate actionSheet:anActionSheet clickedButtonAtIndex:aButtonIndex];
		}
	}

	-(void) actionSheetCancel:(UIActionSheet *)anActionSheet {
		if ([_delegate respondsToSelector:@selector(actionSheetCancel:)]) {
			[_delegate actionSheetCancel:anActionSheet];
		}
	}

	-(void) willPresentActionSheet:(UIActionSheet *)anActionSheet {
		if ([_delegate respondsToSelector:@selector(willPresentActionSheet:)]) {
			[_delegate willPresentActionSheet:anActionSheet];
		}
	}

	-(void) didPresentActionSheet:(UIActionSheet *)anActionSheet {
		if ([_delegate respondsToSelector:@selector(didPresentActionSheet:)]) {
			[_delegate didPresentActionSheet:anActionSheet];
		}
	}

	-(void) actionSheet:(UIActionSheet *)aActionSheet willDismissWithButtonIndex:(NSInteger)aButtonIndex {
		if ([_delegate respondsToSelector:@selector(actionSheet:willDismissWithButtonIndex:)]) {
			[_delegate actionSheet:aActionSheet willDismissWithButtonIndex:aButtonIndex];
		}
	}

	-(void) actionSheet:(UIActionSheet *)anActionSheet didDismissWithButtonIndex:(NSInteger)aButtonIndex {
		NSString *URL	= [self buttonURLAtIndex:aButtonIndex];
		BOOL canOpenURL = YES;
		
		if ([_delegate respondsToSelector:@selector(actionSheetController:didDismissWithButtonIndex:URL:)]) {
			canOpenURL	= [_delegate actionSheetController:self didDismissWithButtonIndex:aButtonIndex URL:URL];
		}
		
		if (URL && canOpenURL) {
			UXOpenURL(URL);
		}
		
		if ([_delegate respondsToSelector:@selector(actionSheet:didDismissWithButtonIndex:)]) {
			[_delegate actionSheet:anActionSheet didDismissWithButtonIndex:aButtonIndex];
		}
	}


	#pragma mark API

	-(UIActionSheet *) actionSheet {
		return (UIActionSheet *)self.view;
	}

	-(NSInteger) addButtonWithTitle:(NSString *)title URL:(NSString *)URL {
		if (URL) {
			[_URLs addObject:URL];
		}
		else {
			[_URLs addObject:[NSNull null]];
		}
		return [self.actionSheet addButtonWithTitle:title];
	}

	-(NSInteger) addCancelButtonWithTitle:(NSString *)title URL:(NSString *)URL {
		self.actionSheet.cancelButtonIndex = [self addButtonWithTitle:title URL:URL];
		return self.actionSheet.cancelButtonIndex;
	}

	-(NSInteger) addDestructiveButtonWithTitle:(NSString *)title URL:(NSString *)URL {
		self.actionSheet.destructiveButtonIndex = [self addButtonWithTitle:title URL:URL];
		return self.actionSheet.destructiveButtonIndex;
	}

	-(NSString *) buttonURLAtIndex:(NSInteger)anIndex {
		if (anIndex < _URLs.count) {
			id URL = [_URLs objectAtIndex:anIndex];
			return URL != [NSNull null] ? URL : nil;
		}
		else {
			return nil;
		}
	}

@end
