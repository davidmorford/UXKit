
#import <UXKit/UXLabel.h>
#import <UXKit/UXDefaultStyleSheet.h>

@implementation UXLabel

	@synthesize font = _font; 
	@synthesize text = _text;


	#pragma mark NSObject

	-(id) initWithText:(NSString *)text {
		if (self = [self init]) {
			self.text = text;
		}
		return self;
	}

	-(id) initWithFrame:(CGRect)frame {
		if (self = [super initWithFrame:frame]) {
			_text = nil;
			_font = nil;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_text);
		UX_SAFE_RELEASE(_font);
		[super dealloc];
	}


	#pragma mark UIView

	-(void) drawRect:(CGRect)rect {
		UXStyleContext *context = [[[UXStyleContext alloc] init] autorelease];
		context.delegate		= self;
		context.frame			= self.bounds;
		context.contentFrame	= context.frame;
		context.font			= _font;
		
		[self.style draw:context];
		if (!context.didDrawContent) {
			[self drawContent:self.bounds];
		}
	}

	-(CGSize) sizeThatFits:(CGSize)size {
		UXStyleContext *context = [[[UXStyleContext alloc] init] autorelease];
		context.delegate		= self;
		context.font			= _font;
		context.frame			=  CGRectMake(0, 0, size.width, size.height);
		context.contentFrame	= context.frame;
		return [_style addToSize:CGSizeZero context:context];
	}


	#pragma mark UIAccessibility

	-(BOOL) isAccessibilityElement {
		return YES;
	}

	-(NSString *) accessibilityLabel {
		return _text;
	}

	-(UIAccessibilityTraits) accessibilityTraits {
		return [super accessibilityTraits] | UIAccessibilityTraitStaticText;
	}



	#pragma mark UXStyleDelegate

	-(NSString *) textForLayerWithStyle:(UXStyle *)aStyle {
		return self.text;
	}


	#pragma mark API

	-(UIFont *) font {
		if (!_font) {
			_font = [UXSTYLESHEETPROPERTY(font) retain];
		}
		return _font;
	}

	-(void) setFont:(UIFont *)aFont {
		if (aFont != _font) {
			[_font release];
			_font = [aFont retain];
			[self setNeedsDisplay];
		}
	}

	-(void) setText:(NSString *)aTextString {
		if (aTextString != _text) {
			[_text release];
			_text = [aTextString copy];
			[self setNeedsDisplay];
		}
	}

@end
