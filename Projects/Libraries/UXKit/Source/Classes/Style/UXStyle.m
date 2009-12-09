
#import <UXKit/UXStyle.h>
#import <UXKit/UXShape.h>
#import <UXKit/UXURLCache.h>
#import <UXKit/UXCoding.h>

static const NSInteger kDefaultLightSource = 125;

#define ZEROLIMIT(_VALUE) (_VALUE < 0 ? 0 : (_VALUE > 1 ? 1 : _VALUE))

@implementation UXStyleContext

	@synthesize delegate		= _delegate;
	@synthesize frame			= _frame;
	@synthesize contentFrame	= _contentFrame;
	@synthesize shape			= _shape;
	@synthesize font			= _font;
	@synthesize didDrawContent	= _didDrawContent;

	#pragma mark <NSObject>

	-(id) init {
		if (self = [super init]) {
			_delegate		= nil;
			_frame			= CGRectZero;
			_contentFrame	= CGRectZero;
			_shape			= nil;
			_font			= nil;
			_didDrawContent = NO;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_shape);
		UX_SAFE_RELEASE(_font);
		[super dealloc];
	}


	#pragma mark API

	-(UXShape *) shape {
		if (!_shape) {
			_shape = [[UXRectangleShape shape] retain];
		}
		return _shape;
	}

@end

#pragma mark -

@implementation UXStyle

	@synthesize next = _next;

	#pragma mark -

	-(CGGradientRef) newGradientWithColors:(UIColor **)colors locations:(CGFloat *)locations count:(int)count {
		CGFloat *components = malloc(sizeof(CGFloat) * 4 * count);
		for (int i = 0; i < count; ++i) {
			UIColor *color		= colors[i];
			size_t n			= CGColorGetNumberOfComponents(color.CGColor);
			const CGFloat *rgba = CGColorGetComponents(color.CGColor);
			if (n == 2) {
				components[i * 4]	  = rgba[0];
				components[i * 4 + 1] = rgba[0];
				components[i * 4 + 2] = rgba[0];
				components[i * 4 + 3] = rgba[1];
			}
			else if (n == 4) {
				components[i * 4]	  = rgba[0];
				components[i * 4 + 1] = rgba[1];
				components[i * 4 + 2] = rgba[2];
				components[i * 4 + 3] = rgba[3];
			}
		}
		
		CGContextRef context	= UIGraphicsGetCurrentContext();
		CGColorSpaceRef space	= CGBitmapContextGetColorSpace(context);
		CGGradientRef gradient	= CGGradientCreateWithColorComponents(space, components, locations, count);
		free(components);
		return gradient;
	}

	-(CGGradientRef) newGradientWithColors:(UIColor **)colors count:(int)count {
		return [self newGradientWithColors:colors locations:nil count:count];
	}


	#pragma mark @UXStyle

	-(id) initWithNext:(UXStyle *)aNextStyle {
		if (self = [super init]) {
			_next = [aNextStyle retain];
		}
		return self;
	}


	#pragma mark <NSObject>

	-(id) init {
		return [self initWithNext:nil];
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_next);
		[super dealloc];
	}


	#pragma mark <NSCopying>

	-(id) copyWithZone:(NSZone *)zone {
		return [[NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]] retain];
	}

	#pragma mark <NSCoding>

	-(id) initWithCoder:(NSCoder *)decoder {
		if ((self = [super init])) {
			DECODE_OBJ(@"next");
		}
		return self;
	}

	-(void) encodeWithCoder:(NSCoder *)encoder {
		ENCODE_OBJ(@"next");
	}


	#pragma mark @UXStyle

	-(UXStyle *) next:(UXStyle *)aNextStyle {
		self.next = aNextStyle;
		return self;
	}


	#pragma mark API

	-(void) draw:(UXStyleContext *)context {
		[self.next draw:context];
	}

	-(UIEdgeInsets) addToInsets:(UIEdgeInsets)insets forSize:(CGSize)size {
		if (self.next) {
			return [self.next addToInsets:insets forSize:size];
		}
		else {
			return insets;
		}
	}

	-(CGSize) addToSize:(CGSize)size context:(UXStyleContext *)context {
		if (_next) {
			return [self.next addToSize:size context:context];
		}
		else {
			return size;
		}
	}

	-(void) addStyle:(UXStyle *)style {
		if (_next) {
			[_next addStyle:style];
		}
		else {
			_next = [style retain];
		}
	}

	-(id) firstStyleOfClass:(Class)cls {
		if ([self isKindOfClass:cls]) {
			return self;
		}
		else {
			return [self.next firstStyleOfClass:cls];
		}
	}

	-(id) styleForPart:(NSString *)name {
		UXStyle *style = self;
		while (style) {
			if ([style isKindOfClass:[UXPartStyle class]]) {
				UXPartStyle *partStyle = (UXPartStyle *)style;
				if ([partStyle.name isEqualToString:name]) {
					return partStyle;
				}
			}
			style = style.next;
		}
		return nil;
	}

@end

#pragma mark -

@implementation UXContentStyle

	#pragma mark Constructor

	+(UXContentStyle *) styleWithNext:(UXStyle *)next {
		return [[[self alloc] initWithNext:next] autorelease];
	}

	#pragma mark @UXStyle

	-(void) draw:(UXStyleContext *)context {
		if ([context.delegate respondsToSelector:@selector(drawLayer:withStyle:)]) {
			[context.delegate drawLayer:context withStyle:self];
			context.didDrawContent = YES;
		}
		
		[self.next draw:context];
	}

@end

#pragma mark -

@implementation UXPartStyle

	@synthesize name	= _name;
	@synthesize style	= _style;

	#pragma mark Constructor

	+(UXPartStyle *) styleWithName:(NSString *)name style:(UXStyle *)stylez next:(UXStyle *)next {
		UXPartStyle *style		= [[[self alloc] initWithNext:next] autorelease];
		style.name				= name;
		style.style				= stylez;
		return style;
	}

	#pragma mark <NSCoding>

	-(id) initWithCoder:(NSCoder *)decoder {
		BEGIN_DECODER();
		DECODE_OBJ(@"name");
		DECODE_OBJ(@"style");
		END_DECODER();
		return self;
	}

	-(void) encodeWithCoder:(NSCoder *)encoder {
		BEGIN_ENCODER();
		ENCODE_OBJ(@"name");
		ENCODE_OBJ(@"style");
		END_ENCODER();
	}


	#pragma mark <NSObject>

	-(void) dealloc {
		UX_SAFE_RELEASE(_name);
		UX_SAFE_RELEASE(_style);
		[super dealloc];
	}


	#pragma mark @UXStyle

	-(void) draw:(UXStyleContext *)context {
		[self.next draw:context];
	}


	#pragma mark API

	-(void) drawPart:(UXStyleContext *)context {
		[_style draw:context];
	}

@end

#pragma mark -

@implementation UXShapeStyle

	@synthesize shape = _shape;

	#pragma mark Constructor

	+(UXShapeStyle *) styleWithShape:(UXShape *)shape next:(UXStyle *)next {
		UXShapeStyle *style = [[[self alloc] initWithNext:next] autorelease];
		style.shape			= shape;
		return style;
	}


	#pragma mark Initializer

	-(id) initWithNext:(UXStyle *)next {
		if (self = [super initWithNext:next]) {
			_shape = nil;
		}
		return self;
	}


	#pragma mark <NSCoding>

	-(id) initWithCoder:(NSCoder *)decoder {
		BEGIN_DECODER();
			DECODE_OBJ(@"shape");
		END_DECODER();
		return self;
	}

	-(void) encodeWithCoder:(NSCoder *)encoder {
		BEGIN_ENCODER();
			ENCODE_OBJ(@"shape");
		END_ENCODER();
	}


	#pragma mark <NSObject>

	-(void) dealloc {
		UX_SAFE_RELEASE(_shape);
		[super dealloc];
	}


	#pragma mark @UXStyle

	-(void) draw:(UXStyleContext *)context {
		UIEdgeInsets shapeInsets = [_shape insetsForSize:context.frame.size];
		context.contentFrame	= UXRectInset(context.contentFrame, shapeInsets);
		context.shape			= _shape;
		[self.next draw:context];
	}

	-(UIEdgeInsets) addToInsets:(UIEdgeInsets)insets forSize:(CGSize)size {
		UIEdgeInsets shapeInsets = [_shape insetsForSize:size];
		insets.top		+= shapeInsets.top;
		insets.right	+= shapeInsets.right;
		insets.bottom	+= shapeInsets.bottom;
		insets.left		+= shapeInsets.left;
		
		if (self.next) {
			return [self.next addToInsets:insets forSize:size];
		}
		else {
			return insets;
		}
	}

	-(CGSize) addToSize:(CGSize)size context:(UXStyleContext *)context {
		CGSize innerSize		 = [self.next addToSize:size context:context];
		UIEdgeInsets shapeInsets = [_shape insetsForSize:innerSize];
		innerSize.width			 += shapeInsets.left + shapeInsets.right;
		innerSize.height		 += shapeInsets.top  + shapeInsets.bottom;
		return innerSize;
	}

