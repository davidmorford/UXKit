
/*!
@project	UXKit
@header     UXTableViewDelegate.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXGlobal.h>

@class UXTableViewController;

/*!
@class UXTableViewDelegate
@superclass NSObject <UITableViewDelegate>
@abstract A default table view delegate implementation.
@discussion ￼This implementation takes care of measuring rows for you, opening URLs when the user
selects a cell, and suspending image loading to increase performance while the user is
scrolling the table.  UXTableViewController automatically assigns an instance of this
delegate class to your table, but you can override the createDelegate method there to provide
a delegate implementation of your own.
*/
@interface UXTableViewDelegate : NSObject <UITableViewDelegate> {
	UXTableViewController *_controller;
	NSMutableDictionary *_headers;
}

	@property (nonatomic, readonly) UXTableViewController *controller;

	-(id) initWithController:(UXTableViewController *)aController;

@end

#pragma mark -

@interface UXTableViewVarHeightDelegate : UXTableViewDelegate

@end

#pragma mark -

@interface UXTableViewPlainDelegate : UXTableViewDelegate

@end

#pragma mark -

@interface UXTableViewPlainVarHeightDelegate : UXTableViewVarHeightDelegate

@end

#pragma mark -

@interface UXTableViewGroupedVarHeightDelegate : UXTableViewVarHeightDelegate

@end
