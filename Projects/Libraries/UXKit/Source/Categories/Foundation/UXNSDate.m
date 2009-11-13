
#import <UXKit/UXGlobal.h>

@implementation NSDate (UXNSDate)

	+(NSDate *) dateWithToday {
		NSDateFormatter *formatter	= [[[NSDateFormatter alloc] init] autorelease];
		formatter.dateFormat		= @"yyyy-d-M";
		NSString *time				= [formatter stringFromDate:[NSDate date]];
		NSDate *date				= [formatter dateFromString:time];
		return date;
	}

	#pragma mark -

	-(NSDate *) dateAtMidnight {
		NSDateFormatter *formatter	= [[[NSDateFormatter alloc] init] autorelease];
		formatter.dateFormat		= @"yyyy-d-M";
		NSString *time				= [formatter stringFromDate:self];
		NSDate *date				= [formatter dateFromString:time];
		return date;
	}

	-(NSString *) formatTime {
		static NSDateFormatter *formatter = nil;
		if (!formatter) {
			formatter				= [[NSDateFormatter alloc] init];
			formatter.dateFormat	= UXLocalizedString(@"h:mm a", @"Date format: 1:05 pm");
			formatter.locale		= UXCurrentLocale();
		}
		return [formatter stringFromDate:self];
	}

	-(NSString *) formatDate {
		static NSDateFormatter *formatter = nil;
		if (!formatter) {
			formatter = [[NSDateFormatter alloc] init];
			formatter.dateFormat =
			UXLocalizedString(@"EEEE, LLLL d, YYYY", @"Date format: Monday, July 27, 2009");
			formatter.locale = UXCurrentLocale();
		}
		return [formatter stringFromDate:self];
	}

	-(NSString *) formatShortTime {
		NSTimeInterval diff = abs([self timeIntervalSinceNow]);
		if (diff < UX_DAY) {
			return [self formatTime];
		}
		else if (diff < UX_WEEK) {
			static NSDateFormatter *formatter = nil;
			if (!formatter) {
				formatter = [[NSDateFormatter alloc] init];
				formatter.dateFormat = UXLocalizedString(@"EEEE", @"Date format: Monday");
				formatter.locale = UXCurrentLocale();
			}
			return [formatter stringFromDate:self];
		}
		else {
			static NSDateFormatter *formatter = nil;
			if (!formatter) {
				formatter = [[NSDateFormatter alloc] init];
				formatter.dateFormat = UXLocalizedString(@"M/d/yy", @"Date format: 7/27/09");
				formatter.locale = UXCurrentLocale();
			}
			return [formatter stringFromDate:self];
		}
	}

	-(NSString *) formatDateTime {
		NSTimeInterval diff = abs([self timeIntervalSinceNow]);
		if (diff < UX_DAY) {
			return [self formatTime];
		}
		else if (diff < UX_WEEK) {
			static NSDateFormatter *formatter = nil;
			if (!formatter) {
				formatter = [[NSDateFormatter alloc] init];
				formatter.dateFormat = UXLocalizedString(@"EEE h:mm a", @"Date format: Mon 1:05 pm");
				formatter.locale = UXCurrentLocale();
			}
			return [formatter stringFromDate:self];
		}
		else {
			static NSDateFormatter *formatter = nil;
			if (!formatter) {
				formatter				= [[NSDateFormatter alloc] init];
				formatter.dateFormat	= UXLocalizedString(@"MMM d h:mm a", @"Date format: Jul 27 1:05 pm");
				formatter.locale		= UXCurrentLocale();
			}
			return [formatter stringFromDate:self];
		}
	}

	-(NSString *) formatRelativeTime {
		NSTimeInterval elapsed = abs([self timeIntervalSinceNow]);
		if (elapsed <= 1) {
			return UXLocalizedString(@"just a moment ago", @"");
		}
		else if (elapsed < UX_MINUTE) {
			int seconds = (int)(elapsed);
			return [NSString stringWithFormat:UXLocalizedString(@"%d seconds ago", @""), seconds];
		}
		else if (elapsed < 2 * UX_MINUTE) {
			return UXLocalizedString(@"about a minute ago", @"");
		}
		else if (elapsed < UX_HOUR) {
			int mins = (int)(elapsed / UX_MINUTE);
			return [NSString stringWithFormat:UXLocalizedString(@"%d minutes ago", @""), mins];
		}
		else if (elapsed < UX_HOUR * 1.5) {
			return UXLocalizedString(@"about an hour ago", @"");
		}
		else if (elapsed < UX_DAY) {
			int hours = (int)((elapsed + UX_HOUR / 2) / UX_HOUR);
			return [NSString stringWithFormat:UXLocalizedString(@"%d hours ago", @""), hours];
		}
		else {
			return [self formatDateTime];
		}
	}

	-(NSString *) formatDay:(NSDateComponents *)today yesterday:(NSDateComponents *)yesterday {
		static NSDateFormatter *formatter = nil;
		if (!formatter) {
			formatter				= [[NSDateFormatter alloc] init];
			formatter.dateFormat	= UXLocalizedString(@"MMMM d", @"Date format: July 27");
			formatter.locale		= UXCurrentLocale();
		}
		
		NSCalendar *cal = [NSCalendar currentCalendar];
		NSDateComponents *day = [cal components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:self];
		
		if ((day.day == today.day) && (day.month == today.month) && (day.year == today.year)) {
			return UXLocalizedString(@"Today", @"");
		}
		else if ((day.day == yesterday.day) && (day.month == yesterday.month) && (day.year == yesterday.year) ) {
			return UXLocalizedString(@"Yesterday", @"");
		}
		else {
			return [formatter stringFromDate:self];
		}
	}

	-(NSString *) formatMonth {
		static NSDateFormatter *formatter = nil;
		if (!formatter) {
			formatter				= [[NSDateFormatter alloc] init];
			formatter.dateFormat	= UXLocalizedString(@"MMMM", @"Date format: July");
			formatter.locale		= UXCurrentLocale();
		}
		return [formatter stringFromDate:self];
	}

	-(NSString *) formatYear {
		static NSDateFormatter *formatter = nil;
		if (!formatter) {
			formatter				= [[NSDateFormatter alloc] init];
			formatter.dateFormat	= UXLocalizedString(@"yyyy", @"Date format: 2009");
			formatter.locale		= UXCurrentLocale();
		}
		return [formatter stringFromDate:self];
	}

