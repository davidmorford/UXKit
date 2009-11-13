
#import <UXKit/UXImageView.h>
#import <UXKit/UXURLCache.h>
#import <UXKit/UXURLResponse.h>
#import <UXKit/UXShape.h>
#import <QuartzCore/CALayer.h>

@interface UXImageLayer : CALayer {
	UXImageView *_override;
}

	@property (nonatomic, assign) UXImageView *override;

@end

#pragma mark -

@implementation UXImageLayer

	@synthesize override = _override;

	-(id) init {
		if (self = [super init]) {
			_override = NO;
		}
		return self;
	}

	-(void) display {
		if (_override) {
			self.contents = (id)_override.image.CGImage;
		}
		else {
			return [super display];
		}
	}

	-(void) dealloc {
		[super dealloc];
	}

@end

#pragma mark -

@implementation UXImageView

	@synthesize delegate = _delegate;
	@synthesize URL = _URL;
	@synthesize image = _image;
	@synthesize defaultImage = _defaultImage;
	@synthesize autoresizesToImage = _autoresizesToImage;

	#pragma mark SPI

	-(void) updateLayer {
		UXImageLayer *layer = (UXImageLayer *)self.layer;
		if (self.style) {
			layer.override = nil;
		}
		else {
			// This is dramatically faster than calling drawRect.  Since we don't have any styles
			// to draw in this case, we can take this shortcut.
			layer.override = self;
		}
		[layer setNeedsDisplay];
	}


	#pragma mark Initializer

	-(id) initWithFrame:(CGRect)frame {
		if (self = [super initWithFrame:frame]) {
			_delegate = nil;
			_request = nil;
			_URL = nil;
			_image = nil;
			_defaultImage = nil;
			_autoresizesToImage = NO;
		}
		return self;
	}

	-(void) dealloc {
		_delegate = nil;
		[_request cancel];
		UX_SAFE_RELEASE(_request);
		UX_SAFE_RELEASE(_URL);
		UX_SAFE_RELEASE(_image);
		UX_SAFE_RELEASE(_defaultImage);
		[super dealloc];
	}


	#pragma mark UIView

	+(Class) layerClass {
		return [UXImageLayer class];
	}

	-(void) drawRect:(CGRect)rect {
		if (self.style) {
			[super drawRect:rect];
		}
	}


	#pragma mark UXView

	-(void) drawContent:(CGRect)rect {
		if (_image) {
			[_image drawInRect:rect contentMode:self.contentMode];
		}
		else {
			[_defaultImage drawInRect:rect contentMode:self.contentMode];
		}
	}

	-(void) setStyle:(UXStyle *)style {
		if (style != _style) {
			[super setStyle:style];
			[self updateLayer];
		}
	}


	#pragma mark UXURLRequestDelegate

	-(void) requestDidStartLoad:(UXURLRequest *)request {
		[_request release];
		_request = [request retain];
		
		[self imageViewDidStartLoad];
		if ([_delegate respondsToSelector:@selector(imageViewDidStartLoad:)]) {
			[_delegate imageViewDidStartLoad:self];
		}
	}

	-(void) requestDidFinishLoad:(UXURLRequest *)request {
		UXURLImageResponse *response = request.response;
		self.image = response.image;
		
		UX_SAFE_RELEASE(_request);
	}

	-(void) request:(UXURLRequest *)request didFailLoadWithError:(NSError *)error {
		UX_SAFE_RELEASE(_request);
		
		[self imageViewDidFailLoadWithError:error];
		if ([_delegate respondsToSelector:@selector(imageView:didFailLoadWithError:)]) {
			[_delegate imageView:self didFailLoadWithError:error];
		}
	}

	-(void) requestDidCancelLoad:(UXURLRequest *)request {
		UX_SAFE_RELEASE(_request);
		
		[self imageViewDidFailLoadWithError:nil];
		if ([_delegate respondsToSelector:@selector(imageView:didFailLoadWithError:)]) {
			[_delegate imageView:self didFailLoadWithError:nil];
		}
	}


	#pragma mark UXStyleDelegate

	-(void) drawLayer:(UXStyleContext *)context withStyle:(UXStyle *)style {
		if ([style isKindOfClass:[UXContentStyle class]]) {
			CGContextRef ctx = UIGraphicsGetCurrentContext();
			CGContextSaveGState(ctx);
			
			CGRect rect = context.frame;
			[context.shape addToPath:rect];
			CGContextClip(ctx);
			
			[self drawContent:rect];
			
			CGContextRestoreGState(ctx);
		}
	}


	#pragma mark API

	-(void) setURL:(NSString *)URL {
		if (self.image && _URL && [URL isEqualToString:_URL]) {
			return;
		}
		
		[self stopLoading];
		[_URL release];
		_URL = [URL retain];
		
		if (!_URL || !_URL.length) {
			if (self.image != _defaultImage) {
				self.image = _defaultImage;
			}
		}
		else {
			[self reload];
		}
	}

	-(void) setImage:(UIImage *)image {
		if (image != _image) {
			[_image release];
			_image = [image retain];
			
			[self updateLayer];
			CGRect frame = self.frame;
			if (_autoresizesToImage) {
				self.frame = CGRectMake(frame.origin.x, frame.origin.y, image.size.width, image.size.height);
			}
			else {
				if (!frame.size.width && !frame.size.height) {
					self.frame = CGRectMake(frame.origin.x, frame.origin.y, image.size.width, image.size.height);
				}
				else if (frame.size.width && !frame.size.height) {
					self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, floor((image.size.height / image.size.width) * frame.size.width));
				}
				else if (frame.size.height && !frame.size.width) {
					self.frame = CGRectMake(frame.origin.x, frame.origin.y, floor((image.size.width / image.size.height) * frame.size.height), frame.size.height);
				}
			}
			
			if (!_defaultImage || image != _defaultImage) {
				[self imageViewDidLoadImage:image];
				if ([_delegate respondsToSelector:@selector(imageView:didLoadImage:)]) {
					[_delegate imageView:self didLoadImage:image];
				}
			}
		}
	}

	-(BOOL) isLoading {
		return !!_request;
	}

	-(BOOL) isLoaded {
		return self.image && self.image != _defaultImage;
	}


	#pragma mark -

	-(void) reload {
		if (!_request && _URL) {
			UIImage *image = [[UXURLCache sharedCache] imageForURL:_URL];
			if (image) {
				self.image = image;
			}
			else {
				UXURLRequest *request = [UXURLRequest requestWithURL:_URL delegate:self];
				request.response = [[[UXURLImageResponse alloc] init] autorelease];
				if (_URL && ![request send]) {
					// Put the default image in place while waiting for the request to load
					if (_defaultImage && self.image != _defaultImage) {
						self.image = _defaultImage;
					}
				}
			}
		}
	}

	-(void) stopLoading {
		[_request cancel];
	}


	#pragma mark <UXImageViewDelegate>

	-(void) imageViewDidStartLoad {

	}

	-(void) imageViewDidLoadImage:(UIImage *)image {

	}

	-(void) imageViewDidFailLoadWithError:(NSError *)error {

	}

@end
