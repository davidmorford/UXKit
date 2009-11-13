
/*!
@project	UXKit
@header		UXCalendarLogic.h
@copyright  (c) 2009 Keith Lazuka
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXGlobal.h>

/*!
@class UXCalendarLogic
@superclass  NSObject
@abstract As a client of the UXCalendar system you should not need to use 
this class directly (it is managed by the internal UXCalendar subsystem).
@discussion The UXCalendarLogic represents the current state of the displayed 
calendar month and provides the logic for switching between months and determining 
which days are in a month as well as which days are in partial weeks adjacent 
to the selected month.
@var baseDate	The first day of the currently selected month
*/
@interface UXCalendarLogic : NSObject {
	NSDate *baseDate;
	NSDateFormatter *monthAndYearFormatter;
}

	@property (nonatomic, retain) NSDate *baseDate;

	-(void) retreatToPreviousMonth;
	-(void) advanceToFollowingMonth;

	/*!
	@abstract Each of the daysIn* methords return an array of 
	NSDates in increasing chronological order
	*/
	-(NSArray *) daysInFinalWeekOfPreviousMonth;
	-(NSArray *) daysInSelectedMonth;
	-(NSArray *) daysInFirstWeekOfFollowingMonth;

	-(NSString * )selectedMonthNameAndYear;

@end
