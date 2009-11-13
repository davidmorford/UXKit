
#import "LauncherViewSplashController.h"

@implementation LauncherViewSplashController

	#pragma mark UIViewController

	-(void) loadView {
		[super loadView];
		_launcherView.delegate		= self;
		_launcherView.columnCount	= 4;
		_launcherView.pages = [NSArray arrayWithObjects:
								[NSArray arrayWithObjects:  [[[UXLauncherItem alloc] initWithTitle:@"Search Test"
																						     image:@"bundle://UXCatalog.png"
																							   URL:@"uxcatalog://searchTest" canDelete:YES] autorelease],
															[[[UXLauncherItem alloc] initWithTitle:@"Photo Test"
																							 image:@"bundle://UXDatacase.png"
																							   URL:@"uxcatalog://photoTest1" canDelete:YES] autorelease],
															[[[UXLauncherItem alloc] initWithTitle:@"Photo Viewer"
																							 image:@"bundle://UXStore.png"
																							   URL:@"uxcatalog://photoTest2" canDelete:YES] autorelease],
															[[[UXLauncherItem alloc] initWithTitle:@"Table Item"
																							 image:@"bundle://UXStore.png"
																							   URL:@"uxcatalog://tableItemTest" canDelete:YES] autorelease],
															[[[UXLauncherItem alloc] initWithTitle:@"Composer"
																							 image:@"bundle://UXEnvelope.png"
																							   URL:@"uxcatalog://composerTest" canDelete:YES] autorelease],
															[[[UXLauncherItem alloc] initWithTitle:@"Text Bar"
																							 image:@"bundle://UXPicker.png"
																							   URL:@"uxcatalog://textBarTest" canDelete:YES] autorelease],
															[[[UXLauncherItem alloc] initWithTitle:@"Calendar"
																							 image:@"bundle://UXCalendar.png"
																							   URL:@"uxcatalog://calendarTest" canDelete:YES] autorelease], 
															[[[UXLauncherItem alloc] initWithTitle:@"Styled Text"
																							 image:@"bundle://UXNewspaper.png" 
																							   URL:@"uxcatalog://styledTextControllerTest" canDelete:YES] autorelease],
															nil],
								nil];
	}

	#pragma mark <UXLauncherViewDelegate>

	-(void) launcherView:(UXLauncherView *)launcher didSelectItem:(UXLauncherItem *)item {
		[[UXNavigator navigator] openURL:item.URL animated:YES];
	}

	-(void) launcherViewDidBeginEditing:(UXLauncherView *)launcher {
		[self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																								  target:_launcherView 
																								  action:@selector(endEditing)] autorelease] animated:YES];
	}

	-(void) launcherViewDidEndEditing:(UXLauncherView *)launcher {
		[self.navigationItem setRightBarButtonItem:nil animated:YES];
	}
	
	-(void) dealloc {
		[super dealloc];
	}

@end
