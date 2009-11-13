
#import <UXKit/UXStyledNode.h>
#import <UXKit/UXURLCache.h>
#import <UXKit/UXNavigator.h>

@implementation UXStyledNode

	@synthesize nextSibling = _nextSibling; 
	@synthesize parentNode	= _parentNode;

	#pragma mark SPI

	-(UXStyledNode *) findLastSibling:(UXStyledNode *)sibling {
		while (sibling) {
			if (!sibling.nextSibling) {
				return sibling;
			}
			sibling = sibling.nextSibling;
		}
		return nil;
	}


	#pragma mark Initializer

	-(id) initWithNextSibling:(UXStyledNode *)nextSibling {
		if (self = [self init]) {
			self.nextSibling = nextSibling;
		}
		return self;
	}


	#pragma mark NSObject

	-(id) init {
		if (self = [super init]) {
			_parentNode		= nil;
			_nextSibling	= nil;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_nextSibling);
		[super dealloc];
	}


	#pragma mark API

	-(void) setNextSibling:(UXStyledNode *)node {
		if (node != _nextSibling) {
			[_nextSibling release];
			_nextSibling	= [node retain];
			node.parentNode = _parentNode;
		}
	}

	-(NSString *) outerText {
		if (_nextSibling) {
			return _nextSibling.outerText;
		}
		else {
			return @"";
		}
	}

	-(NSString *) outerHTML {
		return @"";
	}

	-(id) ancestorOrSelfWithClass:(Class)cls {
		if ([self isKindOfClass:cls]) {
			return self;
		}
		else {
			return [_parentNode ancestorOrSelfWithClass:cls];
		}
	}

	-(void) performDefaultAction {
	}

@end

#pragma mark -

@implementation UXStyledTextNode

	@synthesize text = _text;


	#pragma mark Initializers

	-(id) init {
		if (self = [super init]) {
			_text = nil;
		}
		return self;
	}

	-(id) initWithText:(NSString *)aText {
		if (self = [self init]) {
			self.text = aText;
		}
		return self;
	}

	-(id) initWithText:(NSString *)aText next:(UXStyledNode *)aNextSibling {
		if (self = [self initWithText:aText]) {
			self.nextSibling = aNextSibling;
		}
		return self;
	}


	#pragma mark NSObject

	-(NSString *) description {
		return _text;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_text);
		[super dealloc];
	}


	#pragma mark UXStyledNode

	-(NSString *) outerText {
		return _text;
	}

	-(NSString *) outerHTML {
		if (_nextSibling) {
			return [NSString stringWithFormat:@"%@%@", _text, _nextSibling.outerHTML];
		}
		else {
			return _text;
		}
	}

@end

#pragma mark -

