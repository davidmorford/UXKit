
#import <UXKit/UXGlobal.h>
#import <UXKit/UXNavigator.h>
#import <objc/runtime.h>

static NSInteger gNetworkTaskCount = 0;

#pragma mark -

NSString * const UXKitErrorDomain = @"uxkit";
NSUInteger const UXKitInvalidImageErrorCode	= 101;


#pragma mark Collections

static const void * 
UXRetainNoOp(CFAllocatorRef allocator, const void *value) {
	return value;
}

static void 
UXReleaseNoOp(CFAllocatorRef allocator, const void *value) {
}

NSMutableArray * 
UXCreateNonRetainingArray() {
	CFArrayCallBacks callbacks = kCFTypeArrayCallBacks;
	callbacks.retain	= UXRetainNoOp;
	callbacks.release	= UXReleaseNoOp;
	return (NSMutableArray *)CFArrayCreateMutable(nil, 0, &callbacks);
}

NSMutableDictionary * 
UXCreateNonRetainingDictionary() {
	CFDictionaryKeyCallBacks keyCallbacks	= kCFTypeDictionaryKeyCallBacks;
	CFDictionaryValueCallBacks callbacks	= kCFTypeDictionaryValueCallBacks;
	callbacks.retain	= UXRetainNoOp;
	callbacks.release	= UXReleaseNoOp;
	return (NSMutableDictionary *)CFDictionaryCreateMutable(nil, 0, &keyCallbacks, &callbacks);
}

BOOL 
UXIsEmptyArray(id object) {
	return [object isKindOfClass:[NSArray class]] && ![(NSArray *) object count];
}

BOOL 
UXIsEmptySet(id object) {
	return [object isKindOfClass:[NSSet class]] && ![(NSSet *) object count];
}

BOOL 
UXIsEmptyString(id object) {
	return [object isKindOfClass:[NSString class]] && ![(NSString *) object length];
}


#pragma mark Device Orientation

UIDeviceOrientation 
UXDeviceOrientation() {
	UIDeviceOrientation orient = [UIDevice currentDevice].orientation;
	if (!orient) {
		return UIDeviceOrientationPortrait;
	}
	else {
		return orient;
	}
}

UIInterfaceOrientation 
UXInterfaceOrientation() {
	UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;
	if (!orient) {
		return [UXNavigator navigator].visibleViewController.interfaceOrientation;
	}
	else {
		return orient;
	}
}

BOOL 
UXIsSupportedOrientation(UIInterfaceOrientation orientation) {
	switch (orientation) {
		case UIInterfaceOrientationPortrait:
		case UIInterfaceOrientationLandscapeLeft:
		case UIInterfaceOrientationLandscapeRight:
			return TRUE;
		default:
			return FALSE;
	}
}

CGAffineTransform 
UXRotateTransformForOrientation(UIInterfaceOrientation orientation) {
	if (orientation == UIInterfaceOrientationLandscapeLeft) {
		return CGAffineTransformMakeRotation(M_PI * 1.5);
	}
	else if (orientation == UIInterfaceOrientationLandscapeRight) {
		return CGAffineTransformMakeRotation(M_PI / 2);
	}
	else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
		return CGAffineTransformMakeRotation(-M_PI);
	}
	else {
		return CGAffineTransformIdentity;
	}
}

BOOL 
UXIsKeyboardVisible() {
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	return !![window findFirstResponder];
}


//BOOL
//UXIsKeyboardVisible() {
//	NSArray *windows = [[UIApplication sharedApplication] windows];
//	for (UIWindow *window in [windows reverseObjectEnumerator] ) {
//		for (UIView *view in [window subviews]) {
//			NSString *kbClassName = NSStringFromClass([view class]);
//			if ([kbClassName isEqualToString:@"UIKeyboard"]) {
//				return TRUE;
//			}
//			/*
//			if (!strcmp(object_getClassName(view), "UIKeyboard")) {
//				return YES;
//			}
//			*/
//		}
//	}
//	return FALSE;
//}

BOOL 
UXIsPhoneSupported() {
	NSString *deviceType = [UIDevice currentDevice].model;
	return [deviceType isEqualToString:@"iPhone"];
}


#pragma mark Screen Geometry

CGRect 
UXScreenBounds() {
	CGRect bounds = [UIScreen mainScreen].bounds;
	if (UIDeviceOrientationIsLandscape(UXInterfaceOrientation())) {
		CGFloat width		= bounds.size.width;
		bounds.size.width	= bounds.size.height;
		bounds.size.height	= width;
	}
	return bounds;
}

