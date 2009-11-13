
/*!
@project	UXKit
@header     UXGlobal.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <objc/runtime.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <UXKit/UXNSObject.h>
#import <UXKit/UXNSString.h>
#import <UXKit/UXNSDate.h>
#import <UXKit/UXNSArray.h>

#import <UXKit/UIXColor.h>
#import <UXKit/UIXFont.h>
#import <UXKit/UIXImage.h>
#import <UXKit/UIXViewController.h>
#import <UXKit/UIXNavigationController.h>
#import <UXKit/UIXTabBarController.h>
#import <UXKit/UIXView.h>
#import <UXKit/UIXTableView.h>
#import <UXKit/UIXWebView.h>
#import <UXKit/UIXToolbar.h>
#import <UXKit/UIXWindow.h>

#pragma mark Logging

#define DEBUG 1

#ifdef DEBUG
	#define UXLOG			NSLog
	#define UXLOGMETHOD		NSLog(@"%s logged call: -[%@ %s] (line %d)", _cmd, self, _cmd, __LINE__)
#else
	#define UXLOG
	#define UXLOGMETHOD
#endif

#define UXWARN				UXLOG

#define UXLOGRECT(rect)		UXLOG(@"%s x=%f, y=%f, w=%f, h=%f", #rect, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
#define UXLOGPOINT(pt)		UXLOG(@"%s x=%f, y=%f", #pt, pt.x, pt.y)
#define UXLOGSIZE(size)		UXLOG(@"%s w=%f, h=%f", #size, size.width, size.height)
#define UXLOGEDGES(edges)	UXLOG(@"%s left=%f, right=%f, top=%f, bottom=%f", #edges, edges.left, edges.right, edges.top, edges.bottom)
#define UXLOGHSV(_COLOR)	UXLOG(@"%s h=%f, s=%f, v=%f", #_COLOR, _COLOR.hue, _COLOR.saturation, _COLOR.value)
#define AUXTLOGVIEWS(_VIEW)	{ for (UIView* view = _VIEW; view; view = view.superview) { UXLOG(@"%@", view); } }

#pragma mark Errors

#define UX_ERROR_DOMAIN		@"semantap.com"
#define UX_EC_INVALID_IMAGE	101


#pragma mark Common Dimensions

#define UX_ROW_HEIGHT					44
#define UX_TOOLBAR_HEIGHT				44
#define UX_LANDSCAPE_TOOLBAR_HEIGHT		28
#define UX_KEYBOARD_HEIGHT				216
#define UX_LANDSCAPE_KEYBOARD_HEIGHT	160
#define UX_ROUNDED						-1


#pragma mark Color

#define RGBCOLOR(r, g, b)		[UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1]
#define RGBACOLOR(r, g, b, a)	[UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]

#define HSVCOLOR(h, s, v)		[UIColor colorWithHue:h saturation:s value:v alpha:1]
#define HSVACOLOR(h, s, v, a)	[UIColor colorWithHue:h saturation:s value:v alpha:a]

#define RGBA(r, g, b, a)		r / 255.0, g / 255.0, b / 255.0, a


#pragma mark Style

#define UXSTYLE(_SELECTOR)				[[UXStyleSheet globalStyleSheet] styleWithSelector:@#_SELECTOR]
#define UXSTYLESTATE(_SELECTOR, _STATE)	[[UXStyleSheet globalStyleSheet] styleWithSelector:@#_SELECTOR forState:_STATE]
#define UXSTYLESHEET					((id)[UXStyleSheet globalStyleSheet])
#define UXSTYLEVAR(_VARNAME)			[UXSTYLESHEET _VARNAME]
#define UXIMAGE(_URL)					[[UXURLCache sharedCache] imageForURL:_URL]

typedef NSUInteger UXPosition;
enum {
	UXPositionStatic,
	UXPositionAbsolute,
	UXPositionFloatLeft,
	UXPositionFloatRight,
};


#pragma mark Networking

typedef NSUInteger UXURLRequestCachePolicy;
enum {
	UXURLRequestCachePolicyNone		= 0,
	UXURLRequestCachePolicyMemory   = 1,
	UXURLRequestCachePolicyDisk     = 2,
	UXURLRequestCachePolicyNetwork  = 4,
	UXURLRequestCachePolicyNoCache  = 8,
	UXURLRequestCachePolicyLocal    = (UXURLRequestCachePolicyMemory | UXURLRequestCachePolicyDisk),
	UXURLRequestCachePolicyDefault	= (UXURLRequestCachePolicyMemory | UXURLRequestCachePolicyDisk | UXURLRequestCachePolicyNetwork),
};

/*!
@abstract 1 day
*/
#define UX_DEFAULT_CACHE_INVALIDATION_AGE	(60 * 60 * 24)

