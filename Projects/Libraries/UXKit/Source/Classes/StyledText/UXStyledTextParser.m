
#import <UXKit/UXStyledTextParser.h>
#import <UXKit/UXStyledNode.h>

@implementation UXStyledTextParser

	@synthesize rootNode = _rootNode, parseLineBreaks = _parseLineBreaks, parseURLs = _parseURLs;

	#pragma mark private

	-(void)addNode:(UXStyledNode *)node {
		if (!_rootNode) {
			_rootNode = [node retain];
			_lastNode = node;
		}
		else if (_topElement) {
			[_topElement addChild:node];
		}
		else {
			_lastNode.nextSibling = node;
			_lastNode = node;
		}
	}

	-(void)pushNode:(UXStyledElement *)element {
		if (!_stack) {
			_stack = [[NSMutableArray alloc] init];
		}
		
		[self addNode:element];
		[_stack addObject:element];
		_topElement = element;
	}

	-(void)popNode {
		UXStyledElement *element = [_stack lastObject];
		if (element) {
			[_stack removeLastObject];
		}
		
		_topElement = [_stack lastObject];
	}

	-(void)flushCharacters {
		if (_chars.length) {
			[self parseText:_chars];
		}
		
		UX_SAFE_RELEASE(_chars);
	}

	-(void)parseURLs:(NSString *)string {
		NSInteger index = 0;
		while (index < string.length) {
			NSRange searchRange = NSMakeRange(index, string.length - index);
			NSRange startRange = [string rangeOfString:@"http://" options:NSCaseInsensitiveSearch
												 range:searchRange];
			if (startRange.location == NSNotFound) {
				NSString *text = [string substringWithRange:searchRange];
				UXStyledTextNode *node = [[[UXStyledTextNode alloc] initWithText:text] autorelease];
				[self addNode:node];
				break;
			}
			else {
				NSRange beforeRange = NSMakeRange(searchRange.location,
												  startRange.location - searchRange.location);
				if (beforeRange.length) {
					NSString *text = [string substringWithRange:beforeRange];
					UXStyledTextNode *node = [[[UXStyledTextNode alloc] initWithText:text] autorelease];
					[self addNode:node];
				}
				
				NSRange searchRange = NSMakeRange(startRange.location, string.length - startRange.location);
				NSRange endRange = [string rangeOfString:@" " options:NSCaseInsensitiveSearch
												   range:searchRange];
				if (endRange.location == NSNotFound) {
					NSString *URL = [string substringWithRange:searchRange];
					UXStyledLinkNode *node = [[[UXStyledLinkNode alloc] initWithText:URL] autorelease];
					node.URL = URL;
					[self addNode:node];
					break;
				}
				else {
					NSRange URLRange = NSMakeRange(startRange.location,
												   endRange.location - startRange.location);
					NSString *URL = [string substringWithRange:URLRange];
					UXStyledLinkNode *node = [[[UXStyledLinkNode alloc] initWithText:URL] autorelease];
					node.URL = URL;
					[self addNode:node];
					index = endRange.location;
				}
			}
		}
	}

	#pragma mark NSObject

	-(id)init {
		if (self = [super init]) {
			_rootNode = nil;
			_topElement = nil;
			_lastNode = nil;
			_chars = nil;
			_stack = nil;
			_parseLineBreaks = NO;
			_parseURLs = NO;
		}
		return self;
	}

	-(void)dealloc {
		UX_SAFE_RELEASE(_rootNode);
		UX_SAFE_RELEASE(_chars);
		UX_SAFE_RELEASE(_stack);
		[super dealloc];
	}

	#pragma mark NSXMLParserDelegate

	-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
		[self flushCharacters];
		NSString *tag = [elementName lowercaseString];
		if ([tag isEqualToString:@"span"]) {
			UXStyledInline *node = [[[UXStyledInline alloc] init] autorelease];
			node.className =  [attributeDict objectForKey:@"class"];
			[self pushNode:node];
		}
		else if ([tag isEqualToString:@"br"]) {
			UXStyledLineBreakNode *node = [[[UXStyledLineBreakNode alloc] init] autorelease];
			node.className =  [attributeDict objectForKey:@"class"];
			[self pushNode:node];
		}
		else if ([tag isEqualToString:@"div"] || [tag isEqualToString:@"p"]) {
			UXStyledBlock *node = [[[UXStyledBlock alloc] init] autorelease];
			node.className =  [attributeDict objectForKey:@"class"];
			[self pushNode:node];
		}
		else if ([tag isEqualToString:@"b"]) {
			UXStyledBoldNode *node = [[[UXStyledBoldNode alloc] init] autorelease];
			[self pushNode:node];
		}
		else if ([tag isEqualToString:@"i"]) {
			UXStyledItalicNode *node = [[[UXStyledItalicNode alloc] init] autorelease];
			[self pushNode:node];
		}
		else if ([tag isEqualToString:@"a"]) {
			UXStyledLinkNode *node = [[[UXStyledLinkNode alloc] init] autorelease];
			node.URL =  [attributeDict objectForKey:@"href"];
			[self pushNode:node];
		}
		else if ([tag isEqualToString:@"button"]) {
			UXStyledButtonNode *node = [[[UXStyledButtonNode alloc] init] autorelease];
			node.URL =  [attributeDict objectForKey:@"href"];
			[self pushNode:node];
		}
		else if ([tag isEqualToString:@"img"]) {
			UXStyledImageNode *node = [[[UXStyledImageNode alloc] init] autorelease];
			node.className	= [attributeDict objectForKey:@"class"];
			node.URL		= [attributeDict objectForKey:@"src"];
			NSString *width = [attributeDict objectForKey:@"width"];
			if (width) {
				node.width = width.floatValue;
			}
			NSString *height = [attributeDict objectForKey:@"height"];
			if (height) {
				node.height = height.floatValue;
			}
			[self pushNode:node];
		}
	}

	-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
		if (!_chars) {
			_chars = [string mutableCopy];
		}
		else {
			[_chars appendString:string];
		}
	}

	-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
		[self flushCharacters];
		[self popNode];
	}

	-(NSData *) parser:(NSXMLParser *)parser resolveExternalEntityName:(NSString *)entityName systemID:(NSString *)systemID {
		static NSDictionary *entityTable = nil;
		if (!entityTable) {
			entityTable = [[NSDictionary alloc] initWithObjectsAndKeys:
						   [NSData dataWithBytes:" " length:1], @"nbsp",
						   [NSData dataWithBytes:"&" length:1], @"amp",
						   [NSData dataWithBytes:"\"" length:1], @"quot",
						   [NSData dataWithBytes:"<" length:1], @"lt",
						   [NSData dataWithBytes:">" length:1], @"gt",
						   nil];
		}
		return [entityTable objectForKey:entityName];
	}

	#pragma mark public

	-(void) parseXHTML:(NSString *)html {
		NSString *document	= [NSString stringWithFormat:@"<x>%@</x>", html];
		NSData *data		= [document dataUsingEncoding:html.fastestEncoding];
		NSXMLParser *parser = [[[NSXMLParser alloc] initWithData:data] autorelease];
		parser.delegate		= self;
		[parser parse];
	}

	-(void) parseText:(NSString *)string {
		if (_parseLineBreaks) {
			NSCharacterSet *newLines	= [NSCharacterSet newlineCharacterSet];
			NSInteger index				= 0;
			NSInteger length			= string.length;

			while (1) {
				NSRange searchRange		= NSMakeRange(index, length - index);
				NSRange range			= [string rangeOfCharacterFromSet:newLines options:0 range:searchRange];
				if (range.location != NSNotFound) {

					// Find all text before the line break and parse it
					NSRange textRange	= NSMakeRange(index, range.location - index);
					NSString *substr	= [string substringWithRange:textRange];
					[self parseURLs:substr];
					
					// Add a line break node after the text
					UXStyledLineBreakNode *br = [[[UXStyledLineBreakNode alloc] init] autorelease];
					[self addNode:br];
					
					index = index + substr.length + 1;
				}
				else {
					// Find all text until the end of hte string and parse it
					NSString *substr = [string substringFromIndex:index];
					[self parseURLs:substr];
					break;
				}
			}
		}
		else if (_parseURLs) {
			[self parseURLs:string];
		}
		else {
			UXStyledTextNode *node = [[[UXStyledTextNode alloc] initWithText:string] autorelease];
			[self addNode:node];
		}
	}

@end
