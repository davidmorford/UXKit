
#import "UXTableCatalogTableNavigator.h"

@implementation UXTableCatalogTableNavigator

	#pragma mark Initializer

	-(id) init {
		if (self = [super init]) {
			self.title								= @"Table Catalog";
			self.tableViewStyle						= UITableViewStyleGrouped;
			self.navigationItem.backBarButtonItem	= [[[UIBarButtonItem alloc] initWithTitle:@"Back" 
																					    style:UIBarButtonItemStyleBordered 
																					   target:nil 
																					   action:nil] autorelease];
		}
		return self;
	}

	#pragma mark UIViewController

	-(void) loadView {
		[super loadView];
	}

	-(void) viewDidLoad {
		[super viewDidLoad];
	}

	-(void) viewWillAppear:(BOOL)animated {
		[super viewWillAppear:animated];
	}

	-(void) viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];
		[self.navigationController setToolbarHidden:TRUE animated:TRUE];
	}

	-(void) viewWillDisappear:(BOOL)animated {
		[super viewWillDisappear:animated];
	}

	-(void) viewDidDisappear:(BOOL)animated {
		[super viewDidDisappear:animated];
	}

	-(void) createModel {
		self.dataSource = [UXSectionedDataSource dataSourceWithObjects:
			@"TableKit Plain",
				[UXTableTextItem itemWithText:@"Plain"				URL:@"uxtablecatalog://tvkPlainTableTest"],
				[UXTableTextItem itemWithText:@"Plain Styled"		URL:@"uxtablecatalog://tvkPlainStyledTableTest"],
				// Not ready for production use...
				//[UXTableTextItem itemWithText:@"Plain Managed"		URL:@"uxtablecatalog://tvkPlainManagedStyledTableTest"],

			@"TableKit Grouped",
				[UXTableTextItem itemWithText:@"Grouped"			URL:@"uxtablecatalog://tvkGroupedTableTest"],
				[UXTableTextItem itemWithText:@"Grouped Styled"		URL:@"uxtablecatalog://tvkGroupedStyledTableTest"],

			/*
			@"Managed Editors",
				[UXTableTextItem itemWithText:@"Typed Editors"		URL:@"uxtablecatalog://listEditorTableTest"],
			*/
			nil];
	}

	#pragma mark Destructor

	-(void) dealloc {
		[super dealloc];
	}

@end