/*!
@abstract 1 week 
*/
#define UX_DEFAULT_CACHE_EXPIRATION_AGE	(60 * 60 * 24 *7)

#pragma mark Time

#define UX_MINUTE	60
#define UX_HOUR		(60 * UX_MINUTE)
#define UX_DAY		(24 * UX_HOUR)
#define UX_WEEK		(7 * UX_DAY)
#define UX_MONTH	(30.5 * UX_DAY)
#define UX_YEAR		(365 * UX_DAY)


#pragma mark Animation

/*!
@abstract The standard duration for transition animations.
*/
#define UX_TRANSITION_DURATION		0.3
#define UX_FAST_TRANSITION_DURATION	0.2
#define UX_FLIP_TRANSITION_DURATION	0.7

/*!
@abstract Duration for transitions used by launcher view controller.
*/
#define UX_LAUNCHER_SHOW_TRANSITION_DURATION	0.25
#define UX_LAUNCHER_HIDE_TRANSITION_DURATION	0.3

#pragma mark Memory

#define UX_SAFE_RELEASE(__POINTER)		{ [__POINTER release];  __POINTER = nil; }
#define UX_SAFE_AUTORELEASE(__POINTER)	{ [__POINTER autorelease]; __POINTER = nil; }
#define UX_INVALIDATE_TIMER(__TIMER)	{ [__TIMER invalidate]; __TIMER   = nil; }


#pragma mark Collections

/*!
@abstract Creates a mutable array which does not retain references to the objects it contains.
*/
NSMutableArray * 
UXCreateNonRetainingArray();

/*!
@abstract Creates a mutable dictionary which does not retain references to the values it contains.
*/
NSMutableDictionary * 
UXCreateNonRetainingDictionary();

/*!
@abstract Tests if an object is an array which is empty.
*/
BOOL 
UXIsEmptyArray(id object);

/*!
@abstract Tests if an object is a set which is empty.
*/
BOOL
UXIsEmptySet(id object);

/*!
@abstract Tests if an object is a string which is empty.
*/
BOOL 
UXIsEmptyString(id object);


#pragma mark Device Orientation

/*!
@abstract Gets the current device orientation.
*/
UIDeviceOrientation  
UXDeviceOrientation();

/*!
@abstract Gets the current interface orientation.
*/
UIInterfaceOrientation
UXInterfaceOrientation();

/*!
@abstract Checks if the orientation is portrait, landscape left, or landscape right.
This helps to ignore upside down and flat orientations.
*/
BOOL
UXIsSupportedOrientation(UIInterfaceOrientation orientation);

/*!
@abstract Gets the rotation transform for a given orientation.
*/
CGAffineTransform 
UXRotateTransformForOrientation(UIInterfaceOrientation orientation);

/*!
@abstract Gets the bounds of the screen with device orientation factored in.
*/
CGRect 
UXScreenBounds();

/*!
@abstract Tests if the keyboard is visible.
*/
BOOL 
UXIsKeyboardVisible();

/*!
@abstract Tests if the device has phone capabilities.
*/
BOOL 
UXIsPhoneSupported();

