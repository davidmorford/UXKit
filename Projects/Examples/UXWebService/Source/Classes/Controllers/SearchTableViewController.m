
#import "SearchTableViewController.h"
#import "SearchResultsTableDataSource.h"
#import "SearchResultsModel.h"

@implementation SearchTableViewController

	-(id) init {
		if ((self = [super init])) {
			self.title	= @"Table Example";
			
			// Initialize our UXTableViewDataSource and our UXModel.
			id <UXTableViewDataSource> ds	= [SearchResultsTableDataSource dataSourceWithItems:nil];
			ds.model						= CreateSearchModelWithCurrentSettings();
			
			/*
			By setting the dataSource property, the model property for this class (SearchTableViewController) 
			will automatically be hooked up to point at the same model that the dataSource points at, which 
			we just instantiated above.
			*/
			self.dataSource = ds;
		}
		return self;
	}


	#pragma mark UIViewController

	-(void) loadView {
		[super loadView];
		self.tableView.rowHeight		= 80.f;
		self.tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		
		[self.view addSubview:self.tableView];
		
		UISearchBar *searchBar			= [[UISearchBar alloc] initWithFrame:CGRectMake(0.f, 0.f, UXApplicationFrame().size.width, UX_ROW_HEIGHT)];
		searchBar.delegate				= self;
		searchBar.placeholder			= @"Image Search";
		self.navigationItem.titleView	= searchBar;
		[searchBar release];
	}


	#pragma mark UXViewController

	-(UIImage *) imageForError:(NSError *)error {
		return [UIImage imageNamed:@"UXKit.bundle/Images/Navigation/error.png"];
	}


	#pragma mark UISearchBarDelegate

	/*
	Configure our UXModel with the user's search terms and tell the UXModelViewController to reload.
	*/
	-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
		[searchBar resignFirstResponder];
		[(id <SearchResultsModel>)self.model setSearchTerms:[searchBar text]];
		[self reload];
		[self.tableView scrollToTop:YES];
	}

@end
