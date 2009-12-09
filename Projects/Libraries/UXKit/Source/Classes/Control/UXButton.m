
#import <UXKit/UXButton.h>
#import <UXKit/UXDefaultStyleSheet.h>
#import <UXKit/UXURLRequest.h>
#import <UXKit/UXURLResponse.h>
#import <UXKit/UXURLCache.h>

static const CGFloat kHPadding = 8;
static const CGFloat kVPadding = 7;

@interface UXButtonContent : NSObject <UXURLRequestDelegate> {
	UXButton *_button;
	NSString *_title;
	NSString *_imageURL;
	UIImage *_image;
	UXStyle *_style;
	UXURLRequest *_request;
}

	@property (nonatomic, copy) NSString *title;
	@property (nonatomic, copy) NSString *imageURL;
	@property (nonatomic, retain) UIImage *image;
	@property (nonatomic, retain) UXStyle *style;

	-(id) initWithButton:(UXButton *)button;

	-(void) reload;
	-(void) stopLoading;

@end

#pragma mark -

@implementation UXButtonContent

	@synthesize title		= _title; 
	@synthesize imageURL	= _imageURL;
	@synthesize image		= _image;
	@synthesize style		= _style;

	#pragma mark NSObject

	-(id) initWithButton:(UXButton *)aButton {
		if (self = [super init]) {
			_button		= aButton;
			_title		= nil;
			_imageURL	= nil;
			_image		= nil;
			_request	= nil;
			_style		= nil;
		}
		return self;
	}

	-(void) dealloc {
		[_request cancel];
		UX_SAFE_RELEASE(_request);
		UX_SAFE_RELEASE(_title);
		UX_SAFE_RELEASE(_imageURL);
		UX_SAFE_RELEASE(_image);
		UX_SAFE_RELEASE(_style);
		[super dealloc];
	}


	#pragma mark UXURLRequestDelegate

	-(void) requestDidStartLoad:(UXURLRequest *)request {
		[_request release];
		_request = [request retain];
	}

	-(void) requestDidFinishLoad:(UXURLRequest *)request {
		UXURLImageResponse *response = request.response;
		self.image = response.image;
		[_button setNeedsDisplay];
		UX_SAFE_RELEASE(_request);
	}

	-(void) request:(UXURLRequest *)request didFailLoadWithError:(NSError *)error {
		UX_SAFE_RELEASE(_request);
	}

	-(void) requestDidCancelLoad:(UXURLRequest *)request {
		UX_SAFE_RELEASE(_request);
	}


	#pragma mark API

	-(void) setImageURL:(NSString *)aURL {
		if (self.image && _imageURL && [aURL isEqualToString:_imageURL]) {
			return;
		}
		
		[self stopLoading];
		[_imageURL release];
		_imageURL = [aURL retain];
		
		if (_imageURL.length) {
			[self reload];
		}
		else {
			self.image = nil;
			[_button setNeedsDisplay];
		}
	}

	-(void) reload {
		if (!_request && _imageURL) {
			UIImage *image = [[UXURLCache sharedCache] imageForURL:_imageURL];
			if (image) {
				self.image = image;
				[_button setNeedsDisplay];
			}
			else {
				UXURLRequest *request = [UXURLRequest requestWithURL:_imageURL delegate:self];
				request.response		= [[[UXURLImageResponse alloc] init] autorelease];
				[request send];
			}
		}
	}

	-(void) stopLoading {
		[_request cancel];
	}

@end

#pragma mark -

