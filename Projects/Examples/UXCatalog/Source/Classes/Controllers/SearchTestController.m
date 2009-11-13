
#import "SearchTestController.h"
#import "MockDataSource.h"

@implementation SearchTestController

	@synthesize delegate = _delegate;

	#pragma mark NSObject

	-(id) init {
		if (self = [super init]) {
			_delegate		= nil;
			self.title		= @"Search Test";
			self.dataSource = [[[MockDataSource alloc] init] autorelease];
		}
		return self;
	}

	-(void) dealloc {
		[super dealloc];
	}

	#pragma mark UIViewController

	-(void) loadView {
		[super loadView];
		
		UXTableViewController *searchController = [[[UXTableViewController alloc] init] autorelease];
		searchController.dataSource		= [[[MockSearchDataSource alloc] initWithDuration:1.5] autorelease];
		self.searchViewController		= searchController;
		self.tableView.tableHeaderView	= _searchController.searchBar;
	}

	#pragma mark UXTableViewController

	-(void) didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
		[_delegate searchTestController:self didSelectObject:object];
	}

	#pragma mark UXSearchTextFieldDelegate

	-(void) textField:(UXSearchTextField *)textField didSelectObject:(id)object {
		[_delegate searchTestController:self didSelectObject:object];
	}


@end
