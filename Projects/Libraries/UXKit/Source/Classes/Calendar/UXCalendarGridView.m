
#import <UXKit/UXCalendarGridView.h>
#import <UXKit/UXCalendarView.h>
#import <UXKit/UXCalendarTileView.h>
#import <UXKit/UXDefaultStyleSheet.h>
#import <UXKit/UXCalendarLogic.h>

#define SLIDE_NONE	0
#define SLIDE_UP	1
#define SLIDE_DOWN	2

static NSString*		kSlideAnimationId	= @"KLSlideAnimationId";
/*! 
6weeks * 3months (always have two spare month's worth of tiles available)
*/
static const NSUInteger kTilePoolSize		= 6 * 3;
static const CGSize		kTileSize			= { 46.f, 46.f };

#pragma mark -

@interface UXCalendarGridView ()

	-(void) initializeCell:(UXView *)cell;
	-(NSArray *) dequeueAndConfigureNextBatchOfCellsForSlide:(int)direction;
	-(void) selectTodayIfVisible;

@end

#pragma mark -

@implementation UXCalendarGridView

	@synthesize selectedTile;

	/*!
	@discussion Calendar.app uses 46px wide tiles, with a 2px inner stroke along the 
	top and right edges. Since there are 7 columns, the width needs to be 46*7 (322px). 
	But the iPhone's screen is only 320px wide, so we need to make the frame extend just 
	beyond the right edge of the screen to accomodate all 7 columns. The 7th day's 2px 
	inner stroke will be clipped off the screen, but that's fine because MobileCal does the same thing.
	@result
	*/
	-(id) initWithFrame:(CGRect)frame logic:(UXCalendarLogic *)theLogic delegate:(id <UXCalendarViewDelegate>)theDelegate {
		frame.size.width = 7 * kTileSize.width;
		if (self = [super initWithFrame:frame]) {
			self.clipsToBounds	= YES;
			reusableCells		= [[NSMutableArray alloc] init];
			cellHeight			= kTileSize.height;
			logic				= [theLogic retain];
			delegate			= theDelegate;
			self.style			= [UXLinearGradientFillStyle styleWithColor1:UXSTYLEVAR(calendarGridTopColor) color2:UXSTYLEVAR(calendarGridBottomColor) next:nil];
			
			// Allocate the pool of cells. Each cell represents a calendar week (a single row of 7 UXCalendarTileViews).
			for (NSUInteger i = 0; i < kTilePoolSize; i++) {
				UXView *cell			= [[[UXView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.width, cellHeight)] autorelease];
				cell.opaque				= NO;
				cell.backgroundColor	= [UIColor clearColor];
				[self initializeCell:cell];
				[reusableCells enqueue:cell];
			}
			
			for (UXView *cell in [self dequeueAndConfigureNextBatchOfCellsForSlide : SLIDE_NONE]) {
				[self addSubview:cell];
			}
			
			[self selectTodayIfVisible];
			[self sizeToFit];
		}
		return self;
	}

	-(void) refresh {
		if (selectedTile) {
			[delegate didSelectDate:selectedTile.date];
		}
		
		for (UXView *cell in self.subviews) {
			for (UXCalendarTileView *tile in cell.subviews) {
				tile.marked = [delegate shouldMarkTileForDate:tile.date];
			}
		}
	}


	#pragma mark UIResponder

	-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
		UITouch *touch		= [touches anyObject];
		CGPoint	location	= [touch locationInView:self];
		UIView *hitView		= [self hitTest:location withEvent:event];
		
		if ([hitView isKindOfClass:[UXCalendarTileView class ]]) {
			self.selectedTile = (UXCalendarTileView *)hitView;
		}
	}

	-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
		UITouch *touch		= [touches anyObject];
		CGPoint location	= [touch locationInView:self];
		UIView *hitView		= [self hitTest:location withEvent:event];
		
		if (!hitView) {
			return;
		}
		
		if ([hitView isKindOfClass:[UXCalendarTileView class ]]) {
			self.selectedTile = (UXCalendarTileView *)hitView;
		}
	}

	-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
		UITouch *touch		= [touches anyObject];
		CGPoint location	= [touch locationInView:self];
		UIView *hitView		= [self hitTest:location withEvent:event];
		
		if ([hitView isKindOfClass:[UXCalendarTileView class ]]) {
			UXCalendarTileView *tile = (UXCalendarTileView *)hitView;
			if (tile.belongsToAdjacentMonth) {
				if ([tile.date timeIntervalSinceDate:logic.baseDate] > 0) {
					[delegate showFollowingMonth];
				}
				else {
					[delegate showPreviousMonth];
				}
			}
			self.selectedTile = tile;
		}
	}

	-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
		UITouch *touch = [touches anyObject];
		UXLOG(@"cancelled touches at %@", NSStringFromCGPoint([touch locationInView:self]));
		self.selectedTile = nil;
	}

	/*!
	Days that were part of the adjacent month before are now part of the selected month, and vice versa.
	So we need to toggle the flags and ensure that a tile that is part of the adjacent month cannot
	be currently selected.
	*/
	-(void) updateTilesInKeptCell:(UXView *)cell {
		for (UXCalendarTileView *tile in cell.subviews) {
			tile.belongsToAdjacentMonth = !tile.belongsToAdjacentMonth;
		}
		
		if (self.selectedTile.belongsToAdjacentMonth) {
			self.selectedTile = nil;
		}
	}

	-(void) sizeToFit {
		// Resize |self| such that it is just tall enough to fit all of its subviews.
		self.height = [[self.subviews valueForKeyPath:@"@sum.height"] floatValue];
	}

	-(void) setSelectedTile:(UXCalendarTileView *)tile {
		if (selectedTile != tile) {
			selectedTile.selected	= NO;
			selectedTile			= [tile retain];
			tile.selected			= YES;
			[delegate didSelectDate:tile.date];
		}
	}

	-(void) selectTodayIfVisible {
		for (UXView *cell in self.subviews) {
			for (UXCalendarTileView *tile in cell.subviews) {
				if ([tile.date isTodayFast] && !tile.belongsToAdjacentMonth) {
					self.selectedTile = tile;
					return;
				}
			}
		}
	}

	-(NSArray *) dequeueAndConfigureNextBatchOfCellsForSlide:(int)direction {
		NSMutableArray *nextBatchOfCells = [NSMutableArray array];
		
		// Layout and configure the visible tiles/weeks for the currently selected month.
		NSArray *previousPartials		= [logic daysInFinalWeekOfPreviousMonth];
		NSArray *regularDays			= [logic daysInSelectedMonth];
		NSArray *followingPartials		= [logic daysInFirstWeekOfFollowingMonth];
		
		NSMutableArray *allVisibleDays	= [NSMutableArray array];
		[allVisibleDays addObjectsFromArray:previousPartials];
		[allVisibleDays addObjectsFromArray:regularDays];
		[allVisibleDays addObjectsFromArray:followingPartials];
		
		if ((direction == SLIDE_UP) && ( [previousPartials count] > 0) ) {
			/*
			Remove the first 7 days since they are part of a cell that is already being displayed (the "kept" cell).
			*/
			[allVisibleDays removeObjectsInRange:NSMakeRange(0, 7)];
		}
		else if (direction == SLIDE_DOWN && [followingPartials count] > 0) {
			/*
			Remove the last 7 days since they are part of a cell that is already 
			being displayed (the "kept" cell).
			*/
			NSUInteger loc = [allVisibleDays count] - 7;
			[allVisibleDays removeObjectsInRange:NSMakeRange(loc, 7)];
		}
		
		CGFloat verticalOffset	= 0.f;
		BOOL done				= NO;
		while (!done) {
			UXView *cell	= [reusableCells dequeue];
			cell.top		= verticalOffset;
			verticalOffset	+= cellHeight;
			for (UXCalendarTileView *tile in cell.subviews) {
				[tile prepareForReuse];
				NSDate *date				= [allVisibleDays objectAtIndex:0];
				tile.date					= date;
				tile.belongsToAdjacentMonth = [previousPartials indexOfObject:date] != NSNotFound || [followingPartials indexOfObject:date] != NSNotFound;
				tile.marked					= [delegate shouldMarkTileForDate:date];
				if ([date isEqualToDate:logic.baseDate]) {
					self.selectedTile = tile;
				}
				[allVisibleDays removeObjectAtIndex:0];
			}
			[nextBatchOfCells addObject:cell];
			done = [allVisibleDays count] == 0;
		}
		return nextBatchOfCells;
	}

	-(void) initializeCell:(UXView *)cell {
		const CGRect kTileFrame = { CGPointZero, kTileSize };
		for (NSUInteger i = 0; i < 7; i++) {
			UXCalendarTileView *tile = [[UXCalendarTileView alloc] initWithFrame:kTileFrame];
			tile.left	= i * kTileSize.width; // horizontal layout
			tile.date	= [NSDate distantPast];
			[cell addSubview:tile];
			[tile release];
		}
	}


	#pragma mark Slide Animation

	-(void) slide:(int)direction cells:(NSArray *)nextBatchOfCells keepOneRow:(BOOL)keepOneRow {
		// Get a reference to the single cell to be kept (or none if not requested by the client)
		UXView *keptCell = nil;
		if (keepOneRow) {
			CGFloat searchPattern = direction == SLIDE_UP ? self.height - cellHeight : 0.f;
			for (UXView *cell in self.subviews) {
				if (cell.top == searchPattern) {
					keptCell = cell;
					break;
				}
			}
			[self updateTilesInKeptCell:keptCell];
			if (direction == SLIDE_UP) {
				BOOL alreadyHasSelection = NO;
				for (UXCalendarTileView *tile in keptCell.subviews) {
					if (tile.selected) {
						alreadyHasSelection = YES;
						break;
					}
				}
				if (!alreadyHasSelection) {
					for (UXCalendarTileView *tile in keptCell.subviews) {
						if ([tile.date isEqualToDate:logic.baseDate]) {
							self.selectedTile = tile;
							break;
						}
					}
				}
			}
			NSAssert(keptCell, @"The client requested that we keep one row, but I couldn't find the correct row to keep!");
		}
		
		// Take the fresh cells and apply a simple vertical layout
		// such that the entire batch is immediately above or below
		// the last cell that is currently being shown.
		// The decision whether to place it above or below
		// is based on the direction that we are sliding.
		// Finally, add it as a subview.
		CGFloat verticalOffset = 0.f;
		for (UXView *cell in nextBatchOfCells) {
			cell.top		= direction == SLIDE_UP ? self.height + verticalOffset : -1 * ([nextBatchOfCells count] * cellHeight - verticalOffset);
			[self addSubview:cell];
			verticalOffset	+= cellHeight;
		}
		
		// Slide each cell with animation.
		[UIView beginAnimations:kSlideAnimationId context:NULL];
		{
			[UIView setAnimationsEnabled:YES];
			[UIView setAnimationDuration:0.45f];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
			
			CGFloat dy = direction == SLIDE_UP ? -1 * (self.height - (keepOneRow ? cellHeight : 0.f)) : [nextBatchOfCells count] * cellHeight;
			
			for (UXView *cell in self.subviews) {
				cell.top += dy;
			}
			// Resize |self| such that it is just tall enough to fit the kept row (if any) and the new rows that we are adding.
			self.height = keptCell.height + [[nextBatchOfCells valueForKeyPath:@"@sum.height"] floatValue];
		}
		[UIView commitAnimations];
	}

	/*!
	At this point, the calendar logic has already been advanced or retreated to the
	following/previous month, so in order to determine whether there are
	any cells to keep, we need to check for a partial week in the month
	that is sliding offscreen.
	*/
	-(void) slide:(int)direction {
		NSArray *cells = [self dequeueAndConfigureNextBatchOfCellsForSlide:direction];
		BOOL keepOneRow = NO;
		
		if ((direction == SLIDE_UP) && ( [[logic daysInFinalWeekOfPreviousMonth] count] > 0) ) {
			keepOneRow = YES;
		}
		else if (direction == SLIDE_DOWN  && [[logic daysInFirstWeekOfFollowingMonth] count] > 0) {
			keepOneRow = YES;
		}
		[self slide:direction cells:cells keepOneRow:keepOneRow];
	}

	-(void) slideUp {
		[self slide:SLIDE_UP];
	}

	-(void) slideDown {
		[self slide:SLIDE_DOWN];
	}

	/*!
	Reuse every cell that is no longer visible after the slide animation.
	*/
	-(void) animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
		for (UXView *cell in self.subviews) {
			if ((cell.bottom <= 0) || (cell.bottom > self.height) ) {
				[[cell retain] autorelease];
				[cell removeFromSuperview];
				[reusableCells enqueue:cell];
			}
		}
	}


	#pragma mark Destructor

	-(void) dealloc {
		[selectedTile release];
		[reusableCells release];
		[logic release];
		[super dealloc];
	}

@end
