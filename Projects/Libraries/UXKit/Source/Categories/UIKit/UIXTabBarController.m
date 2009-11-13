
#import <UXKit/UIXTabBarController.h>

@implementation UITabBarController (UIXTabBarController)

	-(UIViewController *) rootControllerForController:(UIViewController *)controller {
		if ([controller canContainControllers]) {
			return controller;
		}
		else {
			UINavigationController *navController = [[[UINavigationController alloc] init] autorelease];
			[navController pushViewController:controller animated:NO];
			return navController;
		}
	}

	#pragma mark UIViewController

	-(BOOL) canContainControllers {
		return YES;
	}

	-(UIViewController *) topSubcontroller {
		return self.selectedViewController;
	}

	-(void) addSubcontroller:(UIViewController *)controller animated:(BOOL)animated transition:(UIViewAnimationTransition)transition {
		self.selectedViewController = controller;
	}

	-(void) bringControllerToFront:(UIViewController *)controller animated:(BOOL)animated {
		self.selectedViewController = controller;
	}

	-(NSString *) keyForSubcontroller:(UIViewController *)controller {
		return nil;
	}

	-(UIViewController *) subcontrollerForKey:(NSString *)key {
		return nil;
	}

	-(void) persistNavigationPath:(NSMutableArray *)path {
		UIViewController *controller = self.selectedViewController;
		[[UXNavigator navigator] persistController:controller path:path];
	}

	#pragma mark Public

	-(void) setTabURLs:(NSArray *)URLs {
		NSMutableArray *controllers = [NSMutableArray array];
		for (NSString *URL in URLs) {
			UIViewController *controller = [[UXNavigator navigator] viewControllerForURL:URL];
			if (controller) {
				UIViewController *tabController = [self rootControllerForController:controller];
				[controllers addObject:tabController];
			}
		}
		self.viewControllers = controllers;
	}

@end
