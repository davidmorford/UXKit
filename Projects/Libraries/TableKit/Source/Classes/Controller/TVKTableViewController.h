
/*!
@project    UXTableCatalog
@header     TVKTableViewController.h
@copyright  (c) 2009, Semantap
@created    11/26/09
*/

#import <UIKit/UIKit.h>
#import <TableKit/TVKTableController.h>

/*!
@class TVKTableViewController
@superclass UIViewController <TVKTableControllerDelegate>
@abstract
@discussion
*/
@interface TVKTableViewController : UIViewController <TVKTableControllerDelegate> {
	UITableView *tableView;
	UITableViewStyle tableViewStyle;
	TVKTableController *tableController;
	UIView *tableHeaderView;
	UIView *tableFooterView;
	NSUndoManager *undoManager;
	BOOL undoEnabled;
	NSUInteger undoLevelLimit;
	BOOL editMenuVisible;
}

	@property (nonatomic, retain) UITableView *tableView;
	@property (nonatomic, assign) UITableViewStyle tableViewStyle;
	
	@property (nonatomic, retain) TVKTableController *tableController;

	@property (nonatomic, retain) UIView *tableHeaderView;
	@property (nonatomic, retain) UIView *tableFooterView;

	@property (nonatomic, retain) NSUndoManager *undoManager;
	@property (nonatomic, assign) BOOL undoEnabled;

	/*!
	@abstract  Levels of undo is somewhat arbitrary. It can coincide with the 
	number of properties that can be edited, but in general consider the memory 
	overhead of maintaining a large number of undo actions, and the user interaction
	(how easy will it be for the user to backtrack through a dozen or more actions).
	*/	
	@property (nonatomic, assign) NSUInteger undoLevelLimit;

	#pragma mark -

	/*!
	@abstract Initialize the controller with a table view style.
	@discussion This is the designated initializer.
	@param style	A UITableViewStyle value
	*/
	-(id) initWithTableViewStyle:(UITableViewStyle)style;
	
	/*!
	@abstract
	@param tableStyle style 
	@param controller
	*/
	-(id) initWithTableViewStyle:(UITableViewStyle)style controller:(TVKTableController *)controller;

@end
