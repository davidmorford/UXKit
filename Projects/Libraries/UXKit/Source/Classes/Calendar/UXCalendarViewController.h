
/*!
@project	UXKit
@header		UXCalendarViewController.h
@copyright  (c) 2009 Keith Lazuka
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXTableViewController.h>
#import <UXKit/UXCalendarView.h>

@class UXCalendarLogic;

/*!
@class UXCalendarViewController
@superclass UXTableViewController <UXCalendarViewDelegate>
@abstract As a client of UXKit calendar system, this is this main entry-point
into using the calendar. The UXCalendar system mimics the Calendar app as much 
as possible. When the user taps a date, associated events for that date are 
displayed in a table view directly below the calendar. Events for each date 
are provided via UXCalendarDataSource.
@discussion UXCalendarViewController creates the calendar view and events table 
view. A UXCalendarDataSource must be provided so that the calendar system knows 
which days to mark with a dot and which events to list under the calendar when 
a certain date is selected.
*/
@interface UXCalendarViewController : UXTableViewController <UXCalendarViewDelegate> {
	UXCalendarLogic *logic;
}

@end
