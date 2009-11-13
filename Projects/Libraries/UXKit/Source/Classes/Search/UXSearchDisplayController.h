
/*!
@project	UXKit
@header		UXSearchDisplayController.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXGlobal.h>

@protocol UXTableViewDataSource;
@class UXTableViewController;

#define UX_SEARCH_BAR_BACKGROUND_TAG 18942

/*!
@class UXSearchDisplayController
@superclass UISearchDisplayController <UISearchDisplayDelegate>
@abstract Shows search results using a UXTableViewController.
@discussion This extends the standard search display controller so that you can search a 
model. Searches that hit the internet and return asynchronously can provide feedback to 
the about the status of the remote search using UXModel's loading interface, and
UXTableViewController's status views.
*/
@interface UXSearchDisplayController : UISearchDisplayController <UISearchDisplayDelegate> {
	id <UITableViewDelegate> _searchResultsDelegate2;
	UXTableViewController *_searchResultsViewController;
	NSTimer *_pauseTimer;
	BOOL _pausesBeforeSearching;
}

	@property (nonatomic, retain) UXTableViewController *searchResultsViewController;
	@property (nonatomic) BOOL pausesBeforeSearching;

@end
