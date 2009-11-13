
/*!
@project	UXKit
@header		UXCalendarGridView.h
@copyright  (c) 2009 Keith Lazuka
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXView.h>

@class UXCalendarTileView, UXCalendarLogic;
@protocol UXCalendarViewDelegate;

/*!
@class UXCalendarGridView 
@superclass  UXView
@abstract A client of the UXCalendar system you should not need to use 
this class directly (it is managed by UXCalendarView).
@discussion Each |cell| is a UXView, and each cell's width is the full width 
of the UXCalendarGridView. In other words, the cell represents a week in the calendar.
One cell (week) can optionally be kept on-screen by the slide animation, depending
on whether the currently selected month has a partial week that belongs to the month
that will be slid into place.
@var reusableCells	The pool of reusable cells. If this runs out, the app will crash 
					instead of dynamically allocating more views. So make this just 
					large enough to meet your app needs, but no larger.
@var cellHeight		This implies that every cell must have the same height.
*/
@interface UXCalendarGridView : UXView {
	id <UXCalendarViewDelegate> delegate;
	UXCalendarLogic *logic;
	UXCalendarTileView *selectedTile;
	NSMutableArray *reusableCells;
	CGFloat cellHeight;
}

	@property (nonatomic, retain) UXCalendarTileView *selectedTile;

	/*!
	@abstract 
	@param frame 
	@param logic
	@param delegate
	*/
	-(id) initWithFrame:(CGRect)frame logic:(UXCalendarLogic *)logic delegate:(id <UXCalendarViewDelegate>)delegate;

	-(void) refresh;

	/*!
	@abstract Should be called *after* the UXCalendarLogic has moved to the previous or following month.
	*/
	-(void) slideUp;
	-(void) slideDown;

@end
