
#import "___PROJECTNAMEASIDENTIFIER___ApplicationDelegate.h"
#import "___PROJECTNAMEASIDENTIFIER___TableNavigator.h"
#import "___PROJECTNAMEASIDENTIFIER___LaunchNavigator.h"

@implementation ___PROJECTNAMEASIDENTIFIER___ApplicationDelegate

	#pragma mark <UIApplicationDelegate>

	-(void) applicationDidFinishLaunching:(UIApplication *)application {
		UXNavigator *navigator			= [UXNavigator navigator];
		navigator.persistenceMode		= UXNavigatorPersistenceModeNone;
		UXURLMap *map					= navigator.URLMap;

		[map from:@"*" toViewController:[UXWebController class]];
		[map from:@"___PROJECTNAMEASIDENTIFIER___://tableNavigator"  toSharedViewController:[___PROJECTNAMEASIDENTIFIER___TableNavigator class]];
		[map from:@"___PROJECTNAMEASIDENTIFIER___://launchNavigator" toViewController:[___PROJECTNAMEASIDENTIFIER___LaunchNavigator class]];
		
		if (![navigator restoreViewControllers]) {
			[navigator openURL:@"___PROJECTNAMEASIDENTIFIER___://tableNavigator" animated:FALSE];
		}
	}

	-(BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)aURL {
		[[UXNavigator navigator] openURL:aURL.absoluteString animated:FALSE];
		return TRUE;
	}

	-(void) dealloc {
		[super dealloc];
	}

@end
