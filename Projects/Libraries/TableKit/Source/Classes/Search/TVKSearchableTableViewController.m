
#import <TableKit/TVKSearchableTableViewController.h>

@implementation TVKSearchableTableViewController

	@synthesize searchDisplayController;
	@synthesize searchScopeTitles
	@synthesize searchBar;
	
	@synthesize savedSearchTerm;
	@synthesize savedScopeButtonIndex;
	@synthesize searchWasActive;

	#pragma mark Initializer

	-(id) init {
		self = [super init];
		if (self) {
		}
		return self;
	}

	-(id) initWithSearchBar:(UISearchBar *)searchBar contentsController:(UIViewController *)controller {
		if (self = [super initWithSearchBar:searchBar contentsController:controller]) {
			self.delegate = self;
		}
		return self;
	}
	
	#pragma mark UIViewController

	-(void) loadView {
		[super loadView];
		self.searchBar = [[UISearchBar alloc] init];
		self.searchBar.autoresizingMask	= (UIViewAutoresizingFlexibleWidth);
		[self.searchBar sizeToFit];
		self.tableView.tableHeaderView = self.searchBar;
		
		self.searchBar.scopeButtonTitles = self.searchScopeTitles;
		self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
		self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
		
		self.searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
		self.searchDisplayController.searchResultsDataSource = self.tableController;
		self.searchDisplayController.searchResultsDelegate = self.tableController;
		self.searchDisplayController.delegate = self;
	}

	-(void) viewDidLoad {
		[super viewDidLoad];
		NSError *error = nil;
		if (![[self fetchedResultsController] performFetch:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);
		}

		self.filteredResults = [NSMutableArray arrayWithCapacity:[self.fetchedResultsController.fetchedObjects count]];
		
		// restore search settings if they were saved in didReceiveMemoryWarning.
		if (self.savedSearchTerm) {
			[self.searchDisplayController setActive:self.searchWasActive];
			[self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
			[self.searchDisplayController.searchBar setText:savedSearchTerm];
			self.savedSearchTerm = nil;
		}
	}

	-(void) viewWillAppear:(BOOL)animated {
		[super viewWillAppear:animated];
	}

	-(void) viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];
	}

	-(void) viewWillDisappear:(BOOL)animated {
		[super viewWillDisappear:animated];
	}

	-(void) viewDidDisappear:(BOOL)animated {
		[super viewDidDisappear:animated];
	}

	-(void) didReceiveMemoryWarning {
		[super didReceiveMemoryWarning];
	}

	-(void) viewDidUnload {
		// Save the state of the search UI so that it can be restored if the view is re-created.
		self.searchWasActive = [self.searchDisplayController isActive];
		self.savedSearchTerm = [self.searchDisplayController.searchBar text];
		self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
		
		// destroy the UISearchDisplayController. Create a new one if the view is reloaded and point it to the new UISearchBar
		self.searchDisplayController = nil;
		self.searchScopeTitles = nil;
		self.searchBar = nil;
		self.filteredResults = nil;
	}

	#pragma mark KVO

	-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
		NSLog(@"%@ %@ %@", keyPath, object, change);
	}


	#pragma mark <UITableViewDataSource>

	-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
		NSUInteger count = 0;
		if (self.tableView == self.searchDisplayController.searchResultsTableView) {
			count = [self.filteredResults count];
		}
		else {
			return [self.tableController tableView:self.tableView numberOfRowsInSection:section];
		}
		return count;
	}

	-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
		UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
		id representedObject = nil;
		if (tableView == self.searchDisplayController.searchResultsTableView) {
			representedObject = [self.filteredResults objectAtIndex:indexPath.row];
		}
		else {
			representedObject	= [self.tableController objectAtIndexPath:indexPath];
		}
		return cell;
	}

	-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
		[super tableView:tableView didSelectRowAtIndexPath:indexPath];
		
		id representedObject = nil;
		if (tableView == self.searchDisplayController.searchResultsTableView) {
			representedObject = [self.filteredResults objectAtIndex:indexPath.row];
		}
		else {
			representedObject = [self.tableController objectAtIndexPath:indexPath];
		}
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}


	#pragma mark Content Filtering

	-(void) filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
		
		[self.filteredResults removeAllObjects];
		
		NSArray *arrangedResults = self.tableController.arrangedObjects;
		
		for (id o in self.tableController.arrangedObjects) {
			NSPredicate *predicate	= [NSPredicate predicateWithFormat:@"(SELF contains[cd] %@)", searchText];
			BOOL matchesName		= [predicate evaluateWithObject:heroName];
			BOOL matchesIdentity	= [predicate evaluateWithObject:heroIdentity];
			
			if ([scope isEqualToString:@"Name"] && matchesName) {
				[self.filteredResults addObject:hero];
			}
			if ([scope isEqualToString:@"Identity"] && matchesIdentity) {
				[self.filteredResults addObject:hero];
			}
			/*if ([scope isEqualToString:@"Any"] && (resultID || resultName)) {
				[self.filteredData addObject:hero];
			}*/
		}
	}


	#pragma mark <UISearchDisplayDelegate>

	-(void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
	
	}

	-(void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
	
	}

	-(void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
	
	}

	-(void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
	
	}

	/*!
	@abstract Called when the table is created destroyed, shown or hidden. configure as necessary.
	*/
	-(void) searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
	
	}

	-(void) searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView {
	
	}

	/*!
	@abstract Called when table is shown/hidden
	*/
	-(void) searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
	
	}

	-(void) searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView {
	
	}

	-(void) searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView {
	
	}

	-(void) searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
	
	}

	/*!
	@abstract return YES to reload table. called when search string/option changes. convenience methods on top UISearchBar delegate methods
	*/
	-(BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
		[self filterContentForSearchText:searchString 
								   scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
		// Return YES to cause the search result table view to be reloaded.
		return YES;
	}

	-(BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
		[self filterContentForSearchText:[self.searchDisplayController.searchBar text] 
								   scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
		// Return YES to cause the search result table view to be reloaded.
		return YES;
	}


	#pragma mark Memory

	-(void) dealloc {
		[super dealloc];
	}

@end
