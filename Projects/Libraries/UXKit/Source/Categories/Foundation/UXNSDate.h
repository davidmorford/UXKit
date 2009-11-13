
/*!
@project	UXKit
@header     UXNSDate.h
@copyright  (c) 2009 Joe Hewitt/Three20
@copyright  (c) 2009 Keith Lazuka
@changes	(c) 2009 Semantap
*/

#import <UIKit/UIKit.h>

/*!
@class NSDate (UXNSDate)
@abstract
@discussion
*/
@interface NSDate (UXNSDate)

	#pragma mark Constructors

	/*!
	@abstract ￼￼Returns the current date with the time set to midnight.
	*/	
	+(NSDate *) dateWithToday;

	/*!
	@abstract Returns a copy of the date with the time set to midnight on the same day.
	*/
	-(NSDate *) dateAtMidnight;


	#pragma mark Formatting

	/*!
	@abstract Formats the date with 'h:mm a' or the localized equivalent.
	*/
	-(NSString *) formatTime;

	/*!
	@abstract Formats the date with 'EEEE, LLLL d, YYYY' or the localized equivalent.
	*/
	-(NSString *) formatDate;

	/*!
	@abstract Formats the date according to how old it is.
	@discussion For dates less than a day old, the format is 'h:mm a', for less than a week old the
	format is 'EEEE', and for anything older the format is 'M/d/yy'.
	*/
	-(NSString *) formatShortTime;

	/*!
	@abstract Formats the date according to how old it is.
	@discussion For dates less than a day old, the format is 'h:mm a', for less than a week old the
	format is 'EEE h:mm a', and for anything older the format is 'MMM d h:mm a'.
	*/
	-(NSString *) formatDateTime;

	/*!
	@abstract Formats dates within 24 hours like '5 minutes ago', or calls formatDateTime if older.
	*/
	-(NSString *) formatRelativeTime;

	/*!
	@abstract Formats the date with 'MMMM d", "Today", or "Yesterday".
	@discussion You must supply date components for today and yesterday because they are relatively expensive
	to create, so it is best to avoid creating them every time you call this method if you
	are going to be calling it multiple times in a loop.
	*/
	-(NSString *) formatDay:(NSDateComponents *)today yesterday:(NSDateComponents *)yesterday;

	/*!
	@abstract Formats the date with 'MMMM".
	*/
	-(NSString *) formatMonth;

	/*!
	@abstract Formats the date with 'yyyy".
	*/
	-(NSString *) formatYear;

@end

#pragma mark -

/*!
@category NSDate (UXCalenderUnits)
@abstract
@discussion
*/
@interface NSDate (UXDayCalender)

	+(NSDate *) today;
	+(NSDate *) firstOfCurrentMonth;
	+(NSDate *) lastOfCurrentMonth;

	@property (readonly, nonatomic) NSString *hourString;
	@property (readonly, nonatomic) NSString *monthString;
	@property (readonly, nonatomic) NSString *yearString;
	@property (readonly, nonatomic) NSString *monthYearString;

	@property (readonly, nonatomic) NSNumber *dayNumber;

	@property (readonly, nonatomic) NSInteger weekday;
	@property (readonly, nonatomic) NSInteger weekdayMondayFirst;
	@property (readonly, nonatomic) NSInteger daysInMonth;
	@property (readonly, nonatomic) NSInteger month;
	@property (readonly, nonatomic) NSInteger hour;
	@property (readonly, nonatomic) NSInteger minute;

	@property (readonly, nonatomic) NSDate *firstOfCurrentMonthForDate;
	@property (readonly, nonatomic) NSDate *firstOfNextMonthForDate;
	@property (readonly, nonatomic) NSDate *timelessDate;
	@property (readonly, nonatomic) NSDate *monthlessDate;

	@property (readonly, nonatomic) BOOL isToday;

	-(NSInteger) differenceInDaysTo:(NSDate *)toDate;
	-(NSInteger) differenceInMonthsTo:(NSDate *)toDate;

	-(BOOL) isSameDay:(NSDate *)anotherDate;

@end

#pragma mark -

/*!
@abstract All of the following methods use [NSCalendar currentCalendar] to perform
their calculations. These methods are not documented because, as of right now,
they are only here for the UXCalendar subsystem.
*/
@interface NSDate (UXCalendar)
	
	/*!
	TODO delete me after I'm done with this convenience method. It should only be needed during 
	the initial build-out of the calendar model.
	*/
	+(NSDate *) dateForDay:(NSUInteger)day month:(NSUInteger)month year:(NSUInteger)year;

	-(NSDate *) dateByMovingToFirstDayOfTheMonth;
	-(NSDate *) dateByMovingToFirstDayOfThePreviousMonth;
	-(NSDate *) dateByMovingToFirstDayOfTheFollowingMonth;

	-(NSDateComponents *) componentsForMonthDayAndYear;

	-(NSUInteger) day;
	-(NSUInteger) weekdayNumber;
	-(NSUInteger) numberOfDaysInMonth;

	-(BOOL) isTodayFast;

@end

#pragma mark -

/*!
@abstract 
From == Convert minutes, hours, days, etc into a NSTimeInterval (seconds).
To	 == Convert a NSTimeInterval (seconds) into minutes, hours, days, etc.
*/
#define UXTimeIntervalFromMinutes(minutes)	((minutes) * 60.0)
#define UXTimeIntervalToMinutes(seconds)	((seconds) / 60.0)

#define UXTimeIntervalFromHours(hours)		((hours) * 3600.0)
#define UXTimeIntervalToHours(seconds)		((seconds) / 3600.0)

#define UXTimeIntervalFromDays(days)		((days) * 86400.0)
#define UXTimeIntervalToDays(seconds)		((seconds) / 86400.0)

#define UXTimeIntervalFromWeeks(weeks)		((weeks) * 604800.0)
#define UXTimeIntervalToWeeks(seconds)		((seconds) / 604800.0)

#define UXTimeIntervalFromMonths(months)	((months) * 2628000.0)
#define UXTimeIntervalToMonths(seconds)		((seconds) / 2628000.0)

#define UXTimeIntervalFromYears(years)		((years) * 31536000.0)
#define UXTimeIntervalToYears(seconds)		((seconds) / 31536000.0)
