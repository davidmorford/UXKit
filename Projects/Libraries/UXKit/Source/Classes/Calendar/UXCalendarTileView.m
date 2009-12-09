
#import <UXKit/UXCalendarTileView.h>
#import <UXKit/UXDefaultStyleSheet.h>

@interface UXCalendarTileView ()
	-(void) resetState;
	-(void) setMode:(NSUInteger)mode;
	-(void) reloadStyle;
@end

#pragma mark -

@implementation UXCalendarTileView

	@synthesize date;
	@synthesize style;

	#pragma mark Initializer

	-(id) initWithFrame:(CGRect)frame {
		if (self = [super initWithFrame:frame]) {
			self.opaque				= NO;
			self.backgroundColor	= [UIColor clearColor];
			self.clipsToBounds		= NO;
			[self resetState];
			[self reloadStyle];
		}
		return self;
	}

	-(void) setStyle:(UXStyle *)aStyle {
		if (style != aStyle) {
			[style release];
			style = [aStyle retain];
			[self setNeedsDisplay];
		}
	}


	#pragma mark UIControl

	-(UIControlState) state {
		return [super state] | state;
	}

	/*!
	In order to draw the selection border the same way that Apple does in Calendar.app, 
	we need to extend the tile 1px to the left so that it draws its left border on top of
	the left-adjacent tile's right border (but even this hack does not perfectly mimic the 
	way that Apple draws the bottom border of a selected tile.
	*/
	-(void) setSelected:(BOOL)selected {
		if (!self.belongsToAdjacentMonth) {
			if (self.selected && !selected) {
				// deselection (shrink)
				self.width	-= 1.f;
				self.left	+= 1.f;
			}
			else if (!self.selected && selected) {
				// selection (expand)
				self.width	+= 1.f;
				self.left	-= 1.f;
			}
		}
		[super setSelected:selected];
		[self reloadStyle];
	}


	#pragma mark UIView

	-(void) drawRect:(CGRect)rect {
		if (style) {
			UXStyleContext *context = [[[UXStyleContext alloc] init] autorelease];
			context.delegate		= self;
			context.frame			= self.bounds;
			context.contentFrame	= context.frame;
			[style draw:context];
		}
	}


	#pragma mark UIResponder

	-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
		[[self nextResponder] touchesBegan:touches withEvent:event];
	}
	
	-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
		[[self nextResponder] touchesMoved:touches withEvent:event];
	}
	
	-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
		[[self nextResponder] touchesEnded:touches withEvent:event];
	}
	
	-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
		[[self nextResponder] touchesCancelled:touches withEvent:event];
	}

	/*!
	@abstract It appears that UIControl is swallowing up touch events that try to bubble 
	up the responder chain. So I hook everything up here again.
	*/
	-(UIResponder *) nextResponder {
		return [self superview];
	}

	/*!
	@abstract Always make the tile square to its width.
	*/
	-(CGSize) sizeThatFits:(CGSize)size {
		return CGSizeMake(size.width, size.width);
	}


	#pragma mark <UXStyleDelegate>

	-(NSString *) textForLayerWithStyle:(UXStyle *)style {
		return [NSString stringWithFormat:@"%u", [date day]];
	}


	#pragma mark TileState

	-(void) prepareForReuse {
		[self resetState];
		[self reloadStyle];
	}

	-(void) resetState {
		// Teset UXCalendarTileState
		state = 0;
		
		// Reset UIControlState
		[self setSelected:NO];
		[self setHighlighted:NO];
		[self setEnabled:YES];
	}

	-(void) reloadStyle {
		self.style = UXSTYLEWITHSELECTORSTATE(calendarTileForState:, [self state]);
		[self setNeedsDisplay];
	}

	-(void) setMode:(NSUInteger)mode {
		state = (state & ~UXCalendarTileStateMode) | mode;
	}

	-(void) setDate:(NSDate *)aDate {
		if (date != aDate) {
			[date release];
			date = [aDate retain];
			if ([date isTodayFast]) {
				[self setMode:kUXCalendarTileTypeToday];
				[self reloadStyle];
			}
		}
	}

	-(BOOL) belongsToAdjacentMonth {
		return (state & UXCalendarTileStateMode) == kUXCalendarTileTypeAdjacent;
	}

	-(void) setBelongsToAdjacentMonth:(BOOL)belongsToAdjacentMonth {
		if (belongsToAdjacentMonth) {
			[self setMode:kUXCalendarTileTypeAdjacent];
		}
		else {
			if ([date isTodayFast]) {
				[self setMode:kUXCalendarTileTypeToday];
			}
			else{
				[self setMode:kUXCalendarTileTypeRegular];
			}
		}
		[self reloadStyle];
	}

	-(BOOL) marked {
		return state & UXCalendarTileStateMarked;
	}

	-(void) setMarked:(BOOL)marked {
		if ([self marked] == marked) {
			return;
		}
		if (marked) {
			state |= UXCalendarTileStateMarked;
		}
		else {
			state &= ~UXCalendarTileStateMarked;
		}
		[self reloadStyle];
	}


	#pragma mark -

	-(void) dealloc {
		[style release];
		[date release];
		[super dealloc];
	}

@end
