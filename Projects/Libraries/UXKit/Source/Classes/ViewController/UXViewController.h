
/*!
@project	UXKit
@header     UXViewController.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXGlobal.h>

@class UXTableViewController;
@class UXSearchDisplayController;


/*!
@class UXViewController
@superclass UIViewController
@abstract A view controller with some useful additions.
@discussion 
*/
@interface UXViewController : UIViewController {
	NSDictionary *_frozenState;
	UIBarStyle _navigationBarStyle;
	UIColor *_navigationBarTintColor;
	UIStatusBarStyle _statusBarStyle;
	UXSearchDisplayController *_searchController;
	BOOL _isViewAppearing;
	BOOL _hasViewAppeared;
	BOOL _autoresizesForKeyboard;
}

	/*!
	@abstract The style of the navigation bar when this view 
	controller is pushed onto a navigation controller.
	*/
	@property (nonatomic) UIBarStyle navigationBarStyle;

	/*!
	@abstract The color of the navigation bar when this view 
	controller is pushed onto a navigation controller.
	*/
	@property (nonatomic, retain) UIColor *navigationBarTintColor;

	/*!
	@abstract The style of the status bar when this view controller is appearing.
	*/
	@property (nonatomic) UIStatusBarStyle statusBarStyle;	

	/*!
	@abstract A view controller used to display the contents of the search display controller.
	@discussion If you assign a view controller to this property, it will automatically create a search
	display controller which you can access through this view controller's searchDisplaController
	property.  You can then take the searchBar from that controller and add it to your views. The
	search bar will then search the data source of the view controller that you assigned here.
	*/
	@property (nonatomic, retain) UXTableViewController *searchViewController;

	/*!
	@abstract The view has appeared at least once.
	*/
	@property (nonatomic, readonly) BOOL hasViewAppeared;

	/*!
	@abstract The view is currently visible.
	*/
	@property (nonatomic, readonly) BOOL isViewAppearing;

	/*!
	@abstract Determines if the view will be resized automatically to fit the keyboard.
	*/
	@property (nonatomic) BOOL autoresizesForKeyboard;
	
	
	#pragma mark -

	/*!
	@abstract Sent to the controller before the keyboard slides in.
	*/
	-(void) keyboardWillAppear:(BOOL)animated withBounds:(CGRect)bounds;

	/*!
	@abstract Sent to the controller before the keyboard slides out.
	*/
	-(void) keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds;

	/*!
	@abstract Sent to the controller after the keyboard has slid in.
	*/
	-(void) keyboardDidAppear:(BOOL)animated withBounds:(CGRect)bounds;

	/*!
	@abstract Sent to the controller after the keyboard has slid out.
	*/
	-(void) keyboardDidDisappear:(BOOL)animated withBounds:(CGRect)bounds;

@end
