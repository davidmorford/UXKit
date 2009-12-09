
#import "UXTableCatalogApplicationDelegate.h"
#import "UXTableCatalogApplicationCoordinator.h"

#import "UXTableCatalogTableNavigator.h"

#import "TVKGroupedTableTestController.h"
#import "TVKPlainTableTestController.h"

@implementation UXTableCatalogApplicationDelegate

	#pragma mark <UIApplicationDelegate>

	-(void) applicationDidFinishLaunching:(UIApplication *)application {
		UXNavigator *navigator			= [UXNavigator navigator];
		navigator.persistenceMode		= UXNavigatorPersistenceModeNone;
		UXURLMap *map					= navigator.URLMap;

		[map from:@"*" toViewController:[UXWebController class]];
		[map from:@"uxtablecatalog://tableNavigator"			toSharedViewController:[UXTableCatalogTableNavigator class]];
		
		[map from:@"uxtablecatalog://tvkPlainTableTest"					toViewController:[TVKPlainTableTestController class]];
		[map from:@"uxtablecatalog://tvkPlainStyledTableTest"			toViewController:[TVKPlainStyledTableTestController class]];
		//[map from:@"uxtablecatalog://tvkPlainManagedStyledTableTest"	toViewController:[TVKPlainManagedTableTestController class]];
		
		[map from:@"uxtablecatalog://tvkGroupedTableTest"		toViewController:[TVKGroupedTableTestController class]];
		[map from:@"uxtablecatalog://tvkGroupedStyledTableTest"	toViewController:[TVKGroupedStyledTableTestController class]];
		
		if (![navigator restoreViewControllers]) {
			[navigator openURL:@"uxtablecatalog://tableNavigator" animated:FALSE];
		}
		
		[UXTableCatalogApplicationCoordinator sharedCoordinator];
	}

	-(BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)aURL {
		[[UXNavigator navigator] openURL:aURL.absoluteString animated:FALSE];
		return TRUE;
	}

	-(void) dealloc {
		[super dealloc];
	}

@end
