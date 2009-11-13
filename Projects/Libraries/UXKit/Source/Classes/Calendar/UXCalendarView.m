
#import <UXKit/UXCalendarView.h>
#import <UXKit/UXCalendarGridView.h>
#import <UXKit/UXDefaultStyleSheet.h>
#import <UXKit/UXCalendarLogic.h>
#import <UXKit/UXURLCache.h>

@interface UXCalendarView ()
	-(void) addSubviewsToHeaderView:(UIView *)headerView;
	-(void) addSubviewsToContentView:(UIView *)contentView;
@end

static const CGFloat kHeaderHeight = 42.f;

@implementation UXCalendarView

	@synthesize delegate;
	@synthesize tableView;


	#pragma mark Initialzier

	-(id) initWithFrame:(CGRect)frame {
		[NSException raise:@"Incomplete initializer" format:@"UXCalendarView must be initialized with a delegate and a UXCalendarLogic. Use the initWithFrame:delegate:logic: method."];
		return nil;
	}

	-(id) initWithFrame:(CGRect)frame delegate:(id <UXCalendarViewDelegate>)theDelegate logic:(UXCalendarLogic *)theLogic {
		if ((self = [super initWithFrame:frame])) {
			delegate	= theDelegate;
			logic		= [theLogic retain];
			[logic addObserver:self forKeyPath:@"selectedMonthNameAndYear" options:NSKeyValueObservingOptionNew context:NULL];
			
			// Header
			UXView *headerView	= [[[UXView alloc] initWithFrame:CGRectMake(0.f, 0.f, frame.size.width, kHeaderHeight)] autorelease];
			headerView.style	= [UXFourBorderStyle styleWithTop:[UIColor whiteColor] right:nil bottom:nil left:nil width:1.f 
															 next:[UXLinearGradientFillStyle styleWithColor1:UXSTYLEVAR(calendarHeaderTopColor) color2:UXSTYLEVAR(calendarHeaderBottomColor) 
															 next:nil]];
			[self addSubviewsToHeaderView:headerView];
			[self addSubview:headerView];
			
			UXView *contentView				= [[[UXView alloc] initWithFrame:CGRectMake(0.f, kHeaderHeight, frame.size.width, frame.size.height - kHeaderHeight)] autorelease];
			contentView.autoresizingMask	= UIViewAutoresizingFlexibleHeight;
			[self addSubviewsToContentView:contentView];
			[self addSubview:contentView];
		}
		return self;
	}

	#pragma mark -

	-(void) refresh {
		[gridView refresh];
	}

	-(void) slideDown {
		[gridView slideDown];
	}

	-(void) slideUp {
		[gridView slideUp];
	}

	-(void) addSubviewsToHeaderView:(UIView *)headerView {
		const CGFloat kChangeMonthButtonWidth	= 46.0f;
		const CGFloat kChangeMonthButtonHeight	= 42.0f;
		const CGFloat kMonthLabelWidth			= 200.0f;
		const CGFloat kHeaderVerticalAdjust		= 3.f;
		
		// Create the previous month button on the left side of the view
		CGRect previousMonthButtonFrame			= CGRectMake(self.left, self.top - kHeaderVerticalAdjust, kChangeMonthButtonWidth, kChangeMonthButtonHeight);
															 
		UIButton *previousMonthButton			= [[UIButton alloc] initWithFrame:previousMonthButtonFrame];
		
		[previousMonthButton setImage:UXIMAGE(@"bundle://UXKit.bundle/Images/Calendar/leftarrow.png") 
							 forState:UIControlStateNormal];
							 
		previousMonthButton.contentHorizontalAlignment	= UIControlContentHorizontalAlignmentCenter;
		previousMonthButton.contentVerticalAlignment	= UIControlContentVerticalAlignmentCenter;
		
		[previousMonthButton addTarget:delegate 
								action:@selector(showPreviousMonth) 
					  forControlEvents:UIControlEventTouchUpInside];

		[headerView addSubview:previousMonthButton];
		[previousMonthButton release];
		
		// Draw the selected month name centered and at the top of the view
		const CGFloat kMonthLabelHeight		= 27.f;
		CGRect monthLabelFrame				= CGRectMake((self.width / 2.0f) - (kMonthLabelWidth / 2.0f),
														 3.f - kHeaderVerticalAdjust,
														 kMonthLabelWidth,
														 kMonthLabelHeight);
		
		headerTitleLabel					= [[UILabel alloc] initWithFrame:monthLabelFrame];
		headerTitleLabel.backgroundColor	= [UIColor clearColor];
		headerTitleLabel.font				= [UIFont boldSystemFontOfSize:21.f];
		headerTitleLabel.textAlignment		= UITextAlignmentCenter;
		headerTitleLabel.textColor			= UXSTYLEVAR(calendarTextColor);
		headerTitleLabel.shadowColor		= [UIColor whiteColor];
		headerTitleLabel.shadowOffset		= CGSizeMake(0.f, 1.f);
		headerTitleLabel.text				= [logic selectedMonthNameAndYear];
		[headerView addSubview:headerTitleLabel];
		
		// Create the next month button on the right side of the view
		CGRect nextMonthButtonFrame = CGRectMake(self.width - kChangeMonthButtonWidth,
												 self.top - kHeaderVerticalAdjust,
												 kChangeMonthButtonWidth,
												 kChangeMonthButtonHeight);
												 
		UIButton *nextMonthButton					= [[UIButton alloc] initWithFrame:nextMonthButtonFrame];

		[nextMonthButton setImage:UXIMAGE(@"bundle://UXKit.bundle/Images/Calendar/rightarrow.png") 
						 forState:UIControlStateNormal];

		nextMonthButton.contentHorizontalAlignment	= UIControlContentHorizontalAlignmentCenter;
		nextMonthButton.contentVerticalAlignment	= UIControlContentVerticalAlignmentCenter;

		[nextMonthButton addTarget:delegate 
							action:@selector(showFollowingMonth) 
				  forControlEvents:UIControlEventTouchUpInside];

		[headerView addSubview:nextMonthButton];
		[nextMonthButton release];
		
		// Add column labels for each weekday (adjusting based on the current locale's first weekday)
		NSArray *weekdayNames	= [[[[NSDateFormatter alloc] init] autorelease] shortWeekdaySymbols];
		NSUInteger firstWeekday = [[NSCalendar currentCalendar] firstWeekday];
		NSUInteger i			= firstWeekday - 1;
		
		for (CGFloat xOffset = 0.f; xOffset < headerView.width; xOffset += 46.f, i = (i + 1) % 7) {
			CGRect weekdayFrame				= CGRectMake(xOffset, 29.f, 46.f, kHeaderHeight - 29.f);
			UILabel *weekdayLabel			= [[UILabel alloc] initWithFrame:weekdayFrame];
			weekdayLabel.backgroundColor	= [UIColor clearColor];
			weekdayLabel.font				= [UIFont boldSystemFontOfSize:10.f];
			weekdayLabel.textAlignment		= UITextAlignmentCenter;
			weekdayLabel.textColor			= UXSTYLEVAR(calendarTextColor);
			weekdayLabel.shadowColor		= [UIColor whiteColor];
			weekdayLabel.shadowOffset		= CGSizeMake(0.f, 1.f);
			weekdayLabel.text				= [weekdayNames objectAtIndex:i];
			[headerView addSubview:weekdayLabel];
			[weekdayLabel release];
		}
	}

	/*!
	@abstract Both the tile grid and the day details will automatically lay themselves
	out to fit the # of weeks in the currently displayed month. So the only part of the 
	frame that we need to specify is the width.
	*/
	-(void) addSubviewsToContentView:(UIView *)contentView {
		CGRect fullWidthAutomaticLayoutFrame = CGRectMake(0.f, 0.f, self.width, 0.f);
		
		// Tile Grid
		gridView = [[UXCalendarGridView alloc] initWithFrame:fullWidthAutomaticLayoutFrame logic:logic delegate:delegate];
		[gridView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
		[contentView addSubview:gridView];
		
		// Day Details
		tableView					= [[UITableView alloc] initWithFrame:fullWidthAutomaticLayoutFrame style:UITableViewStylePlain];
		tableView.autoresizingMask	= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[contentView addSubview:tableView];
		
		// Drop shadow below tile grid over day details
		dropShadow			= [[UXView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.width, 15.f)];
		dropShadow.opaque	= NO;
		dropShadow.style	= [UXLinearGradientFillStyle styleWithColor1:RGBACOLOR(128, 128, 128, 0.75) color2:[UIColor clearColor] next:nil];
		[contentView addSubview:dropShadow];
		
		// Adjust the size of the grid to fit the # of weeks which will also indirectly 
		// update the size and position of dayDetailsView via KVO.
		[gridView sizeToFit];
	}

	#pragma mark KVO

	/*! 
	Animate dayDetailsView filling the remaining space after the gridView expanded 
	or contracted to fit the # of weeks for the month that is being displayed.
	This observer method will be called when gridView's height changes, which we 
	know to occur inside a Core Animation transaction. Hence, when I set the "frame" 
	property on dayDetailsView here, I do not need to wrap it in a 
	[UIView beginAnimations:context:].
	*/
	-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
		if ((object == gridView) && [keyPath isEqualToString:@"frame"]) {
			CGFloat gridBottom	= gridView.top + gridView.height;
			CGRect frame		= tableView.frame;
			frame.origin.y		= gridBottom;
			frame.size.height	= tableView.superview.height - gridBottom;
			tableView.frame		= frame;
			frame.size.height	= dropShadow.height;
			dropShadow.frame	= frame;
		}
		else if ([keyPath isEqualToString:@"selectedMonthNameAndYear"]) {
			[headerTitleLabel setText:[change objectForKey:NSKeyValueChangeNewKey]];
		}
		else {
			[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
		}
	}

	#pragma mark -

	-(void) dealloc {
		[logic removeObserver:self forKeyPath:@"selectedMonthNameAndYear"];
		[logic release];
		[headerTitleLabel release];
		[gridView removeObserver:self forKeyPath:@"frame"];
		[gridView release];
		[tableView release];
		[dropShadow release];
		[super dealloc];
	}

@end
