
#import "___PROJECTNAMEASIDENTIFIER___TableNavigator.h"

@implementation ___PROJECTNAMEASIDENTIFIER___TableNavigator

	#pragma mark Initializer

	-(id) init {
		if (self = [super init]) {
			self.title								= @"___PROJECTNAMEASIDENTIFIER___";
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
			@"",
				[UXTableTextItem itemWithText:@"..."		URL:@"___PROJECTNAMEASIDENTIFIER___://"],
			nil];
	}

	#pragma mark Destructor

	-(void) dealloc {
		[super dealloc];
	}

@end
