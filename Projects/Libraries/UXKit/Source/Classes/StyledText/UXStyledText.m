
#import <UXKit/UXStyledText.h>
#import <UXKit/UXStyledNode.h>
#import <UXKit/UXStyledFrame.h>
#import <UXKit/UXStyledLayout.h>
#import <UXKit/UXStyledTextParser.h>
#import <UXKit/UXURLRequest.h>
#import <UXKit/UXURLResponse.h>
#import <UXKit/UXURLCache.h>

@implementation UXStyledText

	@synthesize delegate = _delegate,
				rootNode = _rootNode, 
				font = _font, 
				width = _width,
				height = _height, 
				invalidImages = _invalidImages;

	#pragma mark Constructors

	+(UXStyledText *) textFromXHTML:(NSString *)source {
		return [self textFromXHTML:source lineBreaks:NO URLs:YES];
	}

	+(UXStyledText *) textFromXHTML:(NSString *)source lineBreaks:(BOOL)lineBreaks URLs:(BOOL)URLs {
		UXStyledTextParser *parser	= [[[UXStyledTextParser alloc] init] autorelease];
		parser.parseLineBreaks		= lineBreaks;
		parser.parseURLs			= URLs;
		[parser parseXHTML:source];
		if (parser.rootNode) {
			return [[[UXStyledText alloc] initWithNode:parser.rootNode] autorelease];
		}
		else {
			return nil;
		}
	}

	+(UXStyledText *) textWithURLs:(NSString *)source {
		return [self textWithURLs:source lineBreaks:NO];
	}

	+(UXStyledText *) textWithURLs:(NSString *)source lineBreaks:(BOOL)lineBreaks {
		UXStyledTextParser *parser	= [[[UXStyledTextParser alloc] init] autorelease];
		parser.parseLineBreaks		= lineBreaks;
		parser.parseURLs			= YES;
		[parser parseText:source];
		if (parser.rootNode) {
			return [[[UXStyledText alloc] initWithNode:parser.rootNode] autorelease];
		}
		else {
			return nil;
		}
	}


	#pragma mark SPI

	-(void) stopLoadingImages {
		if (_imageRequests) {
			NSMutableArray *requests = [_imageRequests retain];
			UX_SAFE_RELEASE(_imageRequests);

			if (!_invalidImages) {
				_invalidImages = [[NSMutableArray alloc] init];
			}

			for (UXURLRequest *request in requests) {
				[_invalidImages addObject:request.userInfo];
				[request cancel];
			}
			[requests release];
		}
	}

	-(void) loadImages {
		[self stopLoadingImages];
		if (_delegate && _invalidImages) {
			BOOL loadedSome = NO;
			for (UXStyledImageNode *imageNode in _invalidImages) {
				if (imageNode.URL) {
					UIImage *image		= [[UXURLCache sharedCache] imageForURL:imageNode.URL];
					if (image) {
						imageNode.image = image;
						loadedSome		= YES;
					}
					else {
						UXURLRequest *request	= [UXURLRequest requestWithURL:imageNode.URL delegate:self];
						request.userInfo		= imageNode;
						request.response		= [[[UXURLImageResponse alloc] init] autorelease];
						[request send];
					}
				}
			}
			UX_SAFE_RELEASE(_invalidImages);
			if (loadedSome) {
				[_delegate styledTextNeedsDisplay:self];
			}
		}
	}

	-(UXStyledFrame *)getFrameForNode:(UXStyledNode *)node inFrame:(UXStyledFrame *)frame {
		while (frame) {
			if ([frame isKindOfClass:[UXStyledBoxFrame class]]) {
				UXStyledBoxFrame *boxFrame = (UXStyledBoxFrame *)frame;
				if (boxFrame.element == node) {
					return boxFrame;
				}
				UXStyledFrame *found = [self getFrameForNode:node inFrame:boxFrame.firstChildFrame];
				if (found) {
					return found;
				}
			}
			else if ([frame isKindOfClass:[UXStyledTextFrame class]]) {
				UXStyledTextFrame *textFrame = (UXStyledTextFrame *)frame;
				if (textFrame.node == node) {
					return textFrame;
				}
			}
			else if ([frame isKindOfClass:[UXStyledImageFrame class]]) {
				UXStyledImageFrame *imageFrame = (UXStyledImageFrame *)frame;
				if (imageFrame.imageNode == node) {
					return imageFrame;
				}
			}
			frame = frame.nextFrame;
		}
		return nil;
	}


	#pragma mark NSObject

	-(id) initWithNode:(UXStyledNode *)rootNode {
		if (self = [self init]) {
			_rootNode = [rootNode retain];
		}
		return self;
	}

	-(id) init {
		if (self = [super init]) {
			_rootNode		= nil;
			_rootFrame		= nil;
			_font			= nil;
			_width			= 0;
			_height			= 0;
			_invalidImages	= nil;
			_imageRequests	= nil;
		}
		return self;
	}

	-(void) dealloc {
		[self stopLoadingImages];
		UX_SAFE_RELEASE(_rootNode);
		UX_SAFE_RELEASE(_rootFrame);
		UX_SAFE_RELEASE(_font);
		UX_SAFE_RELEASE(_invalidImages);
		UX_SAFE_RELEASE(_imageRequests);
		[super dealloc];
	}

	-(NSString *) description {
		return [self.rootNode outerText];
	}


	#pragma mark UXURLRequestDelegate

	-(void) requestDidStartLoad:(UXURLRequest *)request {
		if (!_imageRequests) {
			_imageRequests = [[NSMutableArray alloc] init];
		}
		[_imageRequests addObject:request];
	}

	-(void) requestDidFinishLoad:(UXURLRequest *)request {
		UXURLImageResponse *response	= request.response;
		UXStyledImageNode *imageNode	= request.userInfo;
		imageNode.image					= response.image;
		[_imageRequests removeObject:request];
		[_delegate styledTextNeedsDisplay:self];
	}

	-(void) request:(UXURLRequest *)request didFailLoadWithError:(NSError *)error {
		[_imageRequests removeObject:request];
	}

	-(void) requestDidCancelLoad:(UXURLRequest *)request {
		[_imageRequests removeObject:request];
	}


	#pragma mark API

	-(void) setDelegate:(id <UXStyledTextDelegate>)delegate {
		if (_delegate != delegate) {
			_delegate = delegate;
			[self loadImages];
		}
	}

	-(UXStyledFrame *) rootFrame {
		[self layoutIfNeeded];
		return _rootFrame;
	}

	-(void) setFont:(UIFont *)font {
		if (font != _font) {
			[_font release];
			_font = [font retain];
			[self setNeedsLayout];
		}
	}

	-(void) setWidth:(CGFloat)width {
		if (width != _width) {
			_width = width;
			[self setNeedsLayout];
		}
	}

	-(CGFloat) height {
		[self layoutIfNeeded];
		return _height;
	}

	-(BOOL) needsLayout {
		return !_rootFrame;
	}

	-(void) layoutFrames {
		UXStyledLayout *layout = [[UXStyledLayout alloc] initWithRootNode:_rootNode];
		layout.width = _width;
		layout.font = _font;
		[layout layout:_rootNode];

		[_rootFrame release];
		_rootFrame = [layout.rootFrame retain];
		_height = ceil(layout.height);
		[_invalidImages release];
		_invalidImages = [layout.invalidImages retain];
		[layout release];

		[self loadImages];
	}

	-(void) layoutIfNeeded {
		if (!_rootFrame) {
			[self layoutFrames];
		}
	}

	-(void) setNeedsLayout {
		UX_SAFE_RELEASE(_rootFrame);
		_height = 0;
	}

	-(void) drawAtPoint:(CGPoint)point {
		[self drawAtPoint:point highlighted:NO];
	}

	-(void) drawAtPoint:(CGPoint)point highlighted:(BOOL)highlighted {
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		CGContextSaveGState(ctx);
		CGContextTranslateCTM(ctx, point.x, point.y);

		UXStyledFrame *frame = self.rootFrame;
		while (frame) {
			[frame drawInRect:frame.bounds];
			frame = frame.nextFrame;
		}

		CGContextRestoreGState(ctx);
	}

	-(UXStyledBoxFrame *) hitTest:(CGPoint)point {
		return [self.rootFrame hitTest:point];
	}

	-(UXStyledFrame *) getFrameForNode:(UXStyledNode *)node {
		return [self getFrameForNode:node inFrame:_rootFrame];
	}

	-(void) addChild:(UXStyledNode *)child {
		if (!_rootNode) {
			self.rootNode = child;
		}
		else {
			UXStyledNode *previousNode = _rootNode;
			UXStyledNode *node = _rootNode.nextSibling;
			while (node) {
				previousNode = node;
				node = node.nextSibling;
			}
			previousNode.nextSibling = child;
		}
	}

	-(void) addText:(NSString *)text {
		[self addChild:[[[UXStyledTextNode alloc] initWithText:text] autorelease]];
	}

	-(void) insertChild:(UXStyledNode *)child atIndex:(NSInteger)index {
		if (!_rootNode) {
			self.rootNode = child;
		}
		else if (index == 0) {
			child.nextSibling = _rootNode;
			self.rootNode = child;
		}
		else {
			NSInteger i = 0;
			UXStyledNode *previousNode = _rootNode;
			UXStyledNode *node = _rootNode.nextSibling;
			while (node && i != index) {
				++i;
				previousNode = node;
				node = node.nextSibling;
			}
			child.nextSibling = node;
			previousNode.nextSibling = child;
		}
	}

	-(UXStyledNode *)getElementByClassName:(NSString *)className {
		UXStyledNode *node = _rootNode;
		while (node) {
			if ([node isKindOfClass:[UXStyledElement class]]) {
				UXStyledElement *element = (UXStyledElement *)node;
				if ([element.className isEqualToString:className]) {
					return element;
				}

				UXStyledNode *found = [element getElementByClassName:className];
				if (found) {
					return found;
				}
			}
			node = node.nextSibling;
		}
		return nil;
	}

@end
