
#import "___PROJECTNAMEASIDENTIFIER___ApplicationDelegate.h"
#import "___PROJECTNAMEASIDENTIFIER___TabBarNavigator.h"
#import "___PROJECTNAMEASIDENTIFIER___TableNavigator.h"

@implementation ___PROJECTNAMEASIDENTIFIER___ApplicationDelegate

	#pragma mark <UIApplicationDelegate>

	-(void) applicationDidFinishLaunching:(UIApplication *)application {
		UXNavigator *navigator			= [UXNavigator navigator];
		navigator.persistenceMode		= UXNavigatorPersistenceModeNone;
		UXURLMap *map					= navigator.URLMap;

		[map from:@"*" toViewController:[UXWebController class]];
		[map from:@"___PROJECTNAMEASIDENTIFIER___://tabBarNavigator" toSharedViewController:[___PROJECTNAMEASIDENTIFIER___TabBarNavigator class]];
		[map from:@"___PROJECTNAMEASIDENTIFIER___://tableNavigator"  toViewController:[___PROJECTNAMEASIDENTIFIER___TableNavigator class]];
		
		if (![navigator restoreViewControllers]) {
			[navigator openURL:@"___PROJECTNAMEASIDENTIFIER___://tabBarNavigator" animated:FALSE];
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
