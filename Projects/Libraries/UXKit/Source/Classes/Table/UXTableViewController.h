
/*!
@project	UXKit
@header     UXTableViewController.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXModelViewController.h>
#import <UXKit/UXTableViewDataSource.h>

@class UXActivityLabel;

/*!
@class UXTableViewController
@superclass UXModelViewController
@abstract
@discussion
*/
@interface UXTableViewController : UXModelViewController {
	UITableView *_tableView;
	UIView *_tableBannerView;
	UIView *_tableOverlayView;
	UIView *_loadingView;
	UIView *_errorView;
	UIView *_emptyView;
	UIView *_menuView;
	UITableViewCell *_menuCell;
	id <UXTableViewDataSource> _dataSource;
	id <UITableViewDelegate> _tableDelegate;
	NSTimer *_bannerTimer;
	UITableViewStyle _tableViewStyle;
	UIInterfaceOrientation _lastInterfaceOrientation;
	BOOL _variableHeightRows;
	//BOOL showingEditMenu;
}

	@property (nonatomic, retain) UITableView *tableView;

	/*!
	@abstract A view that is displayed as a banner at the bottom of the table view.
	*/
	@property (nonatomic, retain) UIView *tableBannerView;

	/*!
	@abstract A view that is displayed over the table view.
	*/
	@property (nonatomic, retain) UIView *tableOverlayView;

	@property (nonatomic, retain) UIView *loadingView;
	@property (nonatomic, retain) UIView *errorView;
	@property (nonatomic, retain) UIView *emptyView;

	@property (nonatomic, readonly) UIView *menuView;

	/*!
	@abstract The data source used to populate the table view.
	@discussion Setting dataSource has the side effect of also setting model to the value of the
	dataSource's model property.
	*/
	@property (nonatomic, retain) id <UXTableViewDataSource> dataSource;

	/*!
	@abstract The style of the table view.
	*/
	@property (nonatomic) UITableViewStyle tableViewStyle;

	/*!
	@abstract Indicates if the table should support non-fixed row heights.
	*/
	@property (nonatomic) BOOL variableHeightRows;

	
	#pragma mark Initializer

	/*!
	@abstract Initializes and returns a controller having the given style.
	*/
	-(id) initWithStyle:(UITableViewStyle)style;

	/*!
	@abstract Creates an delegate for the table view.
	@discussion Subclasses can override this to provide their own table delegate implementation.
	*/
	-(id <UITableViewDelegate>) createDelegate;
	
	/*!
	@abstract Sets the view that is displayed at the bottom of the table view with an optional animation.
	*/
	-(void) setTableBannerView:(UIView *)aTableBannerView animated:(BOOL)animated;

	/*!
	@abstract Shows a menu over a table cell.
	*/
	-(void) showMenu:(UIView *)aView forCell:(UITableViewCell *)aCell animated:(BOOL)animated;

	/*!
	@abstract Hides the currently visible table cell menu.
	*/
	-(void) hideMenu:(BOOL)animated;

	/*!
	@abstract Tells the controller that the user selected an object in the table.
	@discussion By default, the object's URLValue will be opened in UXNavigator, if it has one. 
	If you don't want this to be happen, be sure to override this method and be sure not to 
	call super.
	*/
	-(void) didSelectObject:(id)anObject atIndexPath:(NSIndexPath *)anIndexPath;

	/*!
	@abstract Asks if a URL from that user touched in the table should be opened.
	*/
	-(BOOL) shouldOpenURL:(NSString *)aURL;

	/*!
	@abstract Tells the controller that the user began dragging the table view.
	*/
	-(void) didBeginDragging;

	/*!
	@abstract Tells the controller that the user stopped dragging the table view.
	*/
	-(void) didEndDragging;

	/*!
	@abstract The rectangle where the overlay view should appear.
	*/
	-(CGRect) rectForOverlayView;

	/*!
	@abstract The rectangle where the banner view should appear.
	*/
	-(CGRect) rectForBannerView;

@end
