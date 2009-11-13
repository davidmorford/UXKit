
#import "CalendarTestController.h"
#import "HolidayCalendarDataSource.h"

@implementation CalendarTestController

	/*!
	The client should not have to subclass UXCalendarViewController
	just to specify the data source. In regular code they can just
	set the datasource property *after* init, but in UXCatalog,
	maybe we can pass the dataSource as a parameter via the URL mapping system?
	*/
	-(id) init {
		if ((self = [super init])) {
			self.dataSource = [HolidayCalendarDataSource dataSource];
		}
		return self;
	}

@end