@end

#pragma mark -

@implementation UXInsetStyle

	@synthesize inset = _inset;

	#pragma mark Constructor

	+(UXInsetStyle *) styleWithInset:(UIEdgeInsets)inset next:(UXStyle *)next {
		UXInsetStyle *style = [[[self alloc] initWithNext:next] autorelease];
		style.inset			  = inset;
		return style;
	}

	#pragma mark Initializer

	-(id) initWithNext:(UXStyle *)next {
		if (self = [super initWithNext:next]) {
			_inset = UIEdgeInsetsZero;
		}
		return self;
	}

	#pragma mark <NSCoding>

	-(id) initWithCoder:(NSCoder *)decoder {
		BEGIN_DECODER();
		DECODE_EDGEINSETS(@"inset");
		END_DECODER();
		return self;
	}

	-(void) encodeWithCoder:(NSCoder *)encoder {
		BEGIN_ENCODER();
		ENCODE_EDGEINSETS(@"inset");
		END_ENCODER();
	}


	#pragma mark UXStyle

	-(void) draw:(UXStyleContext *)context {
		CGRect rect		= context.frame;
		context.frame	= CGRectMake(rect.origin.x + _inset.left, 
									 rect.origin.y + _inset.top,
								     rect.size.width  - (_inset.left + _inset.right),
								     rect.size.height - (_inset.top + _inset.bottom));
		[self.next draw:context];
	}

	-(UIEdgeInsets) addToInsets:(UIEdgeInsets)insets forSize:(CGSize)size {
		insets.top		+= _inset.top;
		insets.right	+= _inset.right;
		insets.bottom	+= _inset.bottom;
		insets.left		+= _inset.left;
		if (self.next) {
			return [self.next addToInsets:insets forSize:size];
		}
		else {
			return insets;
		}
	}

@end

#pragma mark -

@implementation UXBoxStyle

	@synthesize margin		= _margin;
	@synthesize padding		= _padding;
	@synthesize minSize		= _minSize;
	@synthesize position	= _position;
	
	#pragma mark Constructor

	+(UXBoxStyle *) styleWithMargin:(UIEdgeInsets)margin next:(UXStyle *)next {
		UXBoxStyle *style = [[[self alloc] initWithNext:next] autorelease];
		style.margin = margin;
		return style;
	}

	+(UXBoxStyle *) styleWithPadding:(UIEdgeInsets)padding next:(UXStyle *)next {
		UXBoxStyle *style = [[[self alloc] initWithNext:next] autorelease];
		style.padding = padding;
		return style;
	}

	+(UXBoxStyle *) styleWithFloats:(UXPosition)position next:(UXStyle *)next {
		UXBoxStyle *style = [[[self alloc] initWithNext:next] autorelease];
		style.position = position;
		return style;
	}

	+(UXBoxStyle *) styleWithMargin:(UIEdgeInsets)margin padding:(UIEdgeInsets)padding next:(UXStyle *)next {
		UXBoxStyle *style = [[[self alloc] initWithNext:next] autorelease];
		style.margin	= margin;
		style.padding	= padding;
		return style;
	}

	+(UXBoxStyle *) styleWithMargin:(UIEdgeInsets)margin padding:(UIEdgeInsets)padding minSize:(CGSize)minSize position:(UXPosition)position next:(UXStyle *)next {
		UXBoxStyle *style = [[[self alloc] initWithNext:next] autorelease];
		style.margin	= margin;
		style.padding	= padding;
		style.minSize	= minSize;
		style.position	= position;
		return style;
	}


	#pragma mark @UXStyle

	-(id) initWithNext:(UXStyle *)next {
		if (self = [super initWithNext:next]) {
			_margin		= UIEdgeInsetsZero;
			_padding	= UIEdgeInsetsZero;
			_minSize	= CGSizeZero;
			_position	= UXPositionStatic;
		}
		return self;
	}

	#pragma mark <NSCoding>

	-(id) initWithCoder:(NSCoder *)decoder {
		BEGIN_DECODER();
			DECODE_EDGEINSETS(@"margin");
			DECODE_EDGEINSETS(@"padding");
			DECODE_SIZE(@"minSize");
			DECODE_OBJ(@"position");
		END_DECODER();
		return self;
	}

	-(void) encodeWithCoder:(NSCoder *)encoder {
		BEGIN_ENCODER();
			ENCODE_EDGEINSETS(@"margin");
			ENCODE_EDGEINSETS(@"padding");
			ENCODE_SIZE(@"minSize");
			ENCODE_OBJ(@"position");
		END_ENCODER();
	}


	#pragma mark UXStyle

	-(void) draw:(UXStyleContext *)context {
		context.contentFrame = UXRectInset(context.contentFrame, _padding);
		[self.next draw:context];
	}

	-(CGSize) addToSize:(CGSize)size context:(UXStyleContext *)context {
		size.width += _padding.left + _padding.right;
		size.height += _padding.top + _padding.bottom;
		
		if (_next) {
			return [self.next addToSize:size context:context];
		}
		else {
			return size;
		}
	}

@end

#pragma mark -