CGRect 
UXApplicationFrame() {
	CGRect frame = [UIScreen mainScreen].applicationFrame;
	return CGRectMake(0, 0, frame.size.width, frame.size.height);
}

CGRect 
UXNavigationFrame() {
	CGRect frame = [UIScreen mainScreen].applicationFrame;
	return CGRectMake(0, 0, frame.size.width, frame.size.height - UXToolbarHeight());
}

CGRect 
UXKeyboardNavigationFrame() {
	return UXRectContract(UXNavigationFrame(), 0, UXKeyboardHeight());
}

CGRect 
UXToolbarNavigationFrame() {
	CGRect frame = [UIScreen mainScreen].applicationFrame;
	return CGRectMake(0, 0, frame.size.width, frame.size.height - UXToolbarHeight() * 2);
}

CGFloat 
UXStatusHeight() {
	UIInterfaceOrientation orientation = UXInterfaceOrientation();
	if (orientation == UIInterfaceOrientationLandscapeLeft) {
		return [UIScreen mainScreen].applicationFrame.origin.x;
	}
	else if (orientation == UIInterfaceOrientationLandscapeRight) {
		return -[UIScreen mainScreen].applicationFrame.origin.x;
	}
	else {
		return [UIScreen mainScreen].applicationFrame.origin.y;
	}
}

CGFloat 
UXBarsHeight() {
	CGRect frame = [UIApplication sharedApplication].statusBarFrame;
	if (UIInterfaceOrientationIsPortrait(UXInterfaceOrientation())) {
		return frame.size.height + UX_ROW_HEIGHT;
	}
	else {
		return frame.size.width + UX_LANDSCAPE_TOOLBAR_HEIGHT;
	}
}

CGFloat 
UXToolbarHeight() {
	return UXToolbarHeightForOrientation(UXInterfaceOrientation());
}

CGFloat 
UXToolbarHeightForOrientation(UIInterfaceOrientation orientation) {
	if (UIInterfaceOrientationIsPortrait(orientation)) {
		return UX_ROW_HEIGHT;
	}
	else {
		return UX_LANDSCAPE_TOOLBAR_HEIGHT;
	}
}

CGFloat 
UXKeyboardHeight() {
	return UXKeyboardHeightForOrientation(UXInterfaceOrientation());
}

CGFloat 
UXKeyboardHeightForOrientation(UIInterfaceOrientation orientation) {
	if (UIInterfaceOrientationIsPortrait(orientation)) {
		return UX_KEYBOARD_HEIGHT;
	}
	else {
		return UX_LANDSCAPE_KEYBOARD_HEIGHT;
	}
}


#pragma mark Geometry

CGRect 
UXRectContract(CGRect rect, CGFloat dx, CGFloat dy) {
	return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width - dx, rect.size.height - dy);
}

CGRect 
UXRectShift(CGRect rect, CGFloat dx, CGFloat dy) {
	return CGRectOffset(UXRectContract(rect, dx, dy), dx, dy);
}

CGRect 
UXRectInset(CGRect rect, UIEdgeInsets insets) {
	return CGRectMake(rect.origin.x + insets.left, 
					  rect.origin.y + insets.top,
	                  rect.size.width  - (insets.left + insets.right),
	                  rect.size.height - (insets.top + insets.bottom));

}


#pragma mark Network Activity Indicator

void 
UXNetworkRequestStarted() {
	if (gNetworkTaskCount++ == 0) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	}
}

void 
UXNetworkRequestStopped() {
	if (--gNetworkTaskCount == 0) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	}
}


#pragma mark Alert Views

void 
UXAlert(NSString *message) {
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:UXLocalizedString(@"Alert", @"")
													 message:message delegate:nil
										   cancelButtonTitle:UXLocalizedString(@"OK", @"")
										   otherButtonTitles:nil] autorelease];
	[alert show];
}

void 
UXAlertError(NSString *message) {
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:UXLocalizedString(@"Alert", @"")
													 message:message delegate:nil
										   cancelButtonTitle:UXLocalizedString(@"OK", @"")
										   otherButtonTitles:nil] autorelease];
	[alert show];
}


#pragma mark Operation System Version

float 
UXOSVersion() {
	return [[[UIDevice currentDevice] systemVersion] floatValue];
}

BOOL 
UXOSVersionIsAtLeast(float version) {
#ifdef __IPHONE_3_0
	return 3.0 >= version;
#endif
#ifdef __IPHONE_2_2
	return 2.2 >= version;
#endif
#ifdef __IPHONE_2_1
	return 2.1 >= version;
#endif
#ifdef __IPHONE_2_0
	return 2.0 >= version;
#endif
	return NO;
}


#pragma mark Localization

