
#import "MenuController.h"

@implementation MenuController

	@synthesize page = _page;
	
	-(NSString *) imageForMenuPage:(MenuPage)page {
		switch (page) {
			case MenuPageBreakfast:
				return @"87-wineglass.png";
			case MenuPageLunch:
				return @"88-beermug.png";
			case MenuPageDinner:
				return @"100-coffee.png";
			case MenuPageDessert:
				return @"34-coffee.png";
			case MenuPageAbout:
				return @"84-lightbulb.png";
			default:
				return @"";
		}
	}

	-(NSString *) nameForMenuPage:(MenuPage)page {
		switch (page) {
			case MenuPageBreakfast:
				return @"Breakfast";
			case MenuPageLunch:
				return @"Lunch";
			case MenuPageDinner:
				return @"Dinner";
			case MenuPageDessert:
				return @"Dessert";
			case MenuPageAbout:
				return @"About";
			default:
				return @"";
		}
	}

	#pragma mark NSObject

	-(id) initWithMenu:(MenuPage)page {
		if (self = [super init]) {
			self.page = page;
		}
		return self;
	}

	-(id) init {
		if (self = [super init]) {
			_page = MenuPageNone;
		}
		return self;
	}

	-(void) dealloc {
		[super dealloc];
	}


	#pragma mark UXViewController

	-(void) setPage:(MenuPage)page {
		_page		= page;
		self.title	= [self nameForMenuPage:page];
		
		UIImage *image	= [UIImage imageNamed:[self imageForMenuPage:page]];
		self.tabBarItem	= [[[UITabBarItem alloc] initWithTitle:self.title image:image tag:0] autorelease];

		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Order" 
																				   style:UIBarButtonItemStyleBordered
																				  target:@"uxnavigator://order?waitress=Betty&ref=toolbar"
																				  action:@selector(openURLFromButton:)] autorelease];
		
		if (_page == MenuPageBreakfast) {
			self.dataSource = [UXSectionedDataSource dataSourceWithObjects:
							   @"Food",
								   [UXTableTextItem itemWithText:@"Porridge" URL:@"uxnavigator://food/porridge"],
								   [UXTableTextItem itemWithText:@"Bacon & Eggs" URL:@"uxnavigator://food/baconeggs"],
								   [UXTableTextItem itemWithText:@"French Toast" URL:@"uxnavigator://food/frenchtoast"],
							   @"Drinks",
								   [UXTableTextItem itemWithText:@"Coffee" URL:@"uxnavigator://food/coffee"],
								   [UXTableTextItem itemWithText:@"Orange Juice" URL:@"uxnavigator://food/oj"],
							   @"Other",
								   [UXTableTextItem itemWithText:@"Just Desserts" URL:@"uxnavigator://menu/4"],
								   [UXTableTextItem itemWithText:@"Complaints" URL:@"uxnavigator://about/complaints"],
							   nil];
		}
		else if (_page == MenuPageLunch) {
			self.dataSource = [UXSectionedDataSource dataSourceWithObjects:
							   @"Menu",
								   [UXTableTextItem itemWithText:@"Mac & Cheese" URL:@"uxnavigator://food/macncheese"],
								   [UXTableTextItem itemWithText:@"Ham Sandwich" URL:@"uxnavigator://food/hamsam"],
								   [UXTableTextItem itemWithText:@"Salad" URL:@"uxnavigator://food/salad"],
							   @"Drinks",
								   [UXTableTextItem itemWithText:@"Coke" URL:@"uxnavigator://food/coke"],
								   [UXTableTextItem itemWithText:@"Sprite" URL:@"uxnavigator://food/sprite"],
							   @"Other",
								   [UXTableTextItem itemWithText:@"Just Desserts" URL:@"uxnavigator://menu/4"],
								   [UXTableTextItem itemWithText:@"Complaints" URL:@"uxnavigator://about/complaints"],
							   nil];
		}
		else if (_page == MenuPageDinner) {
			self.dataSource = [UXSectionedDataSource dataSourceWithObjects:
							   @"Appetizers",
								   [UXTableTextItem itemWithText:@"Potstickers" URL:@"uxnavigator://food/potstickers"],
								   [UXTableTextItem itemWithText:@"Egg Rolls" URL:@"uxnavigator://food/eggrolls"],
								   [UXTableTextItem itemWithText:@"Buffalo Wings" URL:@"uxnavigator://food/wings"],
							   @"Entrees",
								   [UXTableTextItem itemWithText:@"Steak" URL:@"uxnavigator://food/steak"],
								   [UXTableTextItem itemWithText:@"Chicken Marsala" URL:@"uxnavigator://food/marsala"],
								   [UXTableTextItem itemWithText:@"Cobb Salad" URL:@"uxnavigator://food/cobbsalad"],
								   [UXTableTextItem itemWithText:@"Green Salad" URL:@"uxnavigator://food/greensalad"],
							   @"Drinks",
								   [UXTableTextItem itemWithText:@"Red Wine" URL:@"uxnavigator://food/redwine"],
								   [UXTableTextItem itemWithText:@"White Wine" URL:@"uxnavigator://food/whitewhine"],
								   [UXTableTextItem itemWithText:@"Beer" URL:@"uxnavigator://food/beer"],
								   [UXTableTextItem itemWithText:@"Coke" URL:@"uxnavigator://food/coke"],
								   [UXTableTextItem itemWithText:@"Sparkling Water" URL:@"uxnavigator://food/coke"],
							   @"Other",
								   [UXTableTextItem itemWithText:@"Just Desserts" URL:@"uxnavigator://menu/4"],
								   [UXTableTextItem itemWithText:@"Complaints" URL:@"uxnavigator://about/complaints"],
							   nil];
		}
		else if (_page == MenuPageDessert) {
			self.dataSource = [UXSectionedDataSource dataSourceWithObjects:
							   @"Yum",
								   [UXTableTextItem itemWithText:@"Chocolate Cake" URL:@"uxnavigator://food/cake"],
								   [UXTableTextItem itemWithText:@"Apple Pie" URL:@"uxnavigator://food/pie"],
							   @"Other",
									[UXTableTextItem itemWithText:@"Complaints" URL:@"uxnavigator://about/complaints"],
							   nil];
		}
		else if (_page == MenuPageAbout) {
			self.dataSource = [UXListDataSource dataSourceWithObjects:
							   [UXTableTextItem itemWithText:@"Our Story" URL:@"uxnavigator://about/story"],
							   [UXTableTextItem itemWithText:@"Call Us" URL:@"tel:5555555"],
							   [UXTableTextItem itemWithText:@"Text Us" URL:@"sms:5555555"],
							   [UXTableTextItem itemWithText:@"Website" URL:@"http://www.melsdrive-in.com"],
							   [UXTableTextItem itemWithText:@"Complaints Dept." URL:@"uxnavigator://about/complaints"],
							   nil];
		}
	}

@end