@implementation UXTextStyle

	@synthesize font				= _font;
	@synthesize color				= _color;
	@synthesize shadowColor			= _shadowColor;
	@synthesize shadowOffset		= _shadowOffset;
	@synthesize minimumFontSize		= _minimumFontSize;
	@synthesize numberOfLines		= _numberOfLines;
	@synthesize textAlignment		= _textAlignment;
	@synthesize verticalAlignment	= _verticalAlignment;
	@synthesize lineBreakMode		= _lineBreakMode;

	
	#pragma mark Constructor

	+(UXTextStyle *) styleWithFont:(UIFont *)font next:(UXStyle *)next {
		UXTextStyle *style	= [[[self alloc] initWithNext:next] autorelease];
		style.font				= font;
		return style;
	}

	+(UXTextStyle *) styleWithColor:(UIColor *)color next:(UXStyle *)next {
		UXTextStyle *style	= [[[self alloc] initWithNext:next] autorelease];
		style.color				= color;
		return style;
	}

	+(UXTextStyle *) styleWithFont:(UIFont *)font color:(UIColor *)color next:(UXStyle *)next {
		UXTextStyle *style	= [[[self alloc] initWithNext:next] autorelease];
		style.font				= font;
		style.color				= color;
		return style;
	}

	+(UXTextStyle *) styleWithFont:(UIFont *)font color:(UIColor *)color textAlignment:(UITextAlignment)textAlignment next:(UXStyle *)next {
		UXTextStyle *style	= [[[self alloc] initWithNext:next] autorelease];
		style.font				= font;
		style.color				= color;
		style.textAlignment		= textAlignment;
		return style;
	}

	+(UXTextStyle *) styleWithFont:(UIFont *)font color:(UIColor *)color shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset next:(UXStyle *)next {
		UXTextStyle *style	= [[[self alloc] initWithNext:next] autorelease];
		style.font				= font;
		style.color				= color;
		style.shadowColor		= shadowColor;
		style.shadowOffset		= shadowOffset;
		return style;
	}

	+(UXTextStyle *) styleWithFont:(UIFont *)font color:(UIColor *)color minimumFontSize:(CGFloat)minimumFontSize shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset next:(UXStyle *)next {
		UXTextStyle *style	= [[[self alloc] initWithNext:next] autorelease];
		style.font				= font;
		style.color				= color;
		style.minimumFontSize	= minimumFontSize;
		style.shadowColor		= shadowColor;
		style.shadowOffset		= shadowOffset;
		return style;
	}

	+(UXTextStyle *) styleWithFont:(UIFont *)font color:(UIColor *)color minimumFontSize:(CGFloat)minimumFontSize shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset textAlignment:(UITextAlignment)textAlignment verticalAlignment:(UIControlContentVerticalAlignment)verticalAlignment lineBreakMode:(UILineBreakMode)lineBreakMode numberOfLines:(NSInteger)numberOfLines next:(UXStyle *)next {
		UXTextStyle *style	= [[[self alloc] initWithNext:next] autorelease];
		style.font				= font;
		style.color				= color;
		style.minimumFontSize	= minimumFontSize;
		style.shadowColor		= shadowColor;
		style.shadowOffset		= shadowOffset;
		style.textAlignment		= textAlignment;
		style.verticalAlignment = verticalAlignment;
		style.lineBreakMode		= lineBreakMode;
		style.numberOfLines		= numberOfLines;
		return style;
	}


	#pragma mark Drawing Geometry

	-(CGSize) sizeOfText:(NSString *)text withFont:(UIFont *)font size:(CGSize)size {
		if (_numberOfLines == 1) {
			return [text sizeWithFont:font];
		}
		else {
			CGSize maxSize	= CGSizeMake(size.width, CGFLOAT_MAX);
			CGSize textSize = [text sizeWithFont:font constrainedToSize:maxSize lineBreakMode:_lineBreakMode];
			if (_numberOfLines) {
				CGFloat maxHeight = font.lineHeight * _numberOfLines;
				if (textSize.height > maxHeight) {
					textSize.height = maxHeight;
				}
			}
			return textSize;
		}
	}

	-(CGRect) rectForText:(NSString *)text forSize:(CGSize)size withFont:(UIFont *)font {
		CGRect rect = CGRectZero;
		if ((_textAlignment == UITextAlignmentLeft) && (_verticalAlignment == UIControlContentVerticalAlignmentTop)) {
			rect.size = size;
		}
		else {
			CGSize textSize = [self sizeOfText:text withFont:font size:size];
			if (size.width < textSize.width) {
				size.width = textSize.width;
			}
			
			rect.size = textSize;
			
			if (_textAlignment == UITextAlignmentCenter) {
				rect.origin.x = round(size.width / 2 - textSize.width / 2);
			}
			else if (_textAlignment == UITextAlignmentRight) {
				rect.origin.x = size.width - textSize.width;
			}
			
			if (_verticalAlignment == UIControlContentVerticalAlignmentCenter) {
				rect.origin.y = round(size.height / 2 - textSize.height / 2);
			}
			else if (_verticalAlignment == UIControlContentVerticalAlignmentBottom) {
				rect.origin.y = size.height - textSize.height;
			}
		}
		return rect;
	}

	-(void) drawText:(NSString *)text context:(UXStyleContext *)context {
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		CGContextSaveGState(ctx);
		
		UIFont *font = _font ? _font : context.font;
		
		if (_shadowColor) {
			CGSize offset = CGSizeMake(_shadowOffset.width, -_shadowOffset.height);
			CGContextSetShadowWithColor(ctx, offset, 0, _shadowColor.CGColor);
		}
		
		if (_color) {
			[_color setFill];
		}
		
		CGRect rect = context.contentFrame;
		
		if (_numberOfLines == 1) {
			CGRect titleRect		= [self rectForText:text forSize:rect.size withFont:font];
			titleRect.size = [text drawAtPoint:CGPointMake(titleRect.origin.x + rect.origin.x, titleRect.origin.y + rect.origin.y)
									  forWidth:rect.size.width 
									  withFont:font
								   minFontSize:_minimumFontSize ? _minimumFontSize:font.pointSize
								actualFontSize:nil 
								lineBreakMode:_lineBreakMode
							baselineAdjustment:UIBaselineAdjustmentAlignCenters];
			context.contentFrame	= titleRect;
		}
		else {
			CGRect titleRect		= [self rectForText:text forSize:rect.size withFont:font];
			titleRect				= CGRectOffset(titleRect, rect.origin.x, rect.origin.y);
			rect.size				= [text drawInRect:titleRect withFont:font lineBreakMode:_lineBreakMode alignment:_textAlignment];
			context.contentFrame	= rect;
		}
		CGContextRestoreGState(ctx);
	}


	#pragma mark @UXStyle

	-(id) initWithNext:(UXStyle *)next {
		if (self = [super initWithNext:next]) {
			_font				= nil;
			_color				= nil;
			_minimumFontSize	= 0;
			_shadowColor		= nil;
			_shadowOffset		= CGSizeZero;
			_numberOfLines		= 1;
			_textAlignment		= UITextAlignmentCenter;
			_verticalAlignment	= UIControlContentVerticalAlignmentCenter;
			_lineBreakMode		= UILineBreakModeTailTruncation;
		}
		return self;
	}


	#pragma mark <NSCoding>

	-(id) initWithCoder:(NSCoder *)decoder {
		BEGIN_DECODER();
			DECODE_OBJ(@"font");
			DECODE_OBJ(@"color");
			DECODE_OBJ(@"shadowColor");
			DECODE_OBJ(@"minimumFontSize");
			DECODE_OBJ(@"textAlignment");
			DECODE_OBJ(@"verticalAlignment");
			DECODE_OBJ(@"lineBreakMode");
			DECODE_OBJ(@"numberOfLines");
			DECODE_SIZE(@"shadowOffset");
		END_DECODER();
		return self;
	}

	-(void) encodeWithCoder:(NSCoder *)encoder {
		BEGIN_ENCODER();
			ENCODE_OBJ(@"font");
			ENCODE_OBJ(@"color");
			ENCODE_OBJ(@"shadowColor");
			ENCODE_OBJ(@"minimumFontSize");
			ENCODE_OBJ(@"textAlignment");
			ENCODE_OBJ(@"verticalAlignment");
			ENCODE_OBJ(@"lineBreakMode");
			ENCODE_OBJ(@"numberOfLines");
			ENCODE_SIZE(@"shadowOffset");
		END_ENCODER();
	}


	#pragma mark <NSObject>

	-(void) dealloc {
		UX_SAFE_RELEASE(_font);
		UX_SAFE_RELEASE(_color);
		UX_SAFE_RELEASE(_shadowColor);
		[super dealloc];
	}


	#pragma mark @UXStyle

	-(void) draw:(UXStyleContext *)context {
		if ([context.delegate respondsToSelector:@selector(textForLayerWithStyle:)]) {
			NSString *text = [context.delegate textForLayerWithStyle:self];
			if (text) {
				context.didDrawContent = YES;
				[self drawText:text context:context];
			}
		}
		
		if (!context.didDrawContent && [context.delegate respondsToSelector:@selector(drawLayer:withStyle:)]) {
			[context.delegate drawLayer:context withStyle:self];
			context.didDrawContent = YES;
		}
		[self.next draw:context];
	}

	-(void)setNilValueForKey:(NSString *)key {
		if ([key isEqualToString:@"numberOfLines"]) {
			self.numberOfLines = 1;
		}
		else{
			[super setNilValueForKey:key];
		}
	}


	-(CGSize) addToSize:(CGSize)size context:(UXStyleContext *)context {
		if ([context.delegate respondsToSelector:@selector(textForLayerWithStyle:)]) {
			NSString *text		= [context.delegate textForLayerWithStyle:self];
			UIFont *font		= _font ? _font : context.font;
			CGFloat maxWidth	= context.contentFrame.size.width;
			if (!maxWidth) {
				maxWidth = CGFLOAT_MAX;
			}
			CGFloat maxHeight	= _numberOfLines ? _numberOfLines * font.lineHeight : CGFLOAT_MAX;
			CGSize maxSize		= CGSizeMake(maxWidth, maxHeight);
			CGSize textSize		= [self sizeOfText:text withFont:font size:maxSize];
			
			size.width	+= textSize.width;
			size.height += textSize.height;
		}
		
		if (_next) {
			return [self.next addToSize:size context:context];
		}
		else {
			return size;
		}
	}

@end

#pragma mark -

