
/*!
@project	UXKit
@header		UIXViewController.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*!
@category UIViewController (UIXViewController)
@abstract
@discussion
*/
@interface UIViewController (UIXViewController)

	/*!
	@abstract The current URL that this view controller represents.
	*/
	@property (nonatomic, readonly) NSString *navigatorURL;

	/*!
	@abstract The URL that was used to load this controller through UXNavigator.
	@discussion Do not ever change the value of this property.  UXNavigator will assign this
	when creating your view controller, and it expects it to remain constant throughout
	the view controller's life.  You can override navigatorURL if you want to specify
	a different URL for your view controller to use when persisting and restoring it.
	*/
	@property (nonatomic, copy) NSString *originalNavigatorURL;

	/*!
	@abstract Determines whether a controller is primarily a container of other controllers.
	*/
	@property (nonatomic, readonly) BOOL canContainControllers;

	/*!
	@abstract The view controller that contains this view controller.
	@discussion This is just like parentViewController, except that it is not readonly.  
	This property offers custom UIViewController subclasses the chance to tell UXNavigator 
	how to follow the hierarchy of view controllers.
	*/
	@property (nonatomic, retain) UIViewController *superController;

	/*!
	@abstract A popup view controller that is presented on top of this view controller.
	*/
	@property (nonatomic, retain) UIViewController *popupViewController;

	/*!
	@abstract A temporary holding place for persisted view state waiting to be restored.
	@discussion While restoring controllers, UXURLMap will assign this the dictionary 
	created by persistView. Ultimately, this state is bound for the restoreView call, 
	but it is up to subclasses to call restoreView at the appropriate time -- usually 
	after the view has been created. After the state has been restored,  frozenState 
	should be set to nil.
	*/
	@property (nonatomic, retain) NSDictionary *frozenState;


	#pragma mark -

	/*!
	@abstract The default initializer sent to view controllers opened through UXNavigator.
	*/
	-(id) initWithNavigatorURL:(NSURL *)aURL query:(NSDictionary *)aQuery;

	/*!
	@abstract The child of this view controller which is most visible.
	@discussion This would be the selected view controller of a tab bar controller, or the top
	view controller of a navigation controller.  This property offers custom UIViewController
	subclasses the chance to tell UXNavigator how to follow the hierarchy of view controllers.
	*/
	-(UIViewController *) topSubcontroller;

	/*!
	@abstract The view controller that comes before this one in a navigation controller's history.
	*/
	-(UIViewController *) previousViewController;

	/*!
	@abstract The view controller that comes after this one in a navigation controller's history.
	*/
	-(UIViewController *) nextViewController;

	/*!
	@abstract Displays a controller inside this controller.
	@discussion UXURLMap uses this to display newly created controllers.  The default does nothing --
	UIViewController categories and subclasses should implement to display the controller
	in a manner specific to them.
	*/
	-(void) addSubcontroller:(UIViewController *)aController animated:(BOOL)animated transition:(UIViewAnimationTransition)transition;

	/*!
	@abstract Dismisses a view controller using the opposite transition it was presented with.
	*/
	-(void) removeFromSupercontroller;
	-(void) removeFromSupercontrollerAnimated:(BOOL)animated;

	/*!
	@abstract Brings a controller that is a child of this controller to the front.
	@discussion UXURLMap uses this to display controllers that exist already, but may not be visible.
	The default does nothing -- UIViewController categories and subclasses should implement
	to display the controller in a manner specific to them.
	*/
	-(void) bringControllerToFront:(UIViewController *)aController animated:(BOOL)animated;

	/*!
	@abstract Gets a key that can be used to identify a subcontroller in subcontrollerForKey.
	*/
	-(NSString *) keyForSubcontroller:(UIViewController *)aController;

	/*!
	@abstract Gets a subcontroller with the key that was returned from keyForSubcontroller.
	*/
	-(UIViewController *) subcontrollerForKey:(NSString *)aKey;

	/*!
	@abstract Persists aspects of the view state to a dictionary that can later be used to restore it.
	@discussion This will be called when UXNavigator is persisting the navigation history so that it
	can later be restored.  This usually happens when the app quits, or when there is a low
	memory warning.
	*/
	-(BOOL) persistView:(NSMutableDictionary *)aState;

	/*!
	@abstract Restores aspects of the view state from a dictionary populated by persistView.
	@discussion This will be called when UXNavigator is restoring the navigation history.  This may
	happen after launch, or when the controller appears again after a low memory warning.
	*/
	-(void) restoreView:(NSDictionary *)aState;

	/*!
	@abstract Not documenting this in the hopes that I can eliminate it ;)
	*/
	-(void) persistNavigationPath:(NSMutableArray *)aPath;

	/*!
	@abstract Finishes initializing the controller after a UXNavigator-coordinated delay.
	@discussion If the controller was created in between calls to UXNavigator beginDelay 
	and endDelay, then this will be called after endDelay.
	*/
	-(void) delayDidEnd;

	/*!
	@abstract Shows or hides the navigation and status bars.
	*/
	-(void) showBars:(BOOL)show animated:(BOOL)animated;

	/*!
	@abstract Shortcut for its animated-optional cousin.
	*/
	-(void) dismissModalViewController;

@end
