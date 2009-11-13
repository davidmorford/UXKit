
/*!
@project	UXKit
@header		UXTabBar.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXView.h>
#import <UXKit/UXButton.h>

@class UXTabItem, UXTab, UXImageView, UXLabel;

@protocol UXTabDelegate;

/*!
@class UXTabBar
@superclass UXView
@abstract
@discussion
*/
@interface UXTabBar : UXView {
	id <UXTabDelegate> _delegate;
	NSString *_tabStyle;
	NSInteger _selectedTabIndex;
	NSArray *_tabItems;
	NSMutableArray *_tabViews;
}

	@property (nonatomic, assign) id <UXTabDelegate> delegate;
	@property (nonatomic, retain) NSArray *tabItems;
	@property (nonatomic, readonly) NSArray *tabViews;
	@property (nonatomic, copy) NSString *tabStyle;
	@property (nonatomic, assign) UXTabItem *selectedTabItem;
	@property (nonatomic, assign) UXTab *selectedTabView;
	@property (nonatomic) NSInteger selectedTabIndex;

	-(id) initWithFrame:(CGRect)frame;

	-(void) showTabAtIndex:(NSInteger)tabIndex;
	-(void) hideTabAtIndex:(NSInteger)tabIndex;

@end

#pragma mark -

/*!
@class UXTabStrip
@superclass UXTabBar
@abstract
@discussion
*/
@interface UXTabStrip : UXTabBar {
	UXView *_overflowLeft;
	UXView *_overflowRight;
	UIScrollView *_scrollView;
}

@end

#pragma mark -

/*!
@class UXTabGrid
@superclass UXTabBar
@abstract
@discussion
*/
@interface UXTabGrid : UXTabBar {
	NSInteger _columnCount;
}

	@property (nonatomic) NSInteger columnCount;

@end

#pragma mark -

/*!
@class UXTabButtonBar
@superclass UXTabBar
@abstrat
@discussion
*/
@interface UXTabButtonBar : UXTabBar {

}
 
@end

#pragma mark -

/*!
@class UXTab
@superclass UXButton
@abstract
@discussion
*/
@interface UXTab : UXButton {
	UXTabItem *_tabItem;
	UXLabel *_badge;
}

	@property (nonatomic, retain) UXTabItem *tabItem;

	-(id) initWithItem:(UXTabItem *)item tabBar:(UXTabBar *)tabBar;

@end

#pragma mark -

/*!
@class UXTabItem
@superclass NSObject
@abstract
@discussion
*/
@interface UXTabItem : NSObject {
	UXTabBar *_tabBar;
	id _object;
	NSString *_title;
	NSString *_icon;
	NSString* _selectedIcon;
	NSUInteger _badgeNumber;
}

	@property (nonatomic, retain) id object;
	@property (nonatomic, copy) NSString *title;
	@property (nonatomic, copy) NSString *icon;
	@property (nonatomic, copy) NSString *selectedIcon;
	@property (nonatomic) NSUInteger badgeNumber;

	-(id) initWithTitle:(NSString *)aTitle;

@end

#pragma mark -

/*!
@protocol UXTabDelegate <NSObject>
@abstract
*/
@protocol UXTabDelegate <NSObject>

	-(void) tabBar:(UXTabBar *)tabBar tabSelected:(NSInteger)selectedIndex;

@end
