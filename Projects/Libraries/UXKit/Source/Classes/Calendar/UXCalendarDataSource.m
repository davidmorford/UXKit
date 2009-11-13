
#import <UXKit/UXCalendarDataSource.h>

@implementation UXCalendarDataSource

	+(id <UXTableViewDataSource>) dataSource {
		return [self dataSourceWithItems:[NSArray array]];
	}

	-(void) loadDate:(NSDate *)date {
	}

	-(BOOL) hasDetailsForDate:(NSDate *)date {
		return NO;
	}

	-(void) tableViewDidLoadModel:(UITableView *)tableView {
		[tableView reloadData];
		[super tableViewDidLoadModel:tableView];
	}

@end