@end

#pragma mark -

@implementation NSDate (UXDayCalender)

	+(NSDate *) today {
		return [NSDate date];
	}

	+(NSDate *) firstOfCurrentMonth {
		NSDate *day = [NSDate date];
		NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
		NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit)fromDate:day];
		[comp setDay:1];
		return [gregorian dateFromComponents:comp];
	}

	+(NSDate *) lastOfCurrentMonth {
		NSDate *day = [NSDate date];
		NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
		NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit)fromDate:day];
		[comp setDay:0];
		[comp setMonth:comp.month + 1];
		return [gregorian dateFromComponents:comp];
	}

	#pragma mark -

	-(NSDate *) timelessDate {
		NSDate *day = self;
		NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
		NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)fromDate:day];
		return [gregorian dateFromComponents:comp];
	}

	-(NSDate *) monthlessDate {
		NSDate *day = self;
		NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
		NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit)fromDate:day];
		return [gregorian dateFromComponents:comp];
	}

	-(NSDate *) firstOfCurrentMonthForDate {
		NSDate *day = self;
		NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
		NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit)fromDate:day];
		[comp setDay:1];
		return [gregorian dateFromComponents:comp];
	}

	-(NSDate *) firstOfNextMonthForDate {
		NSDate *day = self;
		NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
		NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit)fromDate:day];
		[comp setDay:1];
		[comp setMonth:comp.month + 1];
		return [gregorian dateFromComponents:comp];
	}

	-(NSNumber *) dayNumber {
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[dateFormatter setDateFormat:@"d"];
		return [NSNumber numberWithInt:[[dateFormatter stringFromDate:self] intValue]];
	}

	-(NSString *) hourString {
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[dateFormatter setDateFormat:@"h a"];
		return [dateFormatter stringFromDate:self];
	}

	-(NSString *) monthString {
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[dateFormatter setDateFormat:@"MMMM"];
		return [dateFormatter stringFromDate:self];
	}

	-(NSString *) yearString {
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[dateFormatter setDateFormat:@"yyyy"];
		return [dateFormatter stringFromDate:self];
	}

	-(NSString *) monthYearString {
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[dateFormatter setDateFormat:@"MMMM yyyy"];
		return [dateFormatter stringFromDate:self];
	}

	-(NSInteger) weekday {
		NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDateComponents *comps = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit)fromDate:self];
		NSInteger weekday = [comps weekday];
		[gregorian release];
		return weekday;
	}

	/*!
	Calendar starting on Monday instead of Sunday (Australia, Europe against US american calendar)
	*/
	-(NSInteger) weekdayMondayFirst {
		NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDateComponents *comps = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit)fromDate:self];
		NSInteger weekday = [comps weekday];
		[gregorian release];
		
		CFCalendarRef currentCalendar = CFCalendarCopyCurrent();
		if (CFCalendarGetFirstWeekday(currentCalendar) == 2) {
			weekday -= 1;
			if (weekday == 0) {
				weekday = 7;
			}
		}
		CFRelease(currentCalendar);
		
		return weekday;
	}

	-(NSInteger) daysInMonth {
		NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:self];
		[comp setDay:0];
		[comp setMonth:comp.month + 1];
		NSInteger days = [[gregorian components:NSDayCalendarUnit fromDate:[gregorian dateFromComponents:comp]] day];
		[gregorian release];
		return days;
	}
	
	/*!
	hour between 0 - 24 - Check at midnight
	*/
	-(NSInteger) month {
		NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDateComponents *comp = [gregorian components:(NSMonthCalendarUnit)fromDate:self];
		NSInteger month = [comp month];
		[gregorian release];
		return month;
	}

	/*!
	hour between 0 - 24 - Check at midnight
	*/
	-(NSInteger) hour {
		NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDateComponents *comp = [gregorian components:(NSHourCalendarUnit)fromDate:self];
		NSInteger hour = [comp hour];
		[gregorian release];
		return hour;
	}

	-(NSInteger) minute {
		NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDateComponents *comp = [gregorian components:(NSMinuteCalendarUnit)fromDate:self];
		NSInteger minute = [comp minute];
		[gregorian release];
		
		return minute;
	}

	-(NSInteger) differenceInDaysTo:(NSDate *)toDate {
		NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDateComponents *components = [gregorian components:NSDayCalendarUnit
													fromDate:self
													  toDate:toDate
													 options:0];
		NSInteger days = [components day];
		[gregorian release];
		return days;
	}

	-(NSInteger) differenceInMonthsTo:(NSDate *)toDate {
		NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDateComponents *components = [gregorian components:NSMonthCalendarUnit
													fromDate:[self monthlessDate]
													  toDate:[toDate monthlessDate]
													 options:0];
		NSInteger months = [components month];
		[gregorian release];
		return months;
	}

	-(BOOL) isSameDay:(NSDate *)anotherDate {
		NSCalendar *calendar = [NSCalendar currentCalendar];
		NSDateComponents *components1 = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
		NSDateComponents *components2 = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:anotherDate];
		return ([components1 year] == [components2 year] && [components1 month] == [components2 month] && [components1 day] == [components2 day]);
	}

	-(BOOL) isToday {
		return [self isSameDay:[NSDate date]];
	}

