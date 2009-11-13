
#import "WebServiceMenuController.h"

@implementation WebServiceMenuController

	#pragma mark Initializer

	-(id) init {
		if (self = [super init]) {
			self.title								= @"Web Services";
			self.navigationItem.backBarButtonItem	= [[[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];
			self.tableViewStyle						= UITableViewStyleGrouped;
		}
		return self;
	}

	#pragma mark UXModelViewController

	-(void) createModel {
		self.dataSource = [UXSectionedDataSource dataSourceWithObjects:
			@"Photos",
				[UXTableTextItem itemWithText:@"Flickr"		URL:@"uxwebservice://flickSearch"],
				[UXTableTextItem itemWithText:@"Yahoo"		URL:@"uxwebservice://yahooSearch"],
			nil];
	}

@end
