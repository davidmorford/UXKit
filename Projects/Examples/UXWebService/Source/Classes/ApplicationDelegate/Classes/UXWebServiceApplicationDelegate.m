
#import "UXWebServiceApplicationDelegate.h"
#import "WebServiceMenuController.h"
#import "SearchTableViewController.h"
#import "SearchPhotosViewController.h"

@implementation UXWebServiceApplicationDelegate

	-(void) applicationDidFinishLaunching:(UIApplication *)application {
		/*
		Allow HTTP response size to be unlimited.
		*/
		[[UXURLRequestQueue mainQueue] setMaxContentLength:0];
		
		/*
		Configure the in-memory image cache to keep approximately 10 images in memory, 
		assuming that each picture's dimensions are 320x480. Note that your images can 
		have whatever dimensions you want, I am just setting this to a reasonable value
		since the default is unlimited.
		*/
		[[UXURLCache sharedCache] setMaxPixelCount:(10 * 320 * 480)];

		UXNavigator *navigator			= [UXNavigator navigator];
		navigator.persistenceMode		= UXNavigatorPersistenceModeAll;
		UXURLMap *map					= navigator.URLMap;
		
		[map from:@"uxwebservice://mainMenu"	toViewController:[WebServiceMenuController class]];
		[map from:@"uxwebservice://flickSearch" toViewController:[SearchTableViewController class]];
		[map from:@"uxwebservice://yahooSearch" toViewController:[SearchPhotosViewController class]];
		if (![navigator restoreViewControllers]) {
			[navigator openURL:@"uxwebservice://mainMenu" animated:NO];
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