@end

#pragma mark -

@implementation NSDate (UXCalendar)

	+(NSDate *) dateForDay:(NSUInteger)day month:(NSUInteger)month year:(NSUInteger)year {
		NSDateComponents *c = [[[NSDateComponents alloc] init] autorelease];
		c.day = day;
		c.month = month;
		c.year = year;
		return [[NSCalendar currentCalendar] dateFromComponents:c];
	}

	-(BOOL) isTodayFast {
		// Performance optimization because [NSCalendar componentsFromDate:] is expensive.
		// (I verified this with Shark)
		if (ABS([self timeIntervalSinceDate:[NSDate date]]) > 86400) {
			return NO;
		}
		
		NSDateComponents *c1 = [self componentsForMonthDayAndYear];
		NSDateComponents *c2 = [[NSDate today] componentsForMonthDayAndYear];
		return c1.day == c2.day && c1.month == c2.month && c1.year == c2.year && c1.era == c2.era;
	}

	-(NSDate *) dateByMovingToFirstDayOfTheMonth {
		NSDate *d = nil;
		BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSMonthCalendarUnit startDate:&d interval:NULL forDate:self];
		NSAssert1(ok, @"Failed to calculate the first day the month based on %@", self);
		return d;
	}

	-(NSDate *) dateByMovingToFirstDayOfThePreviousMonth {
		NSDateComponents *c = [[[NSDateComponents alloc] init] autorelease];
		c.month = -1;
		return [[[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0] dateByMovingToFirstDayOfTheMonth];
	}

	-(NSDate *) dateByMovingToFirstDayOfTheFollowingMonth {
		NSDateComponents *c = [[[NSDateComponents alloc] init] autorelease];
		c.month = 1;
		return [[[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0] dateByMovingToFirstDayOfTheMonth];
	}

	-(NSDateComponents *) componentsForMonthDayAndYear {
		return [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
	}

	-(NSUInteger) day {
		return (NSUInteger)[[[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:self] day];
	}

	-(NSUInteger) weekdayNumber {
		return [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:self];
	}

	-(NSUInteger) numberOfDaysInMonth {
		return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self].length;
	}

@end