#pragma mark Screen Geometry

/*!
@abstract Gets the application frame.
*/
CGRect 
UXApplicationFrame();

/*!
@abstract Gets the application frame below the navigation bar.
*/
CGRect 
UXNavigationFrame();

/*!
@abstract Gets the application frame below the navigation bar and above the keyboard.
*/
CGRect
UXKeyboardNavigationFrame();

/*!
@abstract Gets the application frame below the navigation bar and above a toolbar.
*/
CGRect
UXToolbarNavigationFrame();

/*!
@abstract The height of the area containing the status bar and possibly the in-call status bar.
*/
CGFloat
UXStatusHeight();

/*!
@abstract The height of the area containing the status bar and navigation bar.
*/
CGFloat
UXBarsHeight();

/*!
@abstract The height of a toolbar.
*/
CGFloat
UXToolbarHeight();

CGFloat
UXToolbarHeightForOrientation(UIInterfaceOrientation orientation);

/*!
@abstract The height of the keyboard.
*/
CGFloat
UXKeyboardHeight();

CGFloat
UXKeyboardHeightForOrientation(UIInterfaceOrientation orientation);


#pragma mark Geometry

/*!
@abstract Returns a rectangle that is smaller or larger than the source rectangle.
*/
CGRect
UXRectContract(CGRect rect, CGFloat dx, CGFloat dy);

/*!
@abstract Returns a rectangle whose edges have been moved a distance and shortened by that distance.
*/
CGRect
UXRectShift(CGRect rect, CGFloat dx, CGFloat dy);

/*!
@abstract Returns a rectangle whose edges have been added to the insets.
*/
CGRect
UXRectInset(CGRect rect, UIEdgeInsets insets);


#pragma mark Network Activity Indicator

/*!
@abstract Increment the number of active network requests.
@discussion The status bar activity indicator will be spinning while there are active requests.
*/
void 
UXNetworkRequestStarted();

/*!
@abstract Decrement the number of active network requests.
@discussion The status bar activity indicator will be spinning while there are active requests.
*/
void 
UXNetworkRequestStopped();


#pragma mark Alert Views

/*!
@abstract A convenient way to show a UIAlertView with a message;
*/
void
UXAlert(NSString *message);

void
UXAlertError(NSString *message);


#pragma mark Operating System Version

/*!
@abstract Gets the current runtime version of iPhone OS.
*/
float 
UXOSVersion();

/*!
@abstract Checks if the link-time version of the OS is at least a certain version.
*/
BOOL 
UXOSVersionIsAtLeast(float version);


#pragma mark Localized Strings

/*!
@abstract Gets the current system locale chosen by the user.
@discussion This is necessary because [NSLocale currentLocale] always returns en_US.
*/
NSLocale * 
UXCurrentLocale();

/*!
@abstract Returns a localized string from the UXKit bundle.
*/
NSString * 
UXLocalizedString(NSString *key, NSString *comment);

/*!
@abstract Returns a localized string from the UXKit bundle.
*/
NSString *
UXDescriptionForError(NSError *error);

NSString *
UXFormatInteger(NSInteger num);


#pragma mark URIs

BOOL 
UXIsBundleURL(NSString *URL);

BOOL 
UXIsDocumentsURL(NSString *URL);

BOOL
UXIsFileURL(NSString *URL);

BOOL 
UXIsNamedCacheURL(NSString *URL);

BOOL
UXIsTempURL(NSString *URL);

BOOL
UXIsAskDelegateURL(NSString *URL);


#pragma mark Paths

NSString * 
UXPathForBundleResource(NSString *relativePath);

NSString * 
UXPathForDocumentsResource(NSString *relativePath);

NSString *
UXPathForTempResource(NSString *relativePath);

NSURL * 
UXFileURLForBundleResource(NSString *bundleResourceName);


#pragma mark Runtime

void 
UXSwapMethods(Class cls, SEL originalSel, SEL newSel);