@implementation UXButton

	@synthesize font = _font;
	@synthesize isVertical = _isVertical;

	#pragma mark Constructors

	+(UXButton *) buttonWithStyle:(NSString *)selector {
		UXButton *button = [[[UXButton alloc] init] autorelease];
		[button setStylesWithSelector:selector];
		return button;
	}

	+(UXButton *) buttonWithStyle:(NSString *)selector title:(NSString *)title {
		UXButton *button = [[[UXButton alloc] init] autorelease];
		[button setTitle:title forState:UIControlStateNormal];
		[button setStylesWithSelector:selector];
		return button;
	}


	#pragma mark SPI

	-(id) keyForState:(UIControlState)state {
		static NSString *normal			= @"normal";
		static NSString *highlighted	= @"highlighted";
		static NSString *selected		= @"selected";
		static NSString *disabled		= @"disabled";
		if (state & UIControlStateHighlighted) {
			return highlighted;
		}
		else if (state & UIControlStateSelected) {
			return selected;
		}
		else if (state & UIControlStateDisabled) {
			return disabled;
		}
		else {
			return normal;
		}
	}

	-(UXButtonContent *) contentForState:(UIControlState)state {
		if (!_content) {
			_content = [[NSMutableDictionary alloc] init];
		}
		
		id key						= [self keyForState:state];
		UXButtonContent *content	= [_content objectForKey:key];
		if (!content) {
			content = [[[UXButtonContent alloc] initWithButton:self] autorelease];
			[_content setObject:content forKey:key];
		}
		return content;
	}

	-(UXButtonContent *) contentForCurrentState {
		UXButtonContent *content = nil;
		if (self.selected) {
			content = [self contentForState:UIControlStateSelected];
		}
		else if (self.highlighted) {
			content = [self contentForState:UIControlStateHighlighted];
		}
		else if (!self.enabled) {
			content = [self contentForState:UIControlStateDisabled];
		}
		return content ? content : [self contentForState:UIControlStateNormal];
	}

	-(NSString *) titleForCurrentState {
		UXButtonContent *content = [self contentForCurrentState];
		return content.title ? content.title : [self contentForState:UIControlStateNormal].title;
	}

	-(UIImage *) imageForCurrentState {
		UXButtonContent *content = [self contentForCurrentState];
		return content.image ? content.image : [self contentForState:UIControlStateNormal].image;
	}

	-(UXStyle *) styleForCurrentState {
		UXButtonContent *content = [self contentForCurrentState];
		return content.style ? content.style : [self contentForState:UIControlStateNormal].style;
	}

	-(UIFont *) fontForCurrentState {
		if (_font) {
			return _font;
		}
		else {
			UXStyle *style = [self styleForCurrentState];
			UXTextStyle *textStyle = (UXTextStyle *)[style firstStyleOfClass:[UXTextStyle class]];
			if (textStyle.font) {
				return textStyle.font;
			}
			else {
				return self.font;
			}
		}
	}


	#pragma mark NSObject

	-(id) initWithFrame:(CGRect)frame {
		if (self = [super initWithFrame:frame]) {
			_content				= nil;
			_font					= nil;
			_isVertical				= NO;
			self.backgroundColor	= [UIColor clearColor];
			self.contentMode		= UIViewContentModeRedraw;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_content);
		UX_SAFE_RELEASE(_font);
		[super dealloc];
	}


	#pragma mark UIView

	-(void) drawRect:(CGRect)rect {
		UXStyle *style = [self styleForCurrentState];
		if (style) {
			CGRect textFrame			= self.bounds;
			UXStyleContext *context		= [[[UXStyleContext alloc] init] autorelease];
			context.delegate			= self;
			UXPartStyle *imageStyle		= [style styleForPart:@"image"];
			UXBoxStyle *imageBoxStyle	= nil;
			CGSize imageSize			= CGSizeZero;
			
			if (imageStyle) {
				imageBoxStyle			= [imageStyle.style firstStyleOfClass:[UXBoxStyle class]];
				imageSize				= [imageStyle.style addToSize:CGSizeZero context:context];
				if (_isVertical) {
					CGFloat height			= imageSize.height + imageBoxStyle.margin.top + imageBoxStyle.margin.bottom;
					textFrame.origin.y		+= height;
					textFrame.size.height	-= height;
				}
				else {
					textFrame.origin.x		+= imageSize.width + imageBoxStyle.margin.right;
					textFrame.size.width	-= imageSize.width + imageBoxStyle.margin.right;
				}
			}
			
			context.delegate		= self;
			context.frame			= self.bounds;
			context.contentFrame	= textFrame;
			context.font			= [self fontForCurrentState];
			
			[style draw:context];
			
			if (imageStyle) {
				CGRect frame = context.contentFrame;
				if (_isVertical) {
					frame			= self.bounds;
					frame.origin.x	+= imageBoxStyle.margin.left;
					frame.origin.y	+= imageBoxStyle.margin.top;
				}
				else {
					frame.size		= imageSize;
					frame.origin.x	+= imageBoxStyle.margin.left;
					frame.origin.y	+= imageBoxStyle.margin.top;
				}
				
				context.frame			= frame;
				context.contentFrame	= context.frame;
				context.shape			= nil;
				
				[imageStyle drawPart:context];
			}
		}
	}

	-(CGSize) sizeThatFits:(CGSize)size {
		UXStyleContext *context			= [[[UXStyleContext alloc] init] autorelease];
		context.delegate				= self;
		context.font					= [self fontForCurrentState];
		UXStyle *style					= [self styleForCurrentState];
		if (style) {
			return [style addToSize:CGSizeZero context:context];
		}
		else {
			return size;
		}
	}


	#pragma mark UIControl

	-(void) setHighlighted:(BOOL)highlighted {
		[super setHighlighted:highlighted];
		[self setNeedsDisplay];
	}

	-(void) setSelected:(BOOL)selected {
		[super setSelected:selected];
		[self setNeedsDisplay];
	}

	-(void) setEnabled:(BOOL)enabled {
		[super setEnabled:enabled];
		[self setNeedsDisplay];
	}


	#pragma mark UIAccessibility

	-(BOOL) isAccessibilityElement {
		return YES;
	}

	-(NSString *) accessibilityLabel {
		return [self titleForCurrentState];
	}

	-(UIAccessibilityTraits) accessibilityTraits {
		return [super accessibilityTraits] | UIAccessibilityTraitButton;
	}


	#pragma mark UXStyleDelegate

	-(NSString *) textForLayerWithStyle:(UXStyle *)style {
		return [self titleForCurrentState];
	}

	-(UIImage *) imageForLayerWithStyle:(UXStyle *)style {
		return [self imageForCurrentState];
	}


	#pragma mark API

	-(UIFont *) font {
		if (!_font) {
			_font = [UXSTYLESHEETPROPERTY(buttonFont) retain];
		}
		return _font;
	}

	-(void) setFont:(UIFont *)font {
		if (font != _font) {
			[_font release];
			_font = [font retain];
			[self setNeedsDisplay];
		}
	}

	-(NSString *) titleForState:(UIControlState)state {
		return [self contentForState:state].title;
	}

	-(void) setTitle:(NSString *)title forState:(UIControlState)state {
		UXButtonContent *content	= [self contentForState:state];
		content.title				= title;
		[self setNeedsDisplay];
	}

	-(NSString *) imageForState:(UIControlState)state {
		return [self contentForState:state].imageURL;
	}

	-(void) setImage:(NSString *)imageURL forState:(UIControlState)state {
		UXButtonContent *content	= [self contentForState:state];
		content.imageURL			= imageURL;
		[self setNeedsDisplay];
	}

	-(UXStyle *) styleForState:(UIControlState)state {
		return [self contentForState:state].style;
	}

	-(void) setStyle:(UXStyle *)style forState:(UIControlState)state {
		UXButtonContent *content	= [self contentForState:state];
		content.style				= style;
		[self setNeedsDisplay];
	}

	-(void) setStylesWithSelector:(NSString *)selector {
		UXStyleSheet *ss			= [UXStyleSheet globalStyleSheet];
		UXStyle *normalStyle		= [ss styleWithSelector:selector forState:UIControlStateNormal];
		[self setStyle:normalStyle forState:UIControlStateNormal];
		
		UXStyle *highlightedStyle	= [ss styleWithSelector:selector forState:UIControlStateHighlighted];
		[self setStyle:highlightedStyle forState:UIControlStateHighlighted];
		
		UXStyle *selectedStyle		= [ss styleWithSelector:selector forState:UIControlStateSelected];
		[self setStyle:selectedStyle forState:UIControlStateSelected];
		
		UXStyle *disabledStyle		= [ss styleWithSelector:selector forState:UIControlStateDisabled];
		[self setStyle:disabledStyle forState:UIControlStateDisabled];
	}

	-(void) suspendLoadingImages:(BOOL)suspended {
		UXButtonContent *content = [self contentForCurrentState];
		if (suspended) {
			[content stopLoading];
		}
		else if (!content.image) {
			[content reload];
		}
	}

	-(CGRect) rectForImage {
		UXStyle *style = [self styleForCurrentState];
		if (style) {
			UXStyleContext *context		= [[[UXStyleContext alloc] init] autorelease];
			context.delegate			= self;
			UXPartStyle *imagePartStyle = [style styleForPart:@"image"];
			if (imagePartStyle) {
				UXImageStyle *imageStyle	= [imagePartStyle.style firstStyleOfClass:[UXImageStyle class ]];
				UXBoxStyle *imageBoxStyle	= [imagePartStyle.style firstStyleOfClass:[UXBoxStyle class ]];
				CGSize imageSize			= [imagePartStyle.style addToSize:CGSizeZero context:context];
				CGRect frame				= context.contentFrame;
				
				if (_isVertical) {
					frame			= self.bounds;
					frame.origin.x	+= imageBoxStyle.margin.left;
					frame.origin.y	+= imageBoxStyle.margin.top;
				}
				else {
					frame.size		= imageSize;
					frame.origin.x	+= imageBoxStyle.margin.left;
					frame.origin.y	+= imageBoxStyle.margin.top;
				}
				
				UIImage *image = [self imageForCurrentState];
				return [image convertRect:frame withContentMode:imageStyle.contentMode];
			}
		}
		return CGRectZero;
	}

@end
