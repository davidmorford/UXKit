
#import <UXKit/UXStyledFrame.h>
#import <UXKit/UXStyledNode.h>
#import <UXKit/UXDefaultStyleSheet.h>
#import <UXKit/UXShape.h>

@implementation UXStyledFrame

	@synthesize element		= _element;
	@synthesize nextFrame	= _nextFrame;
	@synthesize bounds		= _bounds;

	#pragma mark NSObject

	-(id) initWithElement:(UXStyledElement *)element {
		if (self = [super init]) {
			_element = element;
			_nextFrame = nil;
			_bounds = CGRectZero;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_nextFrame);
		[super dealloc];
	}


	#pragma mark API

	-(CGFloat) x {
		return _bounds.origin.x;
	}

	-(void) setX:(CGFloat)x {
		_bounds.origin.x = x;
	}

	-(CGFloat) y {
		return _bounds.origin.y;
	}

	-(void) setY:(CGFloat)y {
		_bounds.origin.y = y;
	}

	-(CGFloat) width {
		return _bounds.size.width;
	}

	-(void) setWidth:(CGFloat)width {
		_bounds.size.width = width;
	}

	-(CGFloat) height {
		return _bounds.size.height;
	}

	-(void) setHeight:(CGFloat)height {
		_bounds.size.height = height;
	}

	-(UIFont *) font {
		return nil;
	}

	-(void) drawInRect:(CGRect)rect {
	}

	-(UXStyledBoxFrame *) hitTest:(CGPoint)point {
		return [_nextFrame hitTest:point];
	}

@end

#pragma mark -

@implementation UXStyledBoxFrame

	@synthesize parentFrame = _parentFrame;
	@synthesize firstChildFrame = _firstChildFrame;
	@synthesize style = _style;


	#pragma mark SPI

	-(void) drawSubframes {
		UXStyledFrame *frame = _firstChildFrame;
		while (frame) {
			[frame drawInRect:frame.bounds];
			frame = frame.nextFrame;
		}
	}


	#pragma mark NSObject

	-(id) init {
		if (self = [super init]) {
			_parentFrame = nil;
			_firstChildFrame = nil;
			_style = nil;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_firstChildFrame);
		UX_SAFE_RELEASE(_style);
		[super dealloc];
	}


	#pragma mark <UXStyleDelegate>

	-(void) drawLayer:(UXStyleContext *)context withStyle:(UXStyle *)style {
		if ([style isKindOfClass:[UXTextStyle class]]) {
			UXTextStyle *textStyle = (UXTextStyle *)style;
			UIFont *font = context.font;
			context.font = textStyle.font;
			if (textStyle.color) {
				CGContextRef ctx = UIGraphicsGetCurrentContext();
				CGContextSaveGState(ctx);
				[textStyle.color setFill];
				
				[self drawSubframes];
				
				CGContextRestoreGState(ctx);
			}
			else {
				[self drawSubframes];
			}
			context.font = font;
		}
		else {
			[self drawSubframes];
		}
	}


	#pragma mark UXStyledFrame

	-(UIFont *) font {
		return _firstChildFrame.font;
	}

	-(void) drawInRect:(CGRect)rect {
		if (_style && !CGRectIsEmpty(_bounds)) {
			UXStyleContext *context = [[[UXStyleContext alloc] init] autorelease];
			context.delegate		= self;
			context.frame			= rect;
			context.contentFrame	= rect;
			
			[_style draw:context];
			if (context.didDrawContent) {
				return;
			}
		}
		[self drawSubframes];
	}

	-(UXStyledBoxFrame *) hitTest:(CGPoint)point {
		if (CGRectContainsPoint(_bounds, point)) {
			UXStyledBoxFrame *frame = [_firstChildFrame hitTest:point];
			return frame ? frame : self;
		}
		else if (_nextFrame) {
			return [_nextFrame hitTest:point];
		}
		else {
			return nil;
		}
	}

@end

#pragma mark -

@implementation UXStyledInlineFrame

	@synthesize inlinePreviousFrame = _inlinePreviousFrame;
	@synthesize inlineNextFrame = _inlineNextFrame;

	-(id) init {
		if (self = [super init]) {
			_inlinePreviousFrame = nil;
			_inlineNextFrame = nil;
		}
		return self;
	}

	-(void) dealloc {
		[super dealloc];
	}

	-(UXStyledInlineFrame *) inlineParentFrame {
		if ([_parentFrame isKindOfClass:[UXStyledInlineFrame class]]) {
			return (UXStyledInlineFrame *)_parentFrame;
		}
		else {
			return nil;
		}
	}

@end

#pragma mark -

@implementation UXStyledTextFrame

	@synthesize node = _node; 
	@synthesize text = _text; 
	@synthesize font = _font;

	#pragma mark NSObject

	-(id) initWithText:(NSString *)text element:(UXStyledElement *)element node:(UXStyledTextNode *)node {
		if (self = [super initWithElement:element]) {
			_text = [text retain];
			_node = node;
			_font = nil;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_text);
		UX_SAFE_RELEASE(_font);
		[super dealloc];
	}

	
	#pragma mark API

	-(void) drawInRect:(CGRect)rect {
		[_text drawInRect:rect withFont:_font];
	}

@end

#pragma mark -

@implementation UXStyledImageFrame

	@synthesize imageNode = _imageNode;
	@synthesize style = _style;

	#pragma mark NSObject

	-(id) initWithElement:(UXStyledElement *)element node:(UXStyledImageNode *)node {
		if (self = [super initWithElement:element]) {
			_imageNode = node;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_style);
		[super dealloc];
	}

	-(void) drawImage:(CGRect)rect {
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		CGContextSaveGState(ctx);
		CGContextAddRect(ctx, rect);
		CGContextClip(ctx);
		
		UIImage *image = _imageNode.image ? _imageNode.image : _imageNode.defaultImage;
		[image drawInRect:rect contentMode:UIViewContentModeScaleAspectFit];
		CGContextRestoreGState(ctx);
	}


	#pragma mark UXStyleDelegate

	-(void) drawLayer:(UXStyleContext *)context withStyle:(UXStyle *)style {
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		CGContextSaveGState(ctx);
		[context.shape addToPath:context.frame];
		CGContextClip(ctx);
		
		UIViewContentMode contentMode = UIViewContentModeScaleAspectFit;
		if ([style isMemberOfClass:[UXImageStyle class]]) {
			UXImageStyle *imageStyle = (UXImageStyle *)style;
			contentMode = imageStyle.contentMode;
		}
		
		UIImage *image = _imageNode.image ? _imageNode.image : _imageNode.defaultImage;
		[image drawInRect:context.contentFrame contentMode:contentMode];
		
		CGContextRestoreGState(ctx);
	}


	#pragma mark API

	-(void) drawInRect:(CGRect)rect {
		if (_style) {
			UXStyleContext *context = [[[UXStyleContext alloc] init] autorelease];
			context.delegate = self;
			context.frame = rect;
			context.contentFrame = rect;
			
			[_style draw:context];
			if (!context.didDrawContent) {
				[self drawImage:rect];
			}
		}
		else {
			[self drawImage:rect];
		}
	}

@end