@implementation UXImageStyle

	@synthesize imageURL		= _imageURL;
	@synthesize image			= _image;
	@synthesize defaultImage	= _defaultImage;
	@synthesize contentMode		= _contentMode;
	@synthesize size			= _size;


	#pragma mark Constructor

	+(UXImageStyle *) styleWithImageURL:(NSString *)anImageURL next:(UXStyle *)next {
		UXImageStyle *style	= [[[self alloc] initWithNext:next] autorelease];
		style.imageURL			= anImageURL;
		return style;
	}

	+(UXImageStyle *) styleWithImageURL:(NSString *)imageURL defaultImage:(UIImage *)defaultImage next:(UXStyle *)next {
		UXImageStyle *style = [[[self alloc] initWithNext:next] autorelease];
		style.imageURL		= imageURL;
		style.defaultImage	= defaultImage;
		return style;
	}

	+(UXImageStyle *) styleWithImageURL:(NSString *)imageURL defaultImage:(UIImage *)defaultImage contentMode:(UIViewContentMode)contentMode size:(CGSize)size next:(UXStyle *)next {
		UXImageStyle *style = [[[self alloc] initWithNext:next] autorelease];
		style.imageURL		= imageURL;
		style.defaultImage	= defaultImage;
		style.contentMode	= contentMode;
		style.size			= size;
		return style;
	}

	+(UXImageStyle *) styleWithImage:(UIImage *)image next:(UXStyle *)next {
		UXImageStyle *style = [[[self alloc] initWithNext:next] autorelease];
		style.image = image;
		return style;
	}

	+(UXImageStyle *) styleWithImage:(UIImage *)image defaultImage:(UIImage *)defaultImage next:(UXStyle *)next {
		UXImageStyle *style = [[[self alloc] initWithNext:next] autorelease];
		style.image			= image;
		style.defaultImage	= defaultImage;
		return style;
	}

	+(UXImageStyle *) styleWithImage:(UIImage *)image defaultImage:(UIImage *)defaultImage contentMode:(UIViewContentMode)contentMode size:(CGSize)size next:(UXStyle *)next {
		UXImageStyle *style = [[[self alloc] initWithNext:next] autorelease];
		style.image			= image;
		style.defaultImage	= defaultImage;
		style.contentMode	= contentMode;
		style.size			= size;
		return style;
	}


	#pragma mark SPI

	-(UIImage *) imageForContext:(UXStyleContext *)context {
		UIImage *image = self.image;
		if (!image && [context.delegate respondsToSelector:@selector(imageForLayerWithStyle:)]) {
			image = [context.delegate imageForLayerWithStyle:self];
		}
		return image;
	}


	#pragma mark @UXStyle
	
	-(id) initWithNext:(UXStyle *)next {
		if (self = [super initWithNext:next]) {
			_imageURL		= nil;
			_image			= nil;
			_defaultImage	= nil;
			_contentMode	= UIViewContentModeScaleToFill;
			_size			= CGSizeZero;
		}
		return self;
	}

	#pragma mark <NSCoding>

	-(id) initWithCoder:(NSCoder *)decoder {
		BEGIN_DECODER();
			DECODE_OBJ(@"imageURL");
			DECODE_IMAGE(@"image");
			DECODE_IMAGE(@"defaultImage");
			DECODE_OBJ(@"contentMode");
			DECODE_SIZE(@"size");
		END_DECODER();
		return self;
	}

	-(void) encodeWithCoder:(NSCoder *)encoder {
		BEGIN_ENCODER();
			ENCODE_OBJ(@"imageURL");
			ENCODE_IMAGE(@"image");
			ENCODE_IMAGE(@"defaultImage");
			ENCODE_OBJ(@"contentMode");
			ENCODE_SIZE(@"size");
		END_ENCODER();
	}


	#pragma mark <NSObject>

	-(void) dealloc {
		UX_SAFE_RELEASE(_imageURL);
		UX_SAFE_RELEASE(_image);
		UX_SAFE_RELEASE(_defaultImage);
		[super dealloc];
	}


	#pragma mark @UXStyle

	-(void) draw:(UXStyleContext *)context {
		UIImage *image = [self imageForContext:context];
		if (image) {
			CGContextRef ctx	= UIGraphicsGetCurrentContext();
			CGContextSaveGState(ctx);
			{
				CGRect rect			= [image convertRect:context.contentFrame withContentMode:_contentMode];
				[context.shape addToPath:rect];
				CGContextClip(ctx);
				[image drawInRect:context.contentFrame contentMode:_contentMode];
			}
			CGContextRestoreGState(ctx);
		}
		return [self.next draw:context];
	}

	-(CGSize) addToSize:(CGSize)aSize context:(UXStyleContext *)context {
		if (_size.width || _size.height) {
			aSize.width		+= _size.width;
			aSize.height	+= _size.height;
		}
		// == or != ?
		else if (_contentMode != UIViewContentModeScaleToFill
				 && _contentMode != UIViewContentModeScaleAspectFill
				 && _contentMode != UIViewContentModeScaleAspectFit) {
			UIImage *image = [self imageForContext:context];
			if (image) {
				aSize.width		+= image.size.width;
				aSize.height	+= image.size.height;
			}
		}
		
		if (_next) {
			return [self.next addToSize:aSize context:context];
		}
		else {
			return aSize;
		}
	}


	#pragma mark API

	-(UIImage *) image {
		if (!_image && _imageURL) {
			_image = [[[UXURLCache sharedCache] imageForURL:_imageURL] retain];
		}
		return _image;
	}

@end

#pragma mark -

@implementation UXMaskStyle

	@synthesize mask = _mask;

	#pragma mark Constructor

	+(UXMaskStyle *) styleWithMask:(UIImage *)mask next:(UXStyle *)next {
		UXMaskStyle *style = [[[self alloc] initWithNext:next] autorelease];
		style.mask = mask;
		return style;
	}


	#pragma mark @UXStyle

	-(id) initWithNext:(UXStyle *)next {
		if (self = [super initWithNext:next]) {
			_mask = nil;
		}
		return self;
	}


	#pragma mark <NSCoding>

	-(id) initWithCoder:(NSCoder *)decoder {
		BEGIN_DECODER();
		DECODE_IMAGE(@"mask");
		END_DECODER();
		return self;
	}

	-(void) encodeWithCoder:(NSCoder *)encoder {
		BEGIN_ENCODER();
		ENCODE_IMAGE(@"mask");
		END_ENCODER();
	}


	#pragma mark <NSObject>

	-(void) dealloc {
		UX_SAFE_RELEASE(_mask);
		[super dealloc];
	}


	#pragma mark @UXStyle

	-(void) draw:(UXStyleContext *)context {
		if (_mask) {
			CGContextRef ctx = UIGraphicsGetCurrentContext();
			CGContextSaveGState(ctx);
			
			// Translate context upside-down to invert the clip-to-mask, which turns the mask upside down
			CGContextTranslateCTM(ctx, 0, context.frame.size.height);
			CGContextScaleCTM(ctx, 1.0, -1.0);
			
			CGRect maskRect = CGRectMake(0, 0, _mask.size.width, _mask.size.height);
			CGContextClipToMask(ctx, maskRect, _mask.CGImage);
			
			[self.next draw:context];
			CGContextRestoreGState(ctx);
		}
		else {
			return [self.next draw:context];
		}
	}

@end

#pragma mark -

@implementation UXBlendStyle

	@synthesize blendMode = _blendMode;

	#pragma mark Constructor

	+(UXBlendStyle *) styleWithBlend:(CGBlendMode)aBlendMode next:(UXStyle *)next {
		UXBlendStyle *style = [[[self alloc] initWithNext:next] autorelease];
		style.blendMode		= aBlendMode;
		return style;
	}


	#pragma mark Initializer

	-(id) initWithNext:(UXStyle *)aStyle {
		if (self = [super initWithNext:aStyle]) {
			_blendMode = kCGBlendModeNormal;
		}
		return self;
	}

	-(void) dealloc {
		[super dealloc];
	}

	#pragma mark @UXStyle

	-(void) draw:(UXStyleContext *)context {
		if (_blendMode) {
			CGContextRef ctx = UIGraphicsGetCurrentContext();
			CGContextSaveGState(ctx);
			{
				CGContextSetBlendMode(ctx, _blendMode);
				[self.next draw:context];
			}
			CGContextRestoreGState(ctx);
		}
		else {
			return [self.next draw:context];
		}
	}

