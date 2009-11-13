
#import <UXKit/UXLayout.h>

@implementation UXLayout

	-(CGSize) layoutSubviews:(NSArray *)subviews forView:(UIView *)view {
		return CGSizeZero;
	}

@end

#pragma mark -

@implementation UXFlowLayout

	@synthesize padding = _padding;
	@synthesize spacing = _spacing;

	#pragma mark NSObject

	-(id) init {
		if (self = [super init]) {
			_padding = 0;
			_spacing = 0;
		}
		return self;
	}

	-(void) dealloc {
		[super dealloc];
	}

	#pragma mark API

	-(CGSize) layoutSubviews:(NSArray *)subviews forView:(UIView *)view {
		CGFloat x			= _padding;
		CGFloat y			= _padding;
		CGFloat maxX		= 0;
		CGFloat lastHeight	= 0;
		CGFloat maxWidth	= view.width - _padding * 2;
		
		for (UIView *subview in subviews) {
			if (x + subview.width > maxWidth) {
				x = _padding;
				y += subview.height + _spacing;
			}
			
			subview.left	= x;
			subview.top		= y;
			x += subview.width + _spacing;
			if (x > maxX) {
				maxX = x;
			}
			lastHeight = subview.height;
		}
		return CGSizeMake(maxX + _padding, y + lastHeight + _padding);
	}

@end

#pragma mark -

@implementation UXGridLayout

	@synthesize columnCount = _columnCount; 
	@synthesize padding		= _padding;
	@synthesize spacing		= _spacing;
	
	#pragma mark NSObject

	-(id) init {
		if (self = [super init]) {
			_columnCount	= 1;
			_padding		= 0;
			_spacing		= 0;
		}
		return self;
	}

	-(void) dealloc {
		[super dealloc];
	}

	#pragma mark public

	-(CGSize) layoutSubviews:(NSArray *)subviews forView:(UIView *)view {
		
		CGFloat innerWidth	= (view.width - _padding * 2);
		CGFloat width		= ceil(innerWidth / _columnCount);
		CGFloat rowHeight	= 0;
		
		CGFloat x			= _padding;
		CGFloat y			= _padding;
		CGFloat maxX		= 0;
		CGFloat lastHeight	= 0;
		NSInteger column	= 0;
		
		for (UIView *subview in subviews) {
			if (column % _columnCount == 0) {
				x = _padding;
				y += rowHeight + _spacing;
			}
			
			CGSize size		= [subview sizeThatFits:CGSizeMake(width, 0)];
			rowHeight		= size.height;
			subview.frame	= CGRectMake(x, y, width, size.height);
			
			x += subview.width + _spacing;
			if (x > maxX) {
				maxX = x;
			}
			lastHeight = subview.height;
			++column;
		}
		return CGSizeMake(maxX + _padding, y + lastHeight + _padding);
	}

@end