@implementation UXStyledElement

	@synthesize firstChild	= _firstChild;
	@synthesize lastChild	= _lastChild; 
	@synthesize className	= _className;


	#pragma mark NSObject
	
	-(id) initWithText:(NSString *)text {
		if (self = [self init]) {
			[self addChild:[[[UXStyledTextNode alloc] initWithText:text] autorelease]];
		}
		return self;
	}

	-(id) initWithText:(NSString *)text next:(UXStyledNode *)nextSibling {
		if (self = [super initWithNextSibling:nextSibling]) {
			[self addChild:[[[UXStyledTextNode alloc] initWithText:text] autorelease]];
		}
		return self;
	}


	#pragma mark Initializers

	-(id) init {
		if (self = [super init]) {
			_firstChild	= nil;
			_lastChild	= nil;
			_className	= nil;
		}
		return self;
	}

	-(NSString *) description {
		return [NSString stringWithFormat:@"%@", _firstChild];
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_firstChild);
		UX_SAFE_RELEASE(_className);
		[super dealloc];
	}


	#pragma mark UXStyledNode

	-(NSString *) outerText {
		if (_firstChild) {
			NSMutableArray *strings = [NSMutableArray array];
			for (UXStyledNode *node = _firstChild; node; node = node.nextSibling) {
				[strings addObject:node.outerText];
			}
			return [strings componentsJoinedByString:@""];
		}
		else {
			return [super outerText];
		}
	}

	-(NSString *) outerHTML {
		NSString *html = nil;
		if (_firstChild) {
			html = [NSString stringWithFormat:@"<div>%@</div>", _firstChild.outerHTML];
		}
		else {
			html = @"<div/>";
		}
		if (_nextSibling) {
			return [NSString stringWithFormat:@"%@%@", html, _nextSibling.outerHTML];
		}
		else {
			return html;
		}
	}


	#pragma mark API

	-(void) addChild:(UXStyledNode *)child {
		if (!_firstChild) {
			_firstChild = [child retain];
			_lastChild = [self findLastSibling:child];
		}
		else {
			_lastChild.nextSibling = child;
			_lastChild = [self findLastSibling:child];
		}
		child.parentNode = self;
	}

	-(void) addText:(NSString *)text {
		[self addChild:[[[UXStyledTextNode alloc] initWithText:text] autorelease]];
	}

	-(void) replaceChild:(UXStyledNode *)oldChild withChild:(UXStyledNode *)newChild {
		if (oldChild == _firstChild) {
			newChild.nextSibling	= oldChild.nextSibling;
			oldChild.nextSibling	= nil;
			newChild.parentNode		= self;
			if (oldChild == _lastChild) {
				_lastChild = newChild;
			}
			[_firstChild release];
			_firstChild = [newChild retain];
		}
		else {
			UXStyledNode *node = _firstChild;
			while (node) {
				if (node.nextSibling == oldChild) {
					[oldChild retain];
					if (newChild) {
						newChild.nextSibling	= oldChild.nextSibling;
						node.nextSibling		= newChild;
					}
					else {
						node.nextSibling		= oldChild.nextSibling;
					}
					oldChild.nextSibling		= nil;
					newChild.parentNode			= self;
					if (oldChild == _lastChild) {
						_lastChild = newChild ? newChild : node;
					}
					[oldChild release];
					break;
				}
				node = node.nextSibling;
			}
		}
	}

	-(UXStyledNode *) getElementByClassName:(NSString *)className {
		UXStyledNode *node = _firstChild;
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

#pragma mark -

@implementation UXStyledBlock

@end

#pragma mark -

@implementation UXStyledInline

@end

#pragma mark -

@implementation UXStyledInlineBlock

@end

#pragma mark -

@implementation UXStyledBoldNode

	-(NSString *) description {
		return [NSString stringWithFormat:@"*%@*", _firstChild];
	}

@end

#pragma mark -

@implementation UXStyledItalicNode

	-(NSString *) description {
		return [NSString stringWithFormat:@"/%@/", _firstChild];
	}

@end

#pragma mark -

@implementation UXStyledLinkNode

	@synthesize URL			= _URL;
	@synthesize highlighted = _highlighted;

	#pragma mark Initializers

	-(id) initWithURL:(NSString *)URL {
		if (self = [self init]) {
			self.URL = URL;
		}
		return self;
	}

	-(id) initWithURL:(NSString *)URL next:(UXStyledNode *)nextSibling {
		if (self = [super initWithNextSibling:nextSibling]) {
			self.URL = URL;
		}
		return self;
	}

	-(id) initWithText:(NSString *)text URL:(NSString *)URL next:(UXStyledNode *)nextSibling {
		if (self = [super initWithNextSibling:nextSibling]) {
			self.URL = URL;
			[self addChild:[[[UXStyledTextNode alloc] initWithText:text] autorelease]];
		}
		return self;
	}


	#pragma mark NSObject

	-(id) init {
		if (self = [super init]) {
			_URL			= nil;
			_highlighted	= NO;
		}
		return self;
	}

	-(NSString *) description {
		return [NSString stringWithFormat:@"<%@>", _firstChild];
	}


	#pragma mark UXStyledElement

	-(void) performDefaultAction {
		if (_URL) {
			UXOpenURL(_URL);
		}
	}


	#pragma mark -

	-(void) dealloc {
		UX_SAFE_RELEASE(_URL);
		[super dealloc];
	}

@end

#pragma mark -

@implementation UXStyledButtonNode

	@synthesize URL			= _URL;
	@synthesize highlighted = _highlighted;


	#pragma mark Initializers

	-(id) initWithURL:(NSString *)aURL {
		if (self = [self init]) {
			self.URL = aURL;
		}
		return self;
	}

	-(id) initWithURL:(NSString *)aURL next:(UXStyledNode *)nextSibling {
		if (self = [super initWithNextSibling:nextSibling]) {
			self.URL = aURL;
		}
		return self;
	}

	-(id) initWithText:(NSString *)text URL:(NSString *)aURL next:(UXStyledNode *)nextSibling {
		if (self = [super initWithNextSibling:nextSibling]) {
			self.URL = aURL;
			[self addChild:[[[UXStyledTextNode alloc] initWithText:text] autorelease]];
		}
		return self;
	}


	#pragma mark NSObject

	-(id) init {
		if (self = [super init]) {
			_URL			= nil;
			_highlighted	= NO;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_URL);
		[super dealloc];
	}

	-(NSString *) description {
		return [NSString stringWithFormat:@"<%@>", _firstChild];
	}


	#pragma mark UXStyledElement

	-(void) performDefaultAction {
		if (_URL) {
			UXOpenURL(_URL);
		}
	}

@end

#pragma mark -

@implementation UXStyledImageNode

	@synthesize URL				= _URL;
	@synthesize image			= _image;
	@synthesize defaultImage	= _defaultImage;
	@synthesize width			= _width;
	@synthesize height			= _height;

	#pragma mark Initializers

	-(id) initWithURL:(NSString *)aURL {
		if (self = [super init]) {
			self.URL = aURL;
		}
		return self;
	}


	#pragma mark NSObject

	-(id) init {
		if (self = [super init]) {
			_URL			= nil;
			_image			= nil;
			_defaultImage	= nil;
			_width			= 0;
			_height			= 0;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_URL);
		UX_SAFE_RELEASE(_image);
		UX_SAFE_RELEASE(_defaultImage);
		[super dealloc];
	}

	-(NSString *) description {
		return [NSString stringWithFormat:@"(%@)", _URL];
	}


	#pragma mark UXStyledNode

	-(NSString *) outerHTML {
		NSString *html = [NSString stringWithFormat:@"<img src=\"%@\"/>", _URL];
		if (_nextSibling) {
			return [NSString stringWithFormat:@"%@%@", html, _nextSibling.outerHTML];
		}
		else {
			return html;
		}
	}


	#pragma mark API

	-(void) setURL:(NSString *)URL {
		if (!_URL || ![URL isEqualToString:_URL]) {
			[_URL release];
			_URL = [URL retain];
			
			if (_URL) {
				self.image = [[UXURLCache sharedCache] imageForURL:_URL];
			}
			else {
				self.image = nil;
			}
		}
	}

@end

#pragma mark -

@implementation UXStyledLineBreakNode

@end
