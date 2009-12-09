
#import "___PROJECTNAMEASIDENTIFIER___TabBarNavigator.h"

@implementation ___PROJECTNAMEASIDENTIFIER___TabBarNavigator

	#pragma mark Initializer

	-(id) init {
		if (self = [super init]) {
			self.delegate = self;
		}
		return self;
	}


	#pragma mark UIViewController

	-(void) loadView {
		[super loadView];
	}

	-(void) viewDidLoad {
		[super viewDidLoad];
		[self setTabURLs:[NSArray arrayWithObjects:@"___PROJECTNAMEASIDENTIFIER___://tableNavigator",
												   @"___PROJECTNAMEASIDENTIFIER___://tableNavigator", 
												   nil]];
	}

	-(void) viewWillAppear:(BOOL)animated {
		[super viewWillAppear:animated];
	}

	-(void) viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];
	}

	-(void) viewWillDisappear:(BOOL)animated {
		[super viewWillDisappear:animated];
	}

	-(void) viewDidDisappear:(BOOL)animated {
		[super viewDidDisappear:animated];
	}


	#pragma mark <UITabBarControllerDelegate>

	-(BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
		return TRUE;
	}

	-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
	
	}

	-(void) tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray *)viewControllers {
	
	}

	-(void) tabBarController:(UITabBarController *)tabBarController willEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
	
	}

	-(void) tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
	
	}


	#pragma mark Memory

	-(void) viewDidUnload {
		[super viewDidUnload];
	}

	-(void) didReceiveMemoryWarning {
		[super didReceiveMemoryWarning];
	}

	-(void) dealloc {
		[super dealloc];
	}

@end
