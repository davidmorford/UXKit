
#import <UXKit/UXView.h>
#import <UXKit/UXStyle.h>
#import <UXKit/UXLayout.h>

@implementation UXView

	@synthesize style = _style;
	@synthesize layout = _layout;

	#pragma mark NSObject

	-(id) initWithFrame:(CGRect)frame {
		if (self = [super initWithFrame:frame]) {
			_style	= nil;
			_layout = nil;
			self.contentMode = UIViewContentModeRedraw;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_style);
		UX_SAFE_RELEASE(_layout);
		[super dealloc];
	}


	#pragma mark UIView

	-(void) drawRect:(CGRect)rect {
		UXStyle *style = self.style;
		if (style) {
			UXStyleContext *context = [[[UXStyleContext alloc] init] autorelease];
			context.delegate = self;
			context.frame = self.bounds;
			context.contentFrame = context.frame;
			
			[style draw:context];
			if (!context.didDrawContent) {
				[self drawContent:self.bounds];
			}
		}
		else {
			[self drawContent:self.bounds];
		}
	}

	-(void) layoutSubviews {
		UXLayout *layout = self.layout;
		if (layout) {
			[layout layoutSubviews:self.subviews forView:self];
		}
	}

	-(CGSize) sizeThatFits:(CGSize)size {
		UXStyleContext *context = [[[UXStyleContext alloc] init] autorelease];
		context.delegate = self;
		context.font = nil;
		return [_style addToSize:CGSizeZero context:context];
	}


	#pragma mark API

	-(void) setStyle:(UXStyle *)style {
		if (style != _style) {
			[_style release];
			_style = [style retain];
			
			[self setNeedsDisplay];
		}
	}

	-(void) drawContent:(CGRect)rect {
	
	}

@end
