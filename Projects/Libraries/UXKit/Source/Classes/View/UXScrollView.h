
/*!
@project	UXKit
@header     UXScrollView.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXGlobal.h>

@protocol UXScrollViewDelegate;
@protocol UXScrollViewDataSource;

/*!
@class UXScrollView
@superclass UIView
@abstract
@discussion
*/
@interface UXScrollView : UIView {
	id <UXScrollViewDelegate> _delegate;
	id <UXScrollViewDataSource> _dataSource;
	NSInteger _centerPageIndex;
	NSInteger _visiblePageIndex;
	BOOL _scrollEnabled;
	BOOL _zoomEnabled;
	BOOL _rotateEnabled;
	CGFloat _pageSpacing;
	UIInterfaceOrientation _orientation;
	NSTimeInterval _holdsAfterTouchingForInterval;
	NSMutableArray *_pages;
	NSMutableArray *_pageQueue;
	NSInteger _maxPages;
	NSInteger _pageArrayIndex;
	NSTimer *_tapTimer;
	NSTimer *_holdingTimer;
	NSTimer *_animationTimer;
	NSDate *_animationStartTime;
	NSTimeInterval _animationDuration;
	UIEdgeInsets _animateEdges;
	UIEdgeInsets _pageEdges;
	UIEdgeInsets _pageStartEdges;
	UIEdgeInsets _touchEdges;
	UIEdgeInsets _touchStartEdges;
	NSUInteger _touchCount;
	CGFloat _overshoot;
	UITouch *_touch1;
	UITouch *_touch2;
	BOOL _dragging;
	BOOL _zooming;
	BOOL _holding;
}

	@property (nonatomic, assign) id <UXScrollViewDelegate> delegate;
	@property (nonatomic, assign) id <UXScrollViewDataSource> dataSource;
	
	@property (nonatomic) NSInteger centerPageIndex;
	
	@property (nonatomic, readonly) BOOL zoomed;
	@property (nonatomic, readonly) BOOL holding;

	@property (nonatomic) BOOL scrollEnabled;
	@property (nonatomic) BOOL zoomEnabled;
	@property (nonatomic) BOOL rotateEnabled;

	@property (nonatomic) CGFloat pageSpacing;
	@property (nonatomic) UIInterfaceOrientation orientation;
	@property (nonatomic) NSTimeInterval holdsAfterTouchingForInterval;

	@property (nonatomic, readonly) NSInteger numberOfPages;
	
	@property (nonatomic, readonly) UIView *centerPage;
	
	/*!
	@abstract A dictionary of visible pages keyed by the index of the page.
	*/
	@property (nonatomic, readonly) NSDictionary *visiblePages;

	-(void) setOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated;

	/*!
	@abstract Gets a previously created page view that has been moved off screen and recycled.
	*/
	-(UIView *) dequeueReusablePage;

	-(void) reloadData;
	-(UIView *) pageAtIndex:(NSInteger)aPageIndex;
	-(void) zoomToFit;
	-(void) zoomToDistance:(CGFloat)aDistance;

	/*!
	@abstract Cancels any active touches and resets everything to an untouched state.
	*/
	-(void) cancelTouches;

@end

#pragma mark -

/*!
@protocol UXScrollViewDelegate <NSObject>
@abstract
*/
@protocol UXScrollViewDelegate <NSObject>

	-(void) scrollView:(UXScrollView *)scrollView didMoveToPageAtIndex:(NSInteger)pageIndex;

@optional
	-(void) scrollViewWillRotate:(UXScrollView *)scrollView toOrientation:(UIInterfaceOrientation)orientation;
	-(void) scrollViewDidRotate:(UXScrollView *)scrollView;
	-(void) scrollViewWillBeginDragging:(UXScrollView *)scrollView;
	-(void) scrollViewDidEndDragging:(UXScrollView *)scrollView willDecelerate:(BOOL)willDecelerate;
	-(void) scrollViewDidEndDecelerating:(UXScrollView *)scrollView;
	-(BOOL) scrollViewShouldZoom:(UXScrollView *)scrollView;
	-(void) scrollViewDidBeginZooming:(UXScrollView *)scrollView;
	-(void) scrollViewDidEndZooming:(UXScrollView *)scrollView;
	-(void) scrollView:(UXScrollView *)scrollView touchedDown:(UITouch *)touch;
	-(void) scrollView:(UXScrollView *)scrollView touchedUpInside:(UITouch *)touch;
	-(void) scrollView:(UXScrollView *)scrollView tapped:(UITouch *)touch;
	-(void) scrollViewDidBeginHolding:(UXScrollView *)aScrollView;
	-(void) scrollViewDidEndHolding:(UXScrollView *)aScrollView;

@optional
	-(BOOL) scrollView:(UXScrollView *)aScrollView shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation;

@end

#pragma mark -

/*!
@protocol UXScrollViewDataSource <NSObject>
@abstract
*/
@protocol UXScrollViewDataSource <NSObject>

	-(NSInteger) numberOfPagesInScrollView:(UXScrollView *)scrollView;

	/*!
	@abstract Gets a view to display for the page at the given index.
	@discussion You do not need to position or size the view as that is done for you later.
	You should call dequeueReusablePage first, and only create a new view if it returns nil.
	*/
	-(UIView *) scrollView:(UXScrollView *)scrollView pageAtIndex:(NSInteger)pageIndex;

	/*!
	@abstract Gets the natural size of the page.
	@discussion The actual width and height are not as important as the ratio between width 
	and height. This is used to determine how to
	*/
	-(CGSize) scrollView:(UXScrollView *)scrollView sizeOfPageAtIndex:(NSInteger)pageIndex;

@end