@end

#pragma mark -

@implementation UXSolidFillStyle

	@synthesize color = _color;

	#pragma mark Constructor

	+(UXSolidFillStyle *) styleWithColor:(UIColor *)color next:(UXStyle *)next {
		UXSolidFillStyle *style = [[[self alloc] initWithNext:next] autorelease];
		style.color				= color;
		return style;
	}


	#pragma mark @UXStyle

	-(id) initWithNext:(UXStyle *)next {
		if (self = [super initWithNext:next]) {
			_color = nil;
		}
		return self;
	}

	
	#pragma mark <NSCoding>

	-(id) initWithCoder:(NSCoder *)decoder {
		BEGIN_DECODER();
			DECODE_OBJ(@"color");
		END_DECODER();
		return self;
	}

	-(void) encodeWithCoder:(NSCoder *)encoder {
		BEGIN_ENCODER();
			ENCODE_OBJ(@"color");
		END_ENCODER();
	}


	#pragma mark <NSObject>

	-(void) dealloc {
		UX_SAFE_RELEASE(_color);
		[super dealloc];
	}


	#pragma mark @UXStyle

	-(void) draw:(UXStyleContext *)context {
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		
		CGContextSaveGState(ctx);
		[context.shape addToPath:context.frame];
		
		[_color setFill];
		CGContextFillPath(ctx);
		CGContextRestoreGState(ctx);
		
		return [self.next draw:context];
	}

@end

#pragma mark -

@implementation UXLinearGradientFillStyle

	@synthesize color1 = _color1;
	@synthesize color2 = _color2;


	#pragma mark Constructor

	+(UXLinearGradientFillStyle *) styleWithColor1:(UIColor *)color1 color2:(UIColor *)color2 next:(UXStyle *)next {
		UXLinearGradientFillStyle *style = [[[self alloc] initWithNext:next] autorelease];
		style.color1 = color1;
		style.color2 = color2;
		return style;
	}


	#pragma mark @UXStyle

	-(id) initWithNext:(UXStyle *)next {
		if (self = [super initWithNext:next]) {
			_color1 = nil;
			_color2 = nil;
		}
		return self;
	}

	
	#pragma mark <NSCoding>

	-(id) initWithCoder:(NSCoder *)decoder {
		BEGIN_DECODER();
		DECODE_OBJ(@"color1");
		DECODE_OBJ(@"color2");
		END_DECODER();
		return self;
	}

	-(void) encodeWithCoder:(NSCoder *)encoder {
		BEGIN_ENCODER();
		ENCODE_OBJ(@"color1");
		ENCODE_OBJ(@"color2");
		END_ENCODER();
	}


	#pragma mark <NSObject>

	-(void) dealloc {
		UX_SAFE_RELEASE(_color1);
		UX_SAFE_RELEASE(_color2);
		[super dealloc];
	}


	#pragma mark UXStyle

	-(void) draw:(UXStyleContext *)context {
		CGContextRef ctx	= UIGraphicsGetCurrentContext();
		CGRect rect			= context.frame;
		
		CGContextSaveGState(ctx);
		[context.shape addToPath:rect];
		CGContextClip(ctx);
		
		UIColor *colors[]		= { _color1, _color2};
		CGGradientRef gradient	= [self newGradientWithColors:colors count:2];
		CGContextDrawLinearGradient(ctx, gradient, CGPointMake(rect.origin.x, rect.origin.y), CGPointMake(rect.origin.x, rect.origin.y + rect.size.height), kCGGradientDrawsAfterEndLocation);
		CGGradientRelease(gradient);
		
		CGContextRestoreGState(ctx);
		
		return [self.next draw:context];
	}

@end

#pragma mark -

@implementation UXReflectiveFillStyle

	@synthesize color = _color;
	@synthesize withBottomHighlight = _withBottomHighlight;

	#pragma mark Constructor

	+(UXReflectiveFillStyle *) styleWithColor:(UIColor *)color next:(UXStyle *)next {
		UXReflectiveFillStyle *style	= [[[self alloc] initWithNext:next] autorelease];
		style.color						= color;
		style.withBottomHighlight		= NO;
		return style;
	}

	+(UXReflectiveFillStyle *) styleWithColor:(UIColor *)aColor withBottomHighlight:(BOOL)flag next:(UXStyle *)aStyle {
		UXReflectiveFillStyle *style	= [[[self alloc] initWithNext:aStyle] autorelease];
		style.color						= aColor;
		style.withBottomHighlight		= flag;
		return style;
	}

	#pragma mark @UXStyle

	-(id) initWithNext:(UXStyle *)aStyle {
		if (self = [super initWithNext:aStyle]) {
			_color = nil;
		}
		return self;
	}


	#pragma mark <NSCoding>

	-(id) initWithCoder:(NSCoder *)decoder {
		BEGIN_DECODER();
			DECODE_OBJ(@"color");
			//DECODE_BOOL(@"withBottomHighlight");
		END_DECODER();
		return self;
	}

	-(void) encodeWithCoder:(NSCoder *)encoder {
		BEGIN_ENCODER();
			ENCODE_OBJ(@"color");
			//ENCODE_BOOL(@"withBottomHighlight");
		END_ENCODER();
	}


	#pragma mark @UXStyle

	-(void) draw:(UXStyleContext *)context {
		CGContextRef ctx	= UIGraphicsGetCurrentContext();
		CGRect rect			= context.frame;
		
		CGContextSaveGState(ctx);
		[context.shape addToPath:rect];
		CGContextClip(ctx);
		
		// Draw the background color
		[_color setFill];
		CGContextFillRect(ctx, rect);
		
		// The highlights are drawn using an overlayed, semi-transparent gradient.
		// The values here are absolutely arbitrary. They were nabbed by inspecting the colors of
		// the "Delete Contact" button in the Contacts app.
		UIColor *topStartHighlight	= [UIColor colorWithWhite:1.0 alpha:0.685];
		UIColor *topEndHighlight	= [UIColor colorWithWhite:1.0 alpha:0.13];
		UIColor *clearColor			= [UIColor colorWithWhite:1.0 alpha:0.0];
		
		UIColor *botEndHighlight;
		if ( _withBottomHighlight ) {
			botEndHighlight = [UIColor colorWithWhite:1.0 alpha:0.27];
		}
		else {
			botEndHighlight = clearColor;
		}
		
		UIColor *colors[] = {
			topStartHighlight, topEndHighlight,
			clearColor,
			clearColor, botEndHighlight
		};
		CGFloat locations[] = {0, 0.5, 0.5, 0.6, 1.0};
		
		CGGradientRef gradient = [self newGradientWithColors:colors locations:locations count:5];
		CGContextDrawLinearGradient(ctx, gradient, CGPointMake(rect.origin.x, rect.origin.y), CGPointMake(rect.origin.x, rect.origin.y + rect.size.height), 0);
		CGGradientRelease(gradient);
		CGContextRestoreGState(ctx);

		return [self.next draw:context];
	}

	#pragma mark <NSObject>

	-(void) dealloc {
		UX_SAFE_RELEASE(_color);
		[super dealloc];
	}

@end

#pragma mark -

