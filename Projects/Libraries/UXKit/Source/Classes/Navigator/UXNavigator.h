
/*!
@project	UXKit
@header     UXNavigator.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXGlobal.h>

@protocol UXNavigatorDelegate;
@class UXURLMap;
@class UXURLPattern;

typedef NSUInteger UXNavigatorPersistenceMode;

/*!
@constant UXNavigatorPersistenceModeNone	No persistence
@constant UXNavigatorPersistenceModeTop		Persists only the top-level controller
@constant UXNavigatorPersistenceModeAll		Persists all navigation paths
*/
enum {
	UXNavigatorPersistenceModeNone,
	UXNavigatorPersistenceModeTop,
	UXNavigatorPersistenceModeAll,
};

/*!
@class UXNavigator
@superclass NSObject
@abstract
@discussion
*/
@interface UXNavigator : NSObject {
	id <UXNavigatorDelegate> _delegate;
	UXURLMap *_URLMap;
	UIWindow *_window;
	UIViewController *_rootViewController;
	NSMutableArray *_delayedControllers;
	NSTimeInterval _persistenceExpirationAge;
	BOOL _delayCount;
	UXNavigatorPersistenceMode _persistenceMode;
	BOOL _supportsShakeToReload;
	BOOL _opensExternalURLs;
}

	@property (nonatomic, assign) id <UXNavigatorDelegate> delegate;

	/*!
	@abstract The URL map used to translate between URLs and view controllers.
	*/
	@property (nonatomic, readonly) UXURLMap *URLMap;

	/*!
	@abstract The window that contains the views view controller hierarchy.
	*/
	@property (nonatomic, retain) UIWindow *window;

	/*!
	@abstract The controller that is at the root of the view controller hierarchy.
	*/
	@property (nonatomic, retain) UIViewController *rootViewController;

	/*!
	@abstract The currently visible view controller.
	*/
	@property (nonatomic, readonly) UIViewController *visibleViewController;

	/*!
	@abstract The view controller that is currently on top of the navigation stack.
	@discussion This differs from visibleViewController in that it ignores things like search
	display controllers which are visible, but not part of navigation.
	*/
	@property (nonatomic, readonly) UIViewController *topViewController;

	/*!
	@abstract The URL of the currently visible view controller;
	@discussion Setting this property will open a new URL.
	*/
	@property (nonatomic, copy) NSString *URL;

	/*!
	@abstract How view controllers are automatically persisted on termination and restored on launch.
	*/
	@property (nonatomic) UXNavigatorPersistenceMode persistenceMode;

	/*!
	@abstract The age at which persisted view controllers are too old to be restored. Set this 
			  to 0 to restore from any age. The default value is 0.
	@discussion In some cases, it is a good practice not to restore really old navigation paths, because
	the user probably won't remember how they got there, and would prefer to start from the
	beginning.
	*/
	@property (nonatomic) NSTimeInterval persistenceExpirationAge;

	/*!
	@abstract Causes the current view controller to be reloaded when shaking the phone.
	*/
	@property (nonatomic) BOOL supportsShakeToReload;

	/*!
	@abstract Allows URLs to be opened externally if they don't match any patterns.
	The default value is NO.
	*/
	@property (nonatomic) BOOL opensExternalURLs;

	/*!
	@abstract Indicates that we asking controllers to delay heavy operations until a later time.
	@discussion The default value is NO.
	*/
	@property (nonatomic, readonly) BOOL isDelayed;


	#pragma mark -

	+(UXNavigator *) navigator;

	/*!
	@abstract Loads and displays a view controller with a pattern than matches the URL.
	@discussion If there is not yet a rootViewController, the view controller loaded with this URL
	will be assigned as the rootViewController and inserted into the keyWinodw.  If there is not
	a keyWindow, a UIWindow will be created and displayed.
	*/

	-(UIViewController *) openURL:(NSString *)aURL animated:(BOOL)animated;
	-(UIViewController *) openURL:(NSString *)aURL animated:(BOOL)animated transition:(UIViewAnimationTransition)aTransition;
	-(UIViewController *) openURL:(NSString *)aURL parent:(NSString *)aParentURL animated:(BOOL)animated;
	-(UIViewController *) openURL:(NSString *)aURL parent:(NSString *)aParentURL query:(NSDictionary *)aQuery animated:(BOOL)animated;
	-(UIViewController *) openURL:(NSString *)aURL parent:(NSString *)aParentURL query:(NSDictionary *)aQuery animated:(BOOL)animated 
																											transition:(UIViewAnimationTransition)aTransition;
	-(UIViewController *) openURL:(NSString *)aURL parent:(NSString *)aParentURL query:(NSDictionary *)aQuery animated:(BOOL)animated 
																											transition:(UIViewAnimationTransition)aTransition 
																											 withDelay:(BOOL)withDelay;
	-(UIViewController *) openURL:(NSString *)aURL query:(NSDictionary *)aQuery animated:(BOOL)animated;

	/*!
	@abstract Opens a sequence of URLs, with only the last one being animated.
	*/
	-(UIViewController *) openURLs:(NSString *)aURL, ...;

	/*!
	@abstract Gets a view controller for the URL without opening it.
	*/
	-(UIViewController *) viewControllerForURL:(NSString *)aURL;
	-(UIViewController *) viewControllerForURL:(NSString *)aURL query:(NSDictionary *)query;
	-(UIViewController *) viewControllerForURL:(NSString *)aURL query:(NSDictionary *)query pattern:(UXURLPattern * *)pattern;

	/*!
	@abstract Tells the navigator to delay heavy operations.
	@discussion Initializing controllers can be very expensive, so if you are going to 
	do some animation while this might be happening, this will tell controllers created 
	through the navigator that they should hold off so as not to slow down the operations.
	*/
	-(void) beginDelay;

	/*!
	@abstract Tells controllers that were created during the delay to finish what they were planning to do.
	*/
	-(void) endDelay;

	/*!
	@abstract Cancels the delay without notifying delayed controllers.
	*/
	-(void) cancelDelay;

	/*!
	@abstract Persists all view controllers to user defaults.
	*/
	-(void) persistViewControllers;

	/*!
	@abstract Restores all view controllers from user defaults and returns the last one.
	*/
	-(UIViewController *) restoreViewControllers;

	/*!
	@abstract Persists a view controller's state and recursively persists the next view controller after it.
	@discussion Do not call this directly except from within a view controller that is being directed
	by the app map to persist itself.
	*/
	-(void) persistController:(UIViewController *)controller path:(NSMutableArray *)path;

	/*!
	@abstract Removes all view controllers from the window and releases them.
	*/
	-(void) removeAllViewControllers;

	/*!
	@abstract A navigation path which can be used to locate an object.
	*/
	-(NSString *) pathForObject:(id)anObject;

	/*!
	@abstract Finds an object using its navigation path.
	*/
	-(id) objectForPath:(NSString *)aPath;

	/*!
	@abstract Erases all data stored in user defaults.
	*/
	-(void) resetDefaults;

	/*!
	@abstract Reloads the content in the visible view controller.
	*/
	-(void) reload;
	
	-(void) setRootNavigationController:(UINavigationController *)controller;

@end

#pragma mark -

/*!
@class UXNavigatorWindow
@superclass UIWindow
@abstract
@discussion
*/
@interface UXNavigatorWindow : UIWindow

@end

#pragma mark -

/*!
@protocol UXNavigatorDelegate <NSObject>
@abstract
*/
@protocol UXNavigatorDelegate <NSObject>

@optional
	/*!
	@abstract Asks if the URL should be opened and allows the delegate to prevent it.
	*/
	-(BOOL) navigator:(UXNavigator *)aNavigator shouldOpenURL:(NSURL *)aURL;

	/*!
	@abstract The URL is about to be opened in a controller. If the controller 
	argument is nil, the URL is going to be opened externally.
	*/
	-(void) navigator:(UXNavigator *)aNavigator willOpenURL:(NSURL *)aURL inViewController:(UIViewController *)aController;

@end

#pragma mark -

/*!
@abstract Shortcut for calling [[UXNavigator navigator] openURL:]
*/
UIViewController * 
UXOpenURL(NSString *URL);
