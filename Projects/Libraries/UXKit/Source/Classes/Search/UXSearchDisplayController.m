
#import <UXKit/UXSearchDisplayController.h>
#import <UXKit/UXTableViewController.h>
#import <UXKit/UXTableViewDataSource.h>

static const NSTimeInterval kPauseInterval = 0.4;

@implementation UXSearchDisplayController

	@synthesize searchResultsViewController = _searchResultsViewController;
	@synthesize pausesBeforeSearching = _pausesBeforeSearching;

	#pragma mark SPI

	-(void) resetResults {
		if (_searchResultsViewController.model.isLoading) {
			[_searchResultsViewController.model cancel];
		}
		[_searchResultsViewController.dataSource search:nil];
		[_searchResultsViewController viewWillDisappear:NO];
		[_searchResultsViewController viewDidDisappear:NO];
		_searchResultsViewController.tableView = nil;
	}

	-(void) restartPauseTimer {
		UX_INVALIDATE_TIMER(_pauseTimer);
		_pauseTimer = [NSTimer scheduledTimerWithTimeInterval:kPauseInterval
													   target:self
													 selector:@selector(searchAfterPause)
													 userInfo:nil
													  repeats:NO];
		
	}

	-(void) searchAfterPause {
		_pauseTimer = nil;
		[_searchResultsViewController.dataSource search:self.searchBar.text];
	}


	#pragma mark Initializer

	-(id) initWithSearchBar:(UISearchBar *)searchBar contentsController:(UIViewController *)controller {
		if (self = [super initWithSearchBar:searchBar contentsController:controller]) {
			_searchResultsDelegate2			= nil;
			_searchResultsViewController	= nil;
			_pauseTimer						= nil;
			_pausesBeforeSearching			= NO;
			self.delegate					= self;
		}
		return self;
	}

	-(void) dealloc {
		UX_INVALIDATE_TIMER(_pauseTimer);
		UX_SAFE_RELEASE(_searchResultsDelegate2);
		UX_SAFE_RELEASE(_searchResultsViewController);
		[super dealloc];
	}


	#pragma mark <UISearchDisplayDelegate>

	-(void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
		self.searchContentsController.navigationItem.rightBarButtonItem.enabled = NO;
		UIView *backgroundView = [self.searchBar viewWithTag:UX_SEARCH_BAR_BACKGROUND_TAG];
		if (backgroundView) {
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:UX_FAST_TRANSITION_DURATION];
			backgroundView.alpha = 0;
			[UIView commitAnimations];
		}
		/*
		if (!self.searchContentsController.navigationController) {
			[UIView beginAnimations:nil context:nil];
			self.searchBar.superview.top -= self.searchBar.screenY - UXStatusHeight();
			[UIView commitAnimations];
		}
		*/
	}

	-(void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
		[_searchResultsViewController updateView];
	}

	-(void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
		self.searchContentsController.navigationItem.rightBarButtonItem.enabled = YES;
		UIView *backgroundView = [self.searchBar viewWithTag:UX_SEARCH_BAR_BACKGROUND_TAG];
		if (backgroundView) {
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:UX_FAST_TRANSITION_DURATION];
			backgroundView.alpha = 1;
			[UIView commitAnimations];
		}
		/*
		if (!self.searchContentsController.navigationController) {
			[UIView beginAnimations:nil context:nil];
			self.searchBar.superview.top += self.searchBar.top - UXStatusHeight();
			[UIView commitAnimations];
		}
		*/
	}

	-(void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
		[self resetResults];
	}

	-(void) searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
	
	}

	-(void) searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView {
	
	}

	-(void) searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView {
		_searchResultsViewController.tableView = tableView;
		[_searchResultsViewController viewWillAppear:NO];
		[_searchResultsViewController viewDidAppear:NO];
	}

	-(void) searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView {
		[self resetResults];
	}

	-(BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
		if (_pausesBeforeSearching) {
			[self restartPauseTimer];
		}
		else {
			[_searchResultsViewController.dataSource search:searchString];
		}
		return NO;
	}

	-(BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
		[_searchResultsViewController invalidateModel];
		[_searchResultsViewController.dataSource search:self.searchBar.text];
		return NO;
	}


	#pragma mark API

	-(void) setSearchResultsDelegate:(id <UITableViewDelegate>)searchResultsDelegate {
		[super setSearchResultsDelegate:searchResultsDelegate];
		if (_searchResultsDelegate2 != searchResultsDelegate) {
			[_searchResultsDelegate2 release];
			_searchResultsDelegate2 = [searchResultsDelegate retain];
		}
	}

@end
