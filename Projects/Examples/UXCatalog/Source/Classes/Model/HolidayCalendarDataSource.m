
#import "HolidayCalendarDataSource.h"

static NSMutableDictionary *holidays;

@implementation HolidayCalendarDataSource

	+(void) initialize {
		holidays = [[NSMutableDictionary alloc] init];
		[holidays setObject:[UXTableTextItem itemWithText:@"New Years Day"] forKey:[NSDate dateForDay:1 month:1 year:2009]];
		[holidays setObject:[UXTableTextItem itemWithText:@"Martin Luther King Day"] forKey:[NSDate dateForDay:19 month:1 year:2009]];
		[holidays setObject:[UXTableTextItem itemWithText:@"Washington's Birthday"] forKey:[NSDate dateForDay:16 month:2 year:2009]];
		[holidays setObject:[UXTableTextItem itemWithText:@"Memorial Day"] forKey:[NSDate dateForDay:25 month:5 year:2009]];
		[holidays setObject:[UXTableTextItem itemWithText:@"Independence Day"] forKey:[NSDate dateForDay:4 month:7 year:2009]];
		[holidays setObject:[UXTableTextItem itemWithText:@"Labor Day"] forKey:[NSDate dateForDay:7 month:9 year:2009]];
		[holidays setObject:[UXTableTextItem itemWithText:@"Columbus Day"] forKey:[NSDate dateForDay:12 month:10 year:2009]];
		[holidays setObject:[UXTableTextItem itemWithText:@"Veteran's Day"] forKey:[NSDate dateForDay:11 month:11 year:2009]];
		[holidays setObject:[UXTableTextItem itemWithText:@"Thanksgiving Day"] forKey:[NSDate dateForDay:26 month:11 year:2009]];
		[holidays setObject:[UXTableTextItem itemWithText:@"Christmas Day"] forKey:[NSDate dateForDay:25 month:12 year:2009]];
	}

	-(void) loadDate:(NSDate *)date {
		[self.items removeAllObjects];
		UXTableItem *item = [holidays objectForKey:date];
		if (item) {
			[self.items addObject:item];
		}
	}

	-(BOOL) hasDetailsForDate:(NSDate *)date {
		return [holidays objectForKey:date] != nil;
	}

@end
