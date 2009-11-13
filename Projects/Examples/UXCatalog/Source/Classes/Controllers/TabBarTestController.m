
#import "TabBarTestController.h"

@implementation TabBarTestController

	-(void) loadView {
		self.view = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
		self.view.backgroundColor = UXSTYLEVAR(tabTintColor);
		
		_tabBar1 = [[UXTabStrip alloc] initWithFrame:CGRectMake(0, 0, 320, 41)];
		_tabBar1.tabItems = [NSArray arrayWithObjects:
							 [[[UXTabItem alloc] initWithTitle:@"Item 1"] autorelease],
							 [[[UXTabItem alloc] initWithTitle:@"Item 2"] autorelease],
							 [[[UXTabItem alloc] initWithTitle:@"Item 3"] autorelease],
							 [[[UXTabItem alloc] initWithTitle:@"Item 4"] autorelease],
							 [[[UXTabItem alloc] initWithTitle:@"Item 5"] autorelease],
							 [[[UXTabItem alloc] initWithTitle:@"Item 6"] autorelease],
							 [[[UXTabItem alloc] initWithTitle:@"Item 7"] autorelease],
							 [[[UXTabItem alloc] initWithTitle:@"Item 8"] autorelease],
							 [[[UXTabItem alloc] initWithTitle:@"Item 9"] autorelease],
							 [[[UXTabItem alloc] initWithTitle:@"Item 10"] autorelease],
							 nil];
		[self.view addSubview:_tabBar1];
		
		_tabBar2 = [[UXTabBar alloc] initWithFrame:CGRectMake(0, _tabBar1.bottom, 320, 40)];
		_tabBar2.tabItems = [NSArray arrayWithObjects:
							 [[[UXTabItem alloc] initWithTitle:@"Banana"] autorelease],
							 [[[UXTabItem alloc] initWithTitle:@"Cherry"] autorelease],
							 [[[UXTabItem alloc] initWithTitle:@"Orange"] autorelease],
							 [[[UXTabItem alloc] initWithTitle:@"Grape"] autorelease],
							 nil];
		_tabBar2.selectedTabIndex = 2;
		[self.view addSubview:_tabBar2];
		
		UXTabItem *item = [_tabBar2.tabItems objectAtIndex:1];
		item.badgeNumber = 2;
		
		_tabBar3 = [[UXTabGrid alloc] initWithFrame:CGRectMake(10, _tabBar2.bottom + 10, 300, 0)];
		_tabBar3.backgroundColor = [UIColor clearColor];
		_tabBar3.tabItems = [NSArray arrayWithObjects:
							 [[[UXTabItem alloc] initWithTitle:@"Banana"] autorelease],
							 [[[UXTabItem alloc] initWithTitle:@"Cherry"] autorelease],
							 [[[UXTabItem alloc] initWithTitle:@"Orange"] autorelease],
							 [[[UXTabItem alloc] initWithTitle:@"Pineapple"] autorelease],
							 [[[UXTabItem alloc] initWithTitle:@"Grape"] autorelease],
							 [[[UXTabItem alloc] initWithTitle:@"Mango"] autorelease],
							 [[[UXTabItem alloc] initWithTitle:@"Blueberry"] autorelease],
							 [[[UXTabItem alloc] initWithTitle:@"Apple"] autorelease],
							 [[[UXTabItem alloc] initWithTitle:@"Peach"] autorelease],
							 nil];
		[_tabBar3 sizeToFit];
		[self.view addSubview:_tabBar3];
	}

	-(void)dealloc {
		UX_SAFE_RELEASE(_tabBar1);
		UX_SAFE_RELEASE(_tabBar2);
		UX_SAFE_RELEASE(_tabBar3);
		[super dealloc];
	}

@end