NSLocale * 
UXCurrentLocale() {
	NSUserDefaults *defaults	= [NSUserDefaults standardUserDefaults];
	NSArray *languages			= [defaults objectForKey:@"AppleLanguages"];
	if (languages.count > 0) {
		NSString *currentLanguage = [languages objectAtIndex:0];
		return [[[NSLocale alloc] initWithLocaleIdentifier:currentLanguage] autorelease];
	}
	else {
		return [NSLocale currentLocale];
	}
}

NSString * 
UXLocalizedString(NSString *key, NSString *comment) {
	static NSBundle *bundle = nil;
	if (!bundle) {
		NSString *path	= [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"UXKit.bundle"];
		bundle			= [[NSBundle bundleWithPath:path] retain];
	}
	return [bundle localizedStringForKey:key value:key table:nil];
}

NSString * 
UXDescriptionForError(NSError *error) {
	UXLOG(@"ERROR %@", error);
	if ([error.domain isEqualToString:NSURLErrorDomain]) {
		if (error.code == NSURLErrorTimedOut) {
			return UXLocalizedString(@"Connection Timed Out", @"");
		}
		else if (error.code == NSURLErrorNotConnectedToInternet) {
			return UXLocalizedString(@"No Internet Connection", @"");
		}
		else {
			return UXLocalizedString(@"Connection Error", @"");
		}
	}
	return UXLocalizedString(@"Error", @"");
}

NSString * 
UXFormatInteger(NSInteger num) {
	NSNumber *number				= [NSNumber numberWithInt:num];
	NSNumberFormatter *formatter	= [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle:kCFNumberFormatterDecimalStyle];
	[formatter setGroupingSeparator:@","];
	NSString *formatted				= [formatter stringForObjectValue:number];
	[formatter release];
	return formatted;
}


#pragma mark Bundle URL Paths

BOOL 
UXIsBundleURL(NSString *URL) {
	if (URL.length >= 9) {
		return [URL rangeOfString:@"bundle://" options:0 range:NSMakeRange(0, 9)].location == 0;
	}
	else {
		return NO;
	}
}

BOOL 
UXIsDocumentsURL(NSString *URL) {
	if (URL.length >= 12) {
		return [URL rangeOfString:@"documents://" options:0 range:NSMakeRange(0, 12)].location == 0;
	}
	else {
		return NO;
	}
}

BOOL
UXIsFileURL(NSString *URL) {
	if (URL.length >= 7) {
		return [URL rangeOfString:@"file://" options:0 range:NSMakeRange(0, 7)].location == 0;
	}
	else {
		return NO;
	}
}

BOOL 
UXIsNamedCacheURL(NSString *URL) {
	if (URL.length >= 12) {
		return [URL rangeOfString:@"cache://" options:0 range:NSMakeRange(0, 8)].location == 0;
	}
	else {
		return NO;
	}
}

BOOL
UXIsTempURL(NSString *URL) {
	if (URL.length >= 7) {
		return [URL rangeOfString:@"temp://" options:0 range:NSMakeRange(0,7)].location == 0;
	}
	else {
		return NO;
	}
}

BOOL
UXIsAskDelegateURL(NSString *URL) {
	if (URL.length >= 11) {
		return [URL rangeOfString:@"delegate://" options:0 range:NSMakeRange(0, 11)].location == 0;
	}
	else {
		return NO;
	}
}


NSString * 
UXPathForBundleResource(NSString *relativePath) {
	NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
	return [resourcePath stringByAppendingPathComponent:relativePath];
}

NSString * 
UXPathForDocumentsResource(NSString *relativePath) {
	static NSString *documentsPath = nil;
	if (!documentsPath) {
		NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		documentsPath = [[dirs objectAtIndex:0] retain];
	}
	return [documentsPath stringByAppendingPathComponent:relativePath];
}

NSString *
UXPathForTempResource(NSString *relativePath) {
	NSString *tempPath = NSTemporaryDirectory();
	return [tempPath stringByAppendingPathComponent:relativePath];
}

NSURL * 
UXFileURLForBundleResource(NSString *bundleResourceName) {
	NSString *bundleResourcePath = [[NSBundle mainBundle] resourcePath];
	NSString *fullResourcePath = [bundleResourcePath stringByAppendingPathComponent:bundleResourceName];
	return [NSURL fileURLWithPath:fullResourcePath];
}


#pragma mark Runtime

void 
UXSwapMethods(Class cls, SEL originalSel, SEL newSel) {
	Method originalMethod	= class_getInstanceMethod(cls, originalSel);
	Method newMethod		= class_getInstanceMethod(cls, newSel);
	method_exchangeImplementations(originalMethod, newMethod);
}