@implementation UXShadowStyle

	@synthesize color	= _color;
	@synthesize blur	= _blur;
	@synthesize offset	= _offset;

	#pragma mark Constructor

	+(UXShadowStyle *) styleWithColor:(UIColor *)color blur:(CGFloat)blur offset:(CGSize)offset next:(UXStyle *)next {
		UXShadowStyle *style = [[[self alloc] initWithNext:next] autorelease];
		style.color		= color;
		style.blur		= blur;
		style.offset	= offset;
		return style;
	}


	#pragma mark @UXStyle

	-(id) initWithNext:(UXStyle *)next {
		if (self = [super initWithNext:next]) {
			_color	= nil;
			_blur	= 0;
			_offset = CGSizeZero;
		}
		return self;
	}


	#pragma mark <NSCoding>

	-(id) initWithCoder:(NSCoder *)decoder {
		BEGIN_DECODER();
			DECODE_OBJ(@"color");
			DECODE_OBJ(@"blur");
			DECODE_SIZE(@"offset");
		END_DECODER();
		return self;
	}

	-(void) encodeWithCoder:(NSCoder *)encoder {
		BEGIN_ENCODER();
			ENCODE_OBJ(@"color");
			ENCODE_OBJ(@"blur");
			ENCODE_SIZE(@"offset");
		END_ENCODER();
	}


	#pragma mark <NSObject>

	-(void) dealloc {
		UX_SAFE_RELEASE(_color);
		[super dealloc];
	}


	#pragma mark @UXStyle

	-(void) draw:(UXStyleContext *)context {
		CGFloat blurSize	= round(_blur / 2);
		UIEdgeInsets inset	= UIEdgeInsetsMake(blurSize, blurSize, blurSize, blurSize);
		
		if (_offset.width < 0) {
			inset.left += fabs(_offset.width) + blurSize * 2;
			inset.right -= blurSize;
		}
		else if (_offset.width > 0) {
			inset.right += fabs(_offset.width) + blurSize * 2;
			inset.left -= blurSize;
		}
		if (_offset.height < 0) {
			inset.top += fabs(_offset.height) + blurSize * 2;
			inset.bottom -= blurSize;
		}
		else if (_offset.height > 0) {
			inset.bottom += fabs(_offset.height) + blurSize * 2;
			inset.top -= blurSize;
		}
		
		context.frame			= UXRectInset(context.frame, inset);
		context.contentFrame	= UXRectInset(context.contentFrame, inset);
		
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		CGContextSaveGState(ctx);
		
		[context.shape addToPath:context.frame];
		CGContextSetShadowWithColor(ctx, CGSizeMake(_offset.width, -_offset.height), _blur, _color.CGColor);
		CGContextBeginTransparencyLayer(ctx, nil);
		[self.next draw:context];
		CGContextEndTransparencyLayer(ctx);
		
		CGContextRestoreGState(ctx);
	}

	-(CGSize) addToSize:(CGSize)size context:(UXStyleContext *)context {
		CGFloat blurSize = round(_blur / 2);
		size.width	+= _offset.width + (_offset.width ? blurSize : 0) + blurSize * 2;
		size.height += _offset.height + (_offset.height ? blurSize : 0) + blurSize * 2;
		
		if (_next) {
			return [self.next addToSize:size context:context];
		}
		else {
			return size;
		}
	}

@end

#pragma mark -

@implementation UXInnerShadowStyle

	#pragma mark @UXStyle

	-(void) draw:(UXStyleContext *)context {
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		CGContextSaveGState(ctx);
		
		[context.shape addToPath:context.frame];
		CGContextClip(ctx);
		
		[context.shape addInverseToPath:context.frame];
		[[UIColor whiteColor] setFill];
		CGContextSetShadowWithColor(ctx, CGSizeMake(_offset.width, -_offset.height), _blur, _color.CGColor);
		CGContextEOFillPath(ctx);
		CGContextRestoreGState(ctx);
		
		return [self.next draw:context];
	}

	-(CGSize) addToSize:(CGSize)size context:(UXStyleContext *)context {
		if (_next) {
			return [self.next addToSize:size context:context];
		}
		else {
			return size;
		}
	}

@end

#pragma mark -

@implementation UXSolidBorderStyle

	@synthesize color = _color;
	@synthesize width = _width;
	

	#pragma mark Constructor

	+(UXSolidBorderStyle *) styleWithColor:(UIColor *)color width:(CGFloat)width next:(UXStyle *)next {
		UXSolidBorderStyle *style	= [[[self alloc] initWithNext:next] autorelease];
		style.color					= color;
		style.width					= width;
		return style;
	}


	#pragma mark @UXStyle

	-(id) initWithNext:(UXStyle *)next {
		if (self = [super initWithNext:next]) {
			_color = nil;
			_width = 1;
		}
		return self;
	}


	#pragma mark <NSCoding>

	-(id) initWithCoder:(NSCoder *)decoder {
		BEGIN_DECODER();
			DECODE_OBJ(@"color");
			DECODE_OBJ(@"width");
		END_DECODER();
		return self;
	}

	-(void) encodeWithCoder:(NSCoder *)encoder {
		BEGIN_ENCODER();
			ENCODE_OBJ(@"color");
			ENCODE_OBJ(@"width");
		END_ENCODER();
	}


	#pragma mark <NSObject>

	-(void) dealloc {
		UX_SAFE_RELEASE(_color);
		[super dealloc];
	}


	#pragma mark @UXStyle

	-(void) draw:(UXStyleContext *)context {
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		CGContextSaveGState(ctx);
		
		CGRect strokeRect = CGRectInset(context.frame, _width / 2, _width / 2);
		[context.shape addToPath:strokeRect];
		
		[_color setStroke];
		CGContextSetLineWidth(ctx, _width);
		CGContextStrokePath(ctx);
		
		CGContextRestoreGState(ctx);
		
		context.frame = CGRectInset(context.frame, _width, _width);
		return [self.next draw:context];
	}

@end

#pragma mark -

@implementation UXHighlightBorderStyle

	@synthesize color = _color;
	@synthesize highlightColor = _highlightColor;
	@synthesize width = _width;

	#pragma mark Constructor

	+(UXHighlightBorderStyle *) styleWithColor:(UIColor *)aColor highlightColor:(UIColor *)aHighlightColor width:(CGFloat)aWidth next:(UXStyle *)aStyle {
		UXHighlightBorderStyle *style = [[[self alloc] initWithNext:aStyle] autorelease];
		style.color				= aColor;
		style.highlightColor	= aHighlightColor;
		style.width				= aWidth;
		return style;
	}


	#pragma mark Initialzier

	-(id) initWithNext:(UXStyle *)aStyle {
		if (self = [super initWithNext:aStyle]) {
			_color			= nil;
			_highlightColor = nil;
			_width			= 1;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_color);
		UX_SAFE_RELEASE(_highlightColor);
		[super dealloc];
	}

	#pragma mark UXStyle

	-(void) draw:(UXStyleContext *)context {
		
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		CGContextSaveGState(ctx);
		
		{
			CGRect strokeRect = CGRectInset(context.frame, (_width / 2), (_width / 2));
			strokeRect.size.height -= 2;
			strokeRect.origin.y++;
			[context.shape addToPath:strokeRect];
			
			[_highlightColor setStroke];
			CGContextSetLineWidth(ctx, _width);
			CGContextStrokePath(ctx);
		}
		
		{
			CGRect strokeRect = CGRectInset(context.frame, (_width / 2), (_width / 2));
			strokeRect.size.height -= 2;
			[context.shape addToPath:strokeRect];
			
			[_color setStroke];
			CGContextSetLineWidth(ctx, _width);
			CGContextStrokePath(ctx);
		}
		
		context.frame = CGRectInset(context.frame, _width, (_width * 2));
		return [self.next draw:context];
	}

@end

#pragma mark -

