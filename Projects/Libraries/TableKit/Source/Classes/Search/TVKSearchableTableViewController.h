
/*!
@project    TableKit
@header     TVKSearchableTableViewController.h
@copyright  (c) 2009 - Semantap
@author     david [at] semantap.com
@created    
*/

#import <UIKit/UIKit.h>
#import <TableKit/TVKTableViewController.h>

/*!
@class TVKSearchableTableViewController
@abstract
@discussion
*/
@interface TVKSearchableTableViewController : TVKTableViewController <UISearchDisplayDelegate, UISearchBarDelegate> {
    UISearchDisplayController *searchDisplayController;
	NSArray *searchScopeTitles;
	UISearchBar *searchBar;
	NSMutableArray *filteredResults;
	NSString *savedSearchTerm;
	NSInteger savedScopeButtonIndex;
	BOOL searchWasActive;
}

	@property (nonatomic, retain) UISearchDisplayController *searchDisplayController;
	@property (nonatomic, retain) NSArray *searchScopeTitles;
	@property (nonatomic, retain) UISearchBar *searchBar;

	@property (nonatomic, copy) NSString *savedSearchTerm;
	@property (nonatomic) NSInteger savedScopeButtonIndex;
	@property (nonatomic) BOOL searchWasActive;

@end
