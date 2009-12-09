
#import "UXCatalogApplicationDelegate.h"
#import "UXCatalogController.h"

#import "PhotoTest1Controller.h"
#import "PhotoTest2Controller.h"
#import "ImageTest1Controller.h"
#import "ScrollViewTestController.h"

#import "TableImageTestController.h"
#import "TableItemTestController.h"
#import "TableControlsTestController.h"
#import "TableTestController.h"
#import "SearchTestController.h"

#import "StyleTestController.h"
#import "StyledTextTestController.h"
#import "StyledTextTableTestController.h"
#import "StyledTextTestViewController.h"

#import "LauncherViewTestController.h"
#import "LauncherViewSplashController.h"

#import "ActivityTestController.h"
#import "ButtonTestController.h"
#import "CalendarTestController.h"
#import "TabBarTestController.h"
#import "TabButtonBarTestController.h"

#import "MessageTestController.h"
#import "TextBarTestController.h"

#import "PanelTestController.h"

@implementation UXCatalogApplicationDelegate

	#pragma mark <UIApplicationDelegate>

	-(void) applicationDidFinishLaunching:(UIApplication *)application {
		UXNavigator *navigator			= [UXNavigator navigator];
		navigator.persistenceMode		= UXNavigatorPersistenceModeAll;
		
		UXURLMap *map					= navigator.URLMap;
		
		[map from:@"*" toViewController:[UXWebController class]];
		[map from:@"uxcatalog://catalog"			toViewController:[UXCatalogController class]];
		[map from:@"uxcatalog://photoTest1"			toViewController:[PhotoTest1Controller class]];
		[map from:@"uxcatalog://photoTest2"			toViewController:[PhotoTest2Controller class]];
		[map from:@"uxcatalog://imageTest1"			toViewController:[ImageTest1Controller class]];
		[map from:@"uxcatalog://tableTest"			toViewController:[TableTestController class]];
		[map from:@"uxcatalog://tableItemTest"		toViewController:[TableItemTestController class]];
		[map from:@"uxcatalog://tableControlsTest"	toViewController:[TableControlsTestController class]];
		[map from:@"uxcatalog://styledTextTableTest"	toViewController:[StyledTextTableTestController class]];
		[map from:@"uxcatalog://composerTest"		toViewController:[MessageTestController class]];
		[map from:@"uxcatalog://textBarTest"		toViewController:[TextBarTestController class]];
		[map from:@"uxcatalog://searchTest"			toViewController:[SearchTestController class]];
		[map from:@"uxcatalog://activityTest"		toViewController:[ActivityTestController class]];
		[map from:@"uxcatalog://styleTest"			toViewController:[StyleTestController class]];
		[map from:@"uxcatalog://styledTextTest"		toViewController:[StyledTextTestController class]];
		[map from:@"uxcatalog://buttonTest"			toViewController:[ButtonTestController class]];
		[map from:@"uxcatalog://tabBarTest"			toViewController:[TabBarTestController class]];
		[map from:@"uxcatalog://imageTest2"			toViewController:[TableImageTestController class]];
		[map from:@"uxcatalog://scrollViewTest"		toViewController:[ScrollViewTestController class]];
		[map from:@"uxcatalog://launcherTest"		toViewController:[LauncherViewTestController class]];
		[map from:@"uxcatalog://launcherSplashTest"		toViewController:[LauncherViewSplashController class]];  
		[map from:@"uxcatalog://tabButtonBarTest"	toViewController:[TabButtonBarTestController class]];
		[map from:@"uxcatalog://calendarTest"		toViewController:[CalendarTestController class]];
		[map from:@"uxcatalog://panelTest"			toViewController:[PanelTestController class]];
		[map from:@"uxcatalog://styledTextControllerTest"	toViewController:[StyledTextTestViewController class]];
		[map from:@"uxcatalog://panel"				toViewController:[UXInputPanelController class]];
		
		if (![navigator restoreViewControllers]) {
			[navigator openURL:@"uxcatalog://catalog" animated:NO];
		}
	}

	-(BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)aURL {
		[[UXNavigator navigator] openURL:aURL.absoluteString animated:NO];
		return YES;
	}

	-(void) dealloc {
		[super dealloc];
	}

@end