@implementation UXFourBorderStyle

	@synthesize top		= _top;
	@synthesize right	= _right;
	@synthesize bottom	= _bottom;
	@synthesize left	= _left;
	@synthesize width	= _width;


	#pragma mark Constructor

	+(UXFourBorderStyle *) styleWithTop:(UIColor *)top right:(UIColor *)right bottom:(UIColor *)bottom left:(UIColor *)left width:(CGFloat)width next:(UXStyle *)next {
		UXFourBorderStyle *style = [[[self alloc] initWithNext:next] autorelease];
		style.top		= top;
		style.right		= right;
		style.bottom	= bottom;
		style.left		= left;
		style.width		= width;
		return style;
	}

	+(UXFourBorderStyle *) styleWithTop:(UIColor *)top width:(CGFloat)width next:(UXStyle *)next {
		UXFourBorderStyle *style = [[[self alloc] initWithNext:next] autorelease];
		style.top		= top;
		style.width		= width;
		return style;
	}

	+(UXFourBorderStyle *) styleWithRight:(UIColor *)right width:(CGFloat)width next:(UXStyle *)next {
		UXFourBorderStyle *style = [[[self alloc] initWithNext:next] autorelease];
		style.right		= right;
		style.width		= width;
		return style;
	}

	+(UXFourBorderStyle *) styleWithBottom:(UIColor *)bottom width:(CGFloat)width next:(UXStyle *)next {
		UXFourBorderStyle *style = [[[self alloc] initWithNext:next] autorelease];
		style.bottom	= bottom;
		style.width		= width;
		return style;
	}

	+(UXFourBorderStyle *) styleWithLeft:(UIColor *)left width:(CGFloat)width next:(UXStyle *)next {
		UXFourBorderStyle *style = [[[self alloc] initWithNext:next] autorelease];
		style.left		= left;
		style.width		= width;
		return style;
	}


	#pragma mark @UXStyle

	-(id) initWithNext:(UXStyle *)next {
		if (self = [super initWithNext:next]) {
			_top	= nil;
			_right	= nil;
			_bottom = nil;
			_left	= nil;
			_width	= 1;
		}
		return self;
	}


	#pragma mark <NSCoding>

	-(id) initWithCoder:(NSCoder *)decoder {
		BEGIN_DECODER();
			DECODE_OBJ(@"top");
			DECODE_OBJ(@"right");
			DECODE_OBJ(@"bottom");
			DECODE_OBJ(@"left");
			DECODE_OBJ(@"width");
		END_DECODER();
		return self;
	}

	-(void) encodeWithCoder:(NSCoder *)encoder {
		BEGIN_ENCODER();
			ENCODE_OBJ(@"top");
			ENCODE_OBJ(@"right");
			ENCODE_OBJ(@"bottom");
			ENCODE_OBJ(@"left");
			ENCODE_OBJ(@"width");
		END_ENCODER();
	}


	#pragma mark <NSObject>

	-(void) dealloc {
		UX_SAFE_RELEASE(_top);
		UX_SAFE_RELEASE(_right);
		UX_SAFE_RELEASE(_bottom);
		UX_SAFE_RELEASE(_left);
		[super dealloc];
	}


	#pragma mark @UXStyle

	-(void) draw:(UXStyleContext *)context {
		CGRect rect = context.frame;
		CGRect strokeRect = CGRectInset(rect, _width / 2, _width / 2);
		[context.shape openPath:strokeRect];
		
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		CGContextSetLineWidth(ctx, _width);
		
		[context.shape addTopEdgeToPath:strokeRect lightSource:kDefaultLightSource];
		if (_top) {
			[_top setStroke];
		}
		else {
			[[UIColor clearColor] setStroke];
		}
		CGContextStrokePath(ctx);
		
		[context.shape addRightEdgeToPath:strokeRect lightSource:kDefaultLightSource];
		if (_right) {
			[_right setStroke];
		}
		else {
			[[UIColor clearColor] setStroke];
		}
		CGContextStrokePath(ctx);
		
		[context.shape addBottomEdgeToPath:strokeRect lightSource:kDefaultLightSource];
		if (_bottom) {
			[_bottom setStroke];
		}
		else {
			[[UIColor clearColor] setStroke];
		}
		CGContextStrokePath(ctx);
		
		[context.shape addLeftEdgeToPath:strokeRect lightSource:kDefaultLightSource];
		if (_left) {
			[_left setStroke];
		}
		else {
			[[UIColor clearColor] setStroke];
		}
		CGContextStrokePath(ctx);
		
		CGContextRestoreGState(ctx);
		
		context.frame = CGRectMake(rect.origin.x + (_left ? _width : 0),
								   rect.origin.y + (_top ? _width : 0),
								   rect.size.width - ((_left ? _width : 0) + (_right ? _width : 0)),
								   rect.size.height - ((_top ? _width : 0) + (_bottom ? _width : 0)));
		return [self.next draw:context];
	}

@end

#pragma mark -

@implementation UXBevelBorderStyle

	@synthesize highlight	= _highlight;
	@synthesize shadow		= _shadow; 
	@synthesize width		= _width;
	@synthesize lightSource = _lightSource;

	#pragma mark Constructor

	+(UXBevelBorderStyle *) styleWithColor:(UIColor *)color width:(CGFloat)width next:(UXStyle *)next {
		return [self styleWithHighlight:[color highlight] shadow:[color shadow] width:width lightSource:kDefaultLightSource next:next];
	}

	+(UXBevelBorderStyle *) styleWithHighlight:(UIColor *)highlight shadow:(UIColor *)shadow width:(CGFloat)width lightSource:(NSInteger)lightSource next:(UXStyle *)next {
		UXBevelBorderStyle *style = [[[UXBevelBorderStyle alloc] initWithNext:next] autorelease];
		style.highlight		= highlight;
		style.shadow		= shadow;
		style.width			= width;
		style.lightSource	= lightSource;
		return style;
	}


	#pragma mark @UXStyle

	-(id) initWithNext:(UXStyle *)next {
		if (self = [super initWithNext:next]) {
			_highlight		= nil;
			_shadow			= nil;
			_width			= 1;
			_lightSource	= kDefaultLightSource;
		}
		return self;
	}


	#pragma mark <NSCoding>

	-(id) initWithCoder:(NSCoder *)decoder {
		BEGIN_DECODER();
		DECODE_OBJ(@"highlight");
		DECODE_OBJ(@"shadow");
		DECODE_OBJ(@"width");
		DECODE_OBJ(@"lightSource");
		END_DECODER();
		return self;
	}

	-(void) encodeWithCoder:(NSCoder *)encoder {
		BEGIN_ENCODER();
		ENCODE_OBJ(@"highlight");
		ENCODE_OBJ(@"shadow");
		ENCODE_OBJ(@"width");
		ENCODE_OBJ(@"lightSource");
		END_ENCODER();
	}


	#pragma mark <NSObject>

	-(void) dealloc {
		UX_SAFE_RELEASE(_highlight);
		UX_SAFE_RELEASE(_shadow);
		[super dealloc];
	}


	#pragma mark @UXStyle

	-(void) draw:(UXStyleContext *)context {
		CGRect strokeRect = CGRectInset(context.frame, _width / 2, _width / 2);
		[context.shape openPath:strokeRect];
		
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		CGContextSetLineWidth(ctx, _width);
		
		UIColor *topColor		= _lightSource >= 0 && _lightSource <= 180 ? _highlight : _shadow;
		UIColor *leftColor		= _lightSource >= 90 && _lightSource <= 270 ? _highlight : _shadow;
		UIColor *bottomColor	= _lightSource >= 180 && _lightSource <= 360 || _lightSource == 0 ? _highlight : _shadow;
		UIColor *rightColor		= (_lightSource >= 270 && _lightSource <= 360) || (_lightSource >= 0 && _lightSource <= 90) ? _highlight : _shadow;
		CGRect rect				= context.frame;
		
		[context.shape addTopEdgeToPath:strokeRect lightSource:_lightSource];
		if (topColor) {
			[topColor setStroke];
			rect.origin.y		+= _width;
			rect.size.height	-= _width;
		}
		else {
			[[UIColor clearColor] setStroke];
		}
		CGContextStrokePath(ctx);
		
		[context.shape addRightEdgeToPath:strokeRect lightSource:_lightSource];
		if (rightColor) {
			[rightColor setStroke];
			rect.size.width -= _width;
		}
		else {
			[[UIColor clearColor] setStroke];
		}
		CGContextStrokePath(ctx);
		
		[context.shape addBottomEdgeToPath:strokeRect lightSource:_lightSource];
		if (bottomColor) {
			[bottomColor setStroke];
			rect.size.height -= _width;
		}
		else {
			[[UIColor clearColor] setStroke];
		}
		CGContextStrokePath(ctx);
		
		[context.shape addLeftEdgeToPath:strokeRect lightSource:_lightSource];
		if (leftColor) {
			[leftColor setStroke];
			rect.origin.x += _width;
			rect.size.width -= _width;
		}
		else {
			[[UIColor clearColor] setStroke];
		}
		CGContextStrokePath(ctx);
		CGContextRestoreGState(ctx);
		
		context.frame = rect;
		return [self.next draw:context];
	}

@end

#pragma mark -

