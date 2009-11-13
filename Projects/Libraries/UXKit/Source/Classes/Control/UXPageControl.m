
#import <UXKit/UXPageControl.h>
#import <UXKit/UXStyleSheet.h>
#import <UXKit/UXStyle.h>

@implementation UXPageControl

	@synthesize numberOfPages	= _numberOfPages;
	@synthesize currentPage		= _currentPage;
	@synthesize dotStyle		= _dotStyle;
	@synthesize hidesForSinglePage = _hidesForSinglePage;


	#pragma mark Styles

	-(UXStyle *) normalDotStyle {
		if (!_normalDotStyle) {
			_normalDotStyle = [[[UXStyleSheet globalStyleSheet] styleWithSelector:_dotStyle forState:UIControlStateNormal] retain];
		}
		return _normalDotStyle;
	}

	-(UXStyle *) currentDotStyle {
		if (!_currentDotStyle) {
			_currentDotStyle = [[[UXStyleSheet globalStyleSheet] styleWithSelector:_dotStyle forState:UIControlStateSelected] retain];
		}
		return _currentDotStyle;
	}


	#pragma mark NSObject

	-(id) initWithFrame:(CGRect)frame {
		if (self = [super initWithFrame:frame]) {
			_numberOfPages			= 0;
			_currentPage			= 0;
			_dotStyle				= nil;
			_normalDotStyle			= nil;
			_currentDotStyle		= nil;
			_hidesForSinglePage		= NO;
			self.backgroundColor	= [UIColor clearColor];
			self.dotStyle			= @"pageDot:";
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_dotStyle);
		UX_SAFE_RELEASE(_normalDotStyle);
		UX_SAFE_RELEASE(_currentDotStyle);
		[super dealloc];
	}


	#pragma mark UIView

	-(void) drawRect:(CGRect)rect {
		if ((_numberOfPages > 1) || _hidesForSinglePage) {
			UXStyleContext *context = [[[UXStyleContext alloc] init] autorelease];
			UXBoxStyle *boxStyle = [self.normalDotStyle firstStyleOfClass:[UXBoxStyle class ]];
			
			CGSize dotSize = [self.normalDotStyle addToSize:CGSizeZero context:context];
			
			CGFloat dotWidth = dotSize.width + boxStyle.margin.left + boxStyle.margin.right;
			CGFloat totalWidth = (dotWidth * _numberOfPages) - (boxStyle.margin.left + boxStyle.margin.right);
			CGRect contentRect = CGRectMake(round(self.width / 2 - totalWidth / 2),
											round(self.height / 2 - dotSize.height / 2),
											dotSize.width, dotSize.height);
			
			for (NSInteger i = 0; i < _numberOfPages; ++i) {
				contentRect.origin.x += boxStyle.margin.left;
				
				context.frame = contentRect;
				context.contentFrame = contentRect;
				
				if (i == _currentPage) {
					[self.currentDotStyle draw:context];
				}
				else {
					[self.normalDotStyle draw:context];
				}
				contentRect.origin.x += dotSize.width + boxStyle.margin.right;
			}
		}
	}

	-(CGSize) sizeThatFits:(CGSize)size {
		UXStyleContext *context	= [[[UXStyleContext alloc] init] autorelease];
		CGSize dotSize				= [self.normalDotStyle addToSize:CGSizeZero context:context];
		CGFloat margin				= 0;
		UXBoxStyle *boxStyle		= [self.normalDotStyle firstStyleOfClass:[UXBoxStyle class ]];
		if (boxStyle) {
			margin = boxStyle.margin.right + boxStyle.margin.left;
		}
		return CGSizeMake((dotSize.width * _numberOfPages) + (margin * (_numberOfPages - 1)), dotSize.height);
	}


	#pragma mark UIControl

	-(void) endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
		if (self.touchInside) {
			CGPoint point		= [touch locationInView:self];
			self.currentPage	= round(point.x / self.width);
			[self sendActionsForControlEvents:UIControlEventValueChanged];
		}
	}


	#pragma mark API

	-(void) setNumberOfPages:(NSInteger)numberOfPages {
		if (numberOfPages != _numberOfPages) {
			_numberOfPages = numberOfPages;
			[self setNeedsDisplay];
		}
	}

	-(void) setCurrentPage:(NSInteger)currentPage {
		if (currentPage != _currentPage) {
			_currentPage = currentPage;
			[self setNeedsDisplay];
		}
	}

	-(void)setDotStyle:(NSString *)dotStyle {
		if (![dotStyle isEqualToString:_dotStyle]) {
			[_dotStyle release];
			_dotStyle = [dotStyle copy];
			UX_SAFE_RELEASE(_normalDotStyle);
			UX_SAFE_RELEASE(_currentDotStyle);
		}
	}

@end
