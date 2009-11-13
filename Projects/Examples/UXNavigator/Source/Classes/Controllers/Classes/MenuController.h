
/*!
@project    
@header     MenuController.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXKit.h>

typedef NSUInteger MenuPage;
enum {
	MenuPageNone,
	MenuPageBreakfast,
	MenuPageLunch,
	MenuPageDinner,
	MenuPageDessert,
	MenuPageAbout,
};

@interface MenuController : UXTableViewController {
	MenuPage _page;
}

	@property (nonatomic) MenuPage page;

@end
