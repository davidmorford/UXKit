
#import <UXKit/UXCalendarViewController.h>
#import <UXKit/UXCalendarLogic.h>
#import <UXKit/UXCalendarDataSource.h>

@interface UXCalendarViewController ()

	-(UXCalendarView *) calendarView;

@end

#pragma mark -

@implementation UXCalendarViewController

	-(id) init {
		if ((self = [super init])) {
			self.dataSource = [UXCalendarDataSource dataSource];
		}
		return self;
	}


	#pragma mark UXCalendarViewDelegate

	-(void) didSelectDate:(NSDate *)date {
		// Configure the dataSource to display details for |date|.
		[(UXCalendarDataSource *)self.dataSource loadDate:date];
		// Refresh the details view underneath the calendar grid.
		[self showModel:YES];
	}

	-(BOOL) shouldMarkTileForDate:(NSDate *)date {
		return [(UXCalendarDataSource *)self.dataSource hasDetailsForDate:date];
	}

	-(void) showPreviousMonth {
		[logic retreatToPreviousMonth];
		[[self calendarView] slideDown];
	}

	-(void) showFollowingMonth {
		[logic advanceToFollowingMonth];
		[[self calendarView] slideUp];
	}


	#pragma mark UIViewController

	-(void) loadView {
		self.title		= @"Calendar";
		logic			= [[UXCalendarLogic alloc] init];
		self.view		= [[[UXCalendarView alloc] initWithFrame:UXNavigationFrame() delegate:self logic:logic] autorelease];
		self.tableView	= [[self calendarView] tableView];
	}


	#pragma mark UXModelViewController

	-(void)didLoadModel:(BOOL)firstTime {
		[super didLoadModel:firstTime];
		[[self calendarView] refresh];
	}


	-(UXCalendarView *) calendarView {
		return (UXCalendarView *)self.view;
	}


	#pragma mark -

	-(void) dealloc {
		[logic release];
		[super dealloc];
	}

@end


/*
EXAMPLES
The example code assumes that it is being called from within another UIViewController 
in a UINavigationController hierarchy. To display a basic calendar without any events:

	UXCalendarViewController *calendar = [[[UXCalendarViewController alloc] init] autorelease];
	[self.navigationController pushViewController:calendar animated:YES];

For custom data to attach to dates on the calendar:

	UXCalendarViewController *calendar = [[[UXCalendarViewController alloc] init] autorelease];
	calendar.dataSource = [[[YOUCalendarDataSourceSubclass alloc] init] autorelease];
	[self.navigationController pushViewController:calendar animated:YES];
*/
