
/*!
@project	UXKit
@header     UXLauncherView.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXGlobal.h>

@protocol UXLauncherViewDelegate;
@class UXPageControl, UXLauncherButton, UXLauncherItem;

/*!
@class UXLauncherView
@superclass UIView <UIScrollViewDelegate>
@abstract
@discussion
*/
@interface UXLauncherView : UIView <UIScrollViewDelegate> {
	id <UXLauncherViewDelegate> _delegate;
	NSMutableArray *_pages;
	NSInteger _columnCount;
	NSInteger _rowCount;
	NSString *_prompt;
	NSMutableArray *_buttons;
	UIScrollView *_scrollView;
	UXPageControl *_pager;
	NSTimer *_editHoldTimer;
	NSTimer *_springLoadTimer;
	UXLauncherButton *_dragButton;
	UITouch *_dragTouch;
	NSInteger _positionOrigin;
	CGPoint _dragOrigin;
	CGPoint _touchOrigin;
	BOOL _editing;
	BOOL _springing;
}

	@property (nonatomic, assign) id <UXLauncherViewDelegate> delegate;
	@property (nonatomic, copy) NSArray *pages;
	@property (nonatomic) NSInteger columnCount;
	@property (nonatomic, readonly) NSInteger rowCount;
	@property (nonatomic) NSInteger currentPageIndex;
	@property (nonatomic, copy) NSString *prompt;
	@property (nonatomic, readonly) BOOL editing;

	-(void) addItem:(UXLauncherItem *)item animated:(BOOL)animated;
	-(void) removeItem:(UXLauncherItem *)item animated:(BOOL)animated;
	
	-(UXLauncherItem *) itemWithURL:(NSString *)URL;
	-(NSIndexPath *) indexPathOfItem:(UXLauncherItem *)item;
	-(void) scrollToItem:(UXLauncherItem *)item animated:(BOOL)animated;
	
	-(void) beginEditing;
	-(void) endEditing;

@end

#pragma mark -

/*!
@protocol UXLauncherViewDelegate <NSObject>
@abstract
*/
@protocol UXLauncherViewDelegate <NSObject>

@optional
	-(void) launcherView:(UXLauncherView *)launcher didAddItem:(UXLauncherItem *)item;
	-(void) launcherView:(UXLauncherView *)launcher didRemoveItem:(UXLauncherItem *)item;
	-(void) launcherView:(UXLauncherView *)launcher didMoveItem:(UXLauncherItem *)item;
	-(void) launcherView:(UXLauncherView *)launcher didSelectItem:(UXLauncherItem *)item;

	-(void) launcherViewDidBeginEditing:(UXLauncherView *)launcher;
	-(void) launcherViewDidEndEditing:(UXLauncherView *)launcher;

@end
