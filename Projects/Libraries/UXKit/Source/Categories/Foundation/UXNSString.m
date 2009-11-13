
#import <UXKit/UXNSString.h>

@interface UXMarkupStripper : NSObject {
	NSMutableArray *_strings;
}

	-(NSString *) parse:(NSString *)string;

@end

#pragma mark -

@implementation UXMarkupStripper

	#pragma mark <NSObject>

	-(id) init {
		if (self = [super init]) {
			_strings = nil;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_strings);
		[super dealloc];
	}


	#pragma mark (NSXMLParserDelegate)

	-(void) parser:(NSXMLParser *)aParser foundCharacters:(NSString *)aString {
		[_strings addObject:aString];
	}

	-(NSData *) parser:(NSXMLParser *)parser resolveExternalEntityName:(NSString *)anEntityName systemID:(NSString *)systemID {
		static NSDictionary *entityTable = nil;
		if (!entityTable) {
			/*
			Need more complete set of entities
			*/
			entityTable = [[NSDictionary alloc] initWithObjectsAndKeys:
							   [NSData dataWithBytes:" "  length:1], @"nbsp",
							   [NSData dataWithBytes:"&"  length:1], @"amp",
							   [NSData dataWithBytes:"\"" length:1], @"quot",
							   [NSData dataWithBytes:"<"  length:1], @"lt",
							   [NSData dataWithBytes:">"  length:1], @"gt",
							   nil];
		}
		return [entityTable objectForKey:anEntityName];
	}


	#pragma mark API

	-(NSString *) parse:(NSString *)text {
		_strings			= [[NSMutableArray alloc] init];
		NSString *document	= [NSString stringWithFormat:@"<x>%@</x>", text];
		NSData *data		= [document dataUsingEncoding:text.fastestEncoding];
		NSXMLParser *parser = [[[NSXMLParser alloc] initWithData:data] autorelease];
		parser.delegate		= self;
		[parser parse];
		return [_strings componentsJoinedByString:@""];
	}

@end

#pragma mark -

@implementation NSString (UXNSString)

	-(BOOL) isWhitespace {
		NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
		for (NSInteger i = 0; i < self.length; ++i) {
			unichar c = [self characterAtIndex:i];
			if (![whitespace characterIsMember:c]) {
				return NO;
			}
		}
		return YES;
	}

	-(BOOL) isEmptyOrWhitespace {
		return !self.length || ![self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length;
	}

	-(NSString *) stringByRemovingHTMLTags {
		UXMarkupStripper *stripper = [[[UXMarkupStripper alloc] init] autorelease];
		return [stripper parse:self];
	}

	-(NSDictionary *) queryDictionaryUsingEncoding:(NSStringEncoding)encoding {
		NSCharacterSet *delimiterSet	= [NSCharacterSet characterSetWithCharactersInString:@"&;"];
		NSMutableDictionary *pairs		= [NSMutableDictionary dictionary];
		NSScanner *scanner				= [[[NSScanner alloc] initWithString:self] autorelease];
		
		while (![scanner isAtEnd]) {
			
			NSString *pairString;
			[scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
			[scanner scanCharactersFromSet:delimiterSet intoString:NULL];
			NSArray *kvPair = [pairString componentsSeparatedByString:@"="];
			
			if (kvPair.count == 2) {
				NSString *key	= [[kvPair objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:encoding];
				NSString *value = [[kvPair objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:encoding];
				[pairs setObject:value forKey:key];
			}
		}
		return [NSDictionary dictionaryWithDictionary:pairs];
	}

	-(NSString *) stringByAddingQueryDictionary:(NSDictionary *)query {
		NSMutableArray *pairs = [NSMutableArray array];
		for (NSString *key in [query keyEnumerator]) {
			NSString *value = [query objectForKey:key];
			value			= [value stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
			value			= [value stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
			NSString *pair	= [NSString stringWithFormat:@"%@=%@", key, value];
			[pairs addObject:pair];
		}
		
		NSString *params = [pairs componentsJoinedByString:@"&"];
		if ([self rangeOfString:@"?"].location == NSNotFound) {
			return [self stringByAppendingFormat:@"?%@", params];
		}
		else {
			return [self stringByAppendingFormat:@"&%@", params];
		}
	}

	-(id) objectValue {
		return [[UXNavigator navigator].URLMap objectForURL:self];
	}

	-(void) openURL {
		[[UXNavigator navigator] openURL:self animated:YES];
	}

	-(void) openURLFromButton:(UIView *)aButtonView {
		NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:aButtonView, @"__target__", nil];
		[[UXNavigator navigator] openURL:self query:query animated:YES];
	}

@end

NSString *
UXHexStringFromBytes(void *bytes, NSUInteger len) {
	NSMutableString *output = [NSMutableString string];
	unsigned char *input	= (unsigned char *)bytes;
	for (NSUInteger i = 0; i < len; i++) {
		[output appendFormat:@"%02x", input[i]];
	}
	return output;
}
