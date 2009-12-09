
#import "TabButtonBarTestController.h"

@implementation TabButtonBarStyleSheet

	-(UXStyle *) greenTabBarButton:(UIControlState)state {
		UXShape *shape		= [UXRectangleShape shape];
		UIColor *tintColor	= [UIColor colorWithHue:(90.0/360.0) saturation:(100.0/100.0) brightness:(100.0/100.0) alpha:1.0];
		return [UXSTYLESHEET toolbarButtonForState:state shape:shape tintColor:tintColor font:nil];
	}

	-(UIColor *) tabBackgroundTintColor {
		return RGBCOLOR(64, 64, 64);
	}

@end

#pragma mark -

@implementation TabButtonBarTestController

	-(id) init {
		if (self = [super init]) {
			[UXStyleSheet setGlobalStyleSheet:[[[TabButtonBarStyleSheet alloc] init] autorelease]];
		}
		return self;
	}

	#pragma mark UIViewController

	-(void) loadView {
		self.view = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
		self.view.backgroundColor = UXSTYLESHEETPROPERTY(tabBackgroundTintColor);
		
		tabButtonBar = [[UXTabButtonBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
		tabButtonBar.tabItems = [NSArray arrayWithObjects:
							 [[[UXTabItem alloc] initWithTitle:@"Tab 1"] autorelease],
							 [[[UXTabItem alloc] initWithTitle:@"Tab 2"] autorelease],
							 [[[UXTabItem alloc] initWithTitle:@"Tab 3"] autorelease],
							 nil];
		tabButtonBar.tabStyle	= @"greenTabBarButton:";
		tabButtonBar.delegate	= self;
		UXTabItem *item			= [tabButtonBar.tabItems objectAtIndex:1];
		item.badgeNumber		= 2;
		[self.view addSubview:tabButtonBar];
	}
	
	-(void) tabBar:(UXTabBar *)tabBar tabSelected:(NSInteger)selectedIndex {
		NSLog(@"Selected Tab Index = %u", selectedIndex);
	}

	-(void) dealloc {
		[UXStyleSheet setGlobalStyleSheet:nil];
		[super dealloc];
	}

@end
