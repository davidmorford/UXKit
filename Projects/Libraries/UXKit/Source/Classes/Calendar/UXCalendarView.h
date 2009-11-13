
/*!
@project	UXKit
@header		UXCalendarView.h
@copyright  (c) 2009 Keith Lazuka
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXView.h>

@class UXCalendarGridView, UXCalendarLogic;
@protocol UXCalendarViewDelegate;

/*!
@class UXCalendarView
@superclass UXView
@abstract As a client of the UXCalendar system you should not need to use this class directly
(it is managed by UXCalendarViewController).
@discussion  UXCalendarViewController uses UXCalendarView as its view. UXCalendarView defines 
a view hierarchy that looks like the following:
@var headerTitleLabel	Displays the currently selected month and year at the top of the calendar.
@var gridView			The calendar proper (between the calendar header and the table view)
@var tableView			Bottom section (events for the currently selected day)
@var dropShadow			Below the grid and on-top-of tableView.
*/
@interface UXCalendarView : UXView {
	id <UXCalendarViewDelegate> delegate;
	UXCalendarLogic *logic;
	UXCalendarGridView *gridView;
	UXView *dropShadow;
	UITableView *tableView;
	UILabel *headerTitleLabel;
}

	@property (nonatomic, assign) id <UXCalendarViewDelegate> delegate;
	@property (nonatomic, readonly) UITableView *tableView;

	-(id) initWithFrame:(CGRect)frame delegate:(id <UXCalendarViewDelegate>)delegate logic:(UXCalendarLogic *)logic;
	
	/*!
	@abstract Requery marked tiles and update the table view of events.
	*/
	-(void) refresh;

	/*!
	@abstract These 2 methods are exposed for the delegate. They should be called
	*after* the UXCalendarLogic has moved to the previous or following month.
	*/
	-(void) slideDown;
	-(void) slideUp;

@end


/*!
@protocol UXCalendarViewDelegate <NSObject>
@abstract Designed to be used by UXCalendarViewController.
@discussion
*/
@protocol UXCalendarViewDelegate <NSObject>

	-(void) showPreviousMonth;
	-(void) showFollowingMonth;
	-(BOOL) shouldMarkTileForDate:(NSDate *)date;
	-(void) didSelectDate:(NSDate *)date;

@end
