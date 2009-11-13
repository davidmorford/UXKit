
#import "UXCatalogController.h"

@implementation UXCatalogController

	#pragma mark Initializer

	-(id) init {
		if (self = [super init]) {
			self.title								= @"Catalog";
			self.navigationItem.backBarButtonItem	= [[[UIBarButtonItem alloc] initWithTitle:@"Catalog" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];
			self.tableViewStyle						= UITableViewStyleGrouped;
		}
		return self;
	}
	
	-(void) dealloc {
		[super dealloc];
	}


	#pragma mark UXModelViewController

	-(void) createModel {
		self.dataSource = [UXSectionedDataSource dataSourceWithObjects:
			@"Launcher",
				[UXTableTextItem itemWithText:@"Launcher"			URL:@"uxcatalog://launcherTest"],
				[UXTableTextItem itemWithText:@"Launcher w/ Splash" URL:@"uxcatalog://launcherSplashTest"],

			@"Photos",
				[UXTableTextItem itemWithText:@"Photo Browser"		URL:@"uxcatalog://photoTest1"],
				[UXTableTextItem itemWithText:@"Photo Thumbnails"	URL:@"uxcatalog://photoTest2"],

			@"Styles",
				[UXTableTextItem itemWithText:@"View Styles"		URL:@"uxcatalog://styleTest"],
			
			@"Styled Text",
				[UXTableTextItem itemWithText:@"Styled Labels"		URL:@"uxcatalog://styledTextTest"],
				[UXTableTextItem itemWithText:@"Styled Text"		URL:@"uxcatalog://styledTextControllerTest"],

			@"Tabs",
				[UXTableTextItem itemWithText:@"Tabs"				URL:@"uxcatalog://tabBarTest"],
				[UXTableTextItem itemWithText:@"Tab Button Bar"		URL:@"uxcatalog://tabButtonBarTest"],

			@"Controls",
				[UXTableTextItem itemWithText:@"Buttons"			URL:@"uxcatalog://buttonTest"],
				[UXTableTextItem itemWithText:@"Activity Labels"	URL:@"uxcatalog://activityTest"],

			@"Composers", 
				[UXTableTextItem itemWithText:@"Text Bar"			URL:@"uxcatalog://textBarTest"],
				[UXTableTextItem itemWithText:@"Composers"			URL:@"uxcatalog://composerTest"],

			@"Panels",
				[UXTableTextItem itemWithText:@"Input Panel"		URL:@"uxcatalog://panelTest"],

			@"Table",
				[UXTableTextItem itemWithText:@"Table Items"		URL:@"uxcatalog://tableItemTest"],
				[UXTableTextItem itemWithText:@"Table Controls"		URL:@"uxcatalog://tableControlsTest"],
				[UXTableTextItem itemWithText:@"Table Style Labels"	URL:@"uxcatalog://styledTextTableTest"],
				[UXTableTextItem itemWithText:@"Table Web Images"	URL:@"uxcatalog://imageTest2"],

			@"Model",
				[UXTableTextItem itemWithText:@"Search"				URL:@"uxcatalog://searchTest"],
				[UXTableTextItem itemWithText:@"Model State"		URL:@"uxcatalog://tableTest"],

			@"Containers",
				[UXTableTextItem itemWithText:@"Scroll View"		URL:@"uxcatalog://scrollViewTest"],

			@"Web",
				[UXTableTextItem itemWithText:@"Web Image"			URL:@"uxcatalog://imageTest1"],
				[UXTableTextItem itemWithText:@"Web Browser"		URL:@"http://semantap.com"],

			@"Calendar",
				[UXTableTextItem itemWithText:@"Calendar"			URL:@"uxcatalog://calendarTest"],
			nil];
	}

@end
