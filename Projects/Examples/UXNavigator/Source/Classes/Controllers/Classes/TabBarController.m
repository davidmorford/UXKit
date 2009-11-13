
#import "TabBarController.h"

@implementation TabBarController

	#pragma mark UIViewController

	-(void) viewDidLoad {
		[self setTabURLs:[NSArray arrayWithObjects:@"uxnavigator://menu/1",
												   @"uxnavigator://menu/2",
												   @"uxnavigator://menu/3",
												   @"uxnavigator://menu/4",
												   @"uxnavigator://menu/5", nil]];
	}

@end