@implementation UXLinearGradientBorderStyle

	@synthesize color1		= _color1;
	@synthesize color2		= _color2;
	@synthesize location1	= _location1; 
	@synthesize location2	= _location2;
	@synthesize width		= _width;

	#pragma mark Constructor

	+(UXLinearGradientBorderStyle *) styleWithColor1:(UIColor *)firstColor color2:(UIColor *)secondColor width:(CGFloat)aWidth next:(UXStyle *)aStyle {
		UXLinearGradientBorderStyle *style = [[[UXLinearGradientBorderStyle alloc] initWithNext:aStyle] autorelease];
		style.color1	= firstColor;
		style.color2	= secondColor;
		style.width		= aWidth;
		return style;
	}

	+(UXLinearGradientBorderStyle *) styleWithColor1:(UIColor *)color1 location1:(CGFloat)location1 color2:(UIColor *)color2 location2:(CGFloat)location2 width:(CGFloat)width next:(UXStyle *)next {
		UXLinearGradientBorderStyle *style = [[[UXLinearGradientBorderStyle alloc] initWithNext:next] autorelease];
		style.color1	= color1;
		style.color2	= color2;
		style.width		= width;
		style.location1 = location1;
		style.location2 = location2;
		return style;
	}


	#pragma mark <NSObject>

	-(id) initWithNext:(UXStyle *)aNextStyle {
		if (self = [super initWithNext:aNextStyle]) {
			_color1		= nil;
			_color2		= nil;
			_location1	= 0;
			_location2	= 1;
			_width		= 1;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_color1);
		UX_SAFE_RELEASE(_color2);
		[super dealloc];
	}


	#pragma mark <NSCoding>

	-(id) initWithCoder:(NSCoder *)decoder {
		BEGIN_DECODER();
			DECODE_OBJ(@"color1");
			DECODE_OBJ(@"color2");
			DECODE_OBJ(@"width");
			DECODE_OBJ(@"location1");
			DECODE_OBJ(@"location2");
		END_DECODER();
		return self;
	}

	-(void) encodeWithCoder:(NSCoder *)encoder {
		BEGIN_ENCODER();
			ENCODE_OBJ(@"color1");
			ENCODE_OBJ(@"color1");
			ENCODE_OBJ(@"width");
			ENCODE_OBJ(@"location1");
			ENCODE_OBJ(@"location2");
		END_ENCODER();
	}

	#pragma mark @UXStyle

	-(void) draw:(UXStyleContext *)context {
		CGContextRef ctx	= UIGraphicsGetCurrentContext();
		CGRect rect			= context.frame;
		
		CGContextSaveGState(ctx);
		{
			CGRect strokeRect = CGRectInset(context.frame, _width / 2, _width / 2);
			[context.shape addToPath:strokeRect];
			CGContextSetLineWidth(ctx, _width);
			CGContextReplacePathWithStrokedPath(ctx);
			CGContextClip(ctx);
			
			UIColor *colors[]		= {_color1, _color2};
			CGFloat locations[]		= {_location1, _location2};
			CGGradientRef gradient	= [self newGradientWithColors:colors locations:locations count:2];
			CGContextDrawLinearGradient(ctx, gradient, CGPointMake(rect.origin.x, rect.origin.y), CGPointMake(rect.origin.x, rect.origin.y + rect.size.height), kCGGradientDrawsAfterEndLocation);
			CGGradientRelease(gradient);
		}
		CGContextRestoreGState(ctx);
		
		context.frame		= CGRectInset(context.frame, _width, _width);
		return [self.next draw:context];
	}

@end

#pragma mark -

@implementation UXRadialGradientFillStyle

	@synthesize firstColor;
	@synthesize secondColor;
	
	#pragma mark Constructor

	+(UXRadialGradientFillStyle *) styleWithFirstColor:(UIColor *)aFirstColor secondColor:(UIColor *)aSecondColor next:(UXStyle *)aStyle {
		UXRadialGradientFillStyle *style = [[[self alloc] initWithNext:aStyle] autorelease];
		style.firstColor	= aFirstColor;
		style.secondColor	= aSecondColor;
		return style;
	}

	
	#pragma mark Initializer

	-(id) initWithNext:(UXStyle *)aStyle {
		if (self = [super initWithNext:aStyle]) {
			firstColor	= nil;
			secondColor = nil;
		}
		return self;
	}


	#pragma mark <NSCoding>

	-(id) initWithCoder:(NSCoder *)decoder {
		BEGIN_DECODER();
			DECODE_OBJ(@"firstColor");
			DECODE_OBJ(@"secondColor");
		END_DECODER();
		return self;
	}

	-(void) encodeWithCoder:(NSCoder *)encoder {
		BEGIN_ENCODER();
			ENCODE_OBJ(@"firstColor");
			ENCODE_OBJ(@"secondColor");
		END_ENCODER();
	}


	#pragma mark -

	-(void) dealloc {
		UX_SAFE_RELEASE(firstColor);
		UX_SAFE_RELEASE(secondColor);
		[super dealloc];
	}

	
	#pragma mark UXStyle

	-(void) draw:(UXStyleContext *)aStyleContext {
		CGContextRef ctx		= UIGraphicsGetCurrentContext();
		CGRect rect				= aStyleContext.frame;
		CGContextSaveGState(ctx);
		[aStyleContext.shape addToPath:rect];
		CGContextClip(ctx);
		UIColor *colors[]		= {firstColor, secondColor};
		CGGradientRef gradient	= [self newGradientWithColors:colors count:2];
		
		CGContextDrawLinearGradient(ctx,
									gradient,
									CGPointMake(rect.origin.x, rect.origin.y),
									CGPointMake(rect.origin.x, rect.origin.y + rect.size.height),
									kCGGradientDrawsAfterEndLocation);
		
		CGPoint ctr		= CGPointMake(CGRectGetMidX(rect), CGRectGetMidX(rect));
		CGFloat xLength = fabs(CGRectGetMaxX(rect) - ctr.x);
		CGFloat yLength = fabs(CGRectGetMaxY(rect) - ctr.y);
		
		CGContextDrawRadialGradient(ctx, gradient, ctr, 0, ctr, fmin(xLength, yLength), kCGGradientDrawsAfterEndLocation);
		CGGradientRelease(gradient);
		CGContextRestoreGState(ctx);
		
		return [self.next draw:aStyleContext];
	}

@end

#pragma mark -

@implementation UXRadialShine

	@synthesize color;
	@synthesize ovalScaleX;
	@synthesize ovalScaleY;

	#pragma mark API

	+(UXRadialShine *) radialShineWithNext:(UXStyle *)aStyle {
		return [UXRadialShine radialShineWithColor:[[UIColor whiteColor] colorWithAlphaComponent:(40.0 / 255.0)] next:aStyle];
	}

	+(UXRadialShine *) radialShineWithColor:(UIColor *)aColor next:(UXStyle *)aStyle {
		return [UXRadialShine radialShineWithColor:aColor ovalScaleX:(1.0) ovalScaleY:(70.0 / 425.0) next:aStyle];
	}

	+(UXRadialShine *) radialShineWithColor:(UIColor *)aColor ovalScaleX:(CGFloat)aOvalScaleX ovalScaleY:(CGFloat)aOvalScaleY next:(UXStyle *)aStyle {
		UXRadialShine *style = [[[self alloc] initWithNext:aStyle] autorelease];
		style.color			= aColor;
		style.ovalScaleX	= aOvalScaleX;
		style.ovalScaleY	= aOvalScaleY;
		return style;
	}

	#pragma mark NSObject

	-(id) initWithNext:(UXStyle *)aStyle {
		if (self = [super initWithNext:aStyle]) {
			self.color = nil;
		}
		return self;
	}

	#pragma mark UXStyle

	-(void) draw:(UXStyleContext *)context {
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		CGContextSaveGState(ctx);
		{
			[context.shape addToPath:context.frame];
			CGContextClip(ctx);
			// Draw elipse
			CGContextSetFillColorWithColor(ctx, color.CGColor);
			CGContextScaleCTM(ctx, ovalScaleX, ovalScaleY);
			CGContextAddArc(ctx, ((context.frame.origin.x + context.frame.size.width / 2.0) / ovalScaleX),
								 ((context.frame.origin.y + 0.0) / ovalScaleY), 
								 (context.frame.size.width / 2.0 * 425.0 / 270.0), 
								 0.0, (2 * M_PI),  1);
			CGContextFillPath(ctx);
		}
		CGContextRestoreGState(ctx);
		return [self.next draw:context];
	}

	#pragma mark Destroyer!

	-(void) dealloc {
		UX_SAFE_RELEASE(color);
		[super dealloc];
	}

@end
