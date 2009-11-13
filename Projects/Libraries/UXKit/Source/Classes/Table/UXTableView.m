
#import <UXKit/UXTableView.h>
#import <UXKit/UXStyledNode.h>
#import <UXKit/UXStyledTextLabel.h>
#import <UXKit/UXTableViewDelegate.h>

static const CGFloat kCancelHighlightThreshold = 4;

@implementation UXTableView

	@synthesize highlightedLabel	= _highlightedLabel;
	@synthesize contentOrigin		= _contentOrigin;
	
	#pragma mark Initializer

	-(id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
		if (self = [super initWithFrame:frame style:style]) {
			_highlightedLabel		= nil;
			_highlightStartPoint	= CGPointZero;
			_contentOrigin			= 0;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_highlightedLabel);
		[super dealloc];
	}


	#pragma mark UIResponder

	-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
		[super touchesBegan:touches withEvent:event];
		if ([self.delegate respondsToSelector:@selector(tableView:touchesBegan:withEvent:)]) {
			id <UXTableViewDelegate> delegate = (id <UXTableViewDelegate>)self.delegate;
			[delegate tableView:self touchesBegan:touches withEvent:event];
		}
		if (_highlightedLabel) {
			UITouch *touch			= [touches anyObject];
			_highlightStartPoint	= [touch locationInView:self];
		}
		/*
		if (_menuView) {
			UITouch *touch = [touches anyObject];
			CGPoint point = [touch locationInView:_menuView];
			if ((point.y < 0) || (point.y > _menuView.height)) {
				[self hideMenu:YES];
			}
			else {
				UIView *hit = [_menuView hitTest:point withEvent:event];
				if (![hit isKindOfClass:[UIControl class ]]) {
					[self hideMenu:YES];
				}
			}
		}
		*/		
	}

	-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
		[super touchesEnded:touches withEvent:event];
		if ([self.delegate respondsToSelector:@selector(tableView:touchesEnded:withEvent:)]) {
			id <UXTableViewDelegate> delegate = (id <UXTableViewDelegate>)self.delegate;
			[delegate tableView:self touchesEnded:touches withEvent:event];
		}
		
		if (_highlightedLabel) {
			UXStyledElement *element = _highlightedLabel.highlightedNode;
			[element performDefaultAction];
		}
	}


	#pragma mark UIScrollView

	-(void) setContentSize:(CGSize)size {
		if (_contentOrigin) {
			CGFloat minHeight = self.height + _contentOrigin;
			if (size.height < minHeight) {
				size.height = self.height + _contentOrigin;
			}
		}
		
		CGFloat y = self.contentOffset.y;
		[super setContentSize:size];
		if (_contentOrigin) {
			// As described below in setContentOffset, UITableView insists on messing with the
			// content offset sometimes when you change the content size or the height of the table
			self.contentOffset = CGPointMake(0, y);
		}
	}

	-(void) setContentOffset:(CGPoint)point {
		// UITableView (and UIScrollView) are really stupid about resetting the content offset
		// when the table view itself is resized.  There are times when I scroll to a point and then
		// disable scrolling, and I don't want the table view scrolling somewhere else just because
		// it was resized.
		if (self.scrollEnabled) {
			if (!(_contentOrigin && (self.contentOffset.y == _contentOrigin) && (point.y == 0) )) {
				[super setContentOffset:point];
			}
		}
	}


	#pragma mark UITableView

	-(void) reloadData {
		CGFloat y = self.contentOffset.y;
		[super reloadData];
		
		if (_highlightedLabel) {
			self.highlightedLabel = nil;
		}
		
		if (_contentOrigin) {
			self.contentOffset = CGPointMake(0, y);
		}
	}

	-(void) selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition {
		if (!_highlightedLabel) {
			[super selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
		}
	}


	#pragma mark API

	-(void) setHighlightedLabel:(UXStyledTextLabel *)label {
		if (label != _highlightedLabel) {
			_highlightedLabel.highlightedNode = nil;
			[_highlightedLabel release];
			_highlightedLabel = [label retain];
		}
	}

@end
