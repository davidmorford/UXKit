
#import <JSONKit/JKJSONWriter.h>

@interface JKJSONWriter ()

	-(BOOL) appendValue:(id)fragment into:(NSMutableString *)json;
	-(BOOL) appendArray:(NSArray *)fragment into:(NSMutableString *)json;
	-(BOOL) appendDictionary:(NSDictionary *)fragment into:(NSMutableString *)json;
	-(BOOL) appendString:(NSString *)fragment into:(NSMutableString *)json;

	-(NSString *) indent;

@end

#pragma mark -

@implementation JKJSONWriter

	@synthesize sortKeys;
	@synthesize humanReadable;

	static NSMutableCharacterSet *kEscapeChars;

	+(void) initialize {
		kEscapeChars = [[NSMutableCharacterSet characterSetWithRange:NSMakeRange(0, 32)] retain];
		[kEscapeChars addCharactersInString:@"\"\\"];
	}

	/*!
	@deprecated This exists in order to provide fragment support in older APIs in one more version.
	It should be removed in the next major version.
	*/
	-(NSString *) stringWithFragment:(id)value {
		[self clearErrorTrace];
		depth = 0;
		NSMutableString *json = [NSMutableString stringWithCapacity:128];
		if ([self appendValue:value into:json]) {
			return json;
		}
		return nil;
	}

	-(NSString *) stringWithObject:(id)value {
		if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]]) {
			return [self stringWithFragment:value];
		}
		
		[self clearErrorTrace];
		[self addErrorWithCode:EFRAGMENT description:@"Not valid type for JSON"];
		return nil;
	}

	-(NSString *) indent {
		return [@"\n" stringByPaddingToLength:1 + 2 * depth withString:@" " startingAtIndex:0];
	}

	-(BOOL) appendValue:(id)fragment into:(NSMutableString *)json {
		if ([fragment isKindOfClass:[NSDictionary class]]) {
			if (![self appendDictionary:fragment into:json]) {
				return NO;
			}
		}
		else if ([fragment isKindOfClass:[NSArray class]]) {
			if (![self appendArray:fragment into:json]) {
				return NO;
			}
		}
		else if ([fragment isKindOfClass:[NSString class]]) {
			if (![self appendString:fragment into:json]) {
				return NO;
			}
		}
		else if ([fragment isKindOfClass:[NSNumber class]]) {
			if ('c' == *[fragment objCType]) {
				[json appendString:[fragment boolValue] ? @"true":@"false"];
			}
			else {
				[json appendString:[fragment stringValue]];
			}
		}
		else if ([fragment isKindOfClass:[NSNull class]]) {
			[json appendString:@"null"];
		}
		else if ([fragment respondsToSelector:@selector(proxyForJson)]) {
			[self appendValue:[fragment proxyForJson] into:json];
		}
		else {
			[self addErrorWithCode:EUNSUPPORTED description:[NSString stringWithFormat:@"JSON serialisation not supported for %@", [fragment class]]];
			return NO;
		}
		return YES;
	}

	-(BOOL) appendArray:(NSArray *)fragment into:(NSMutableString *)json {
		if (maxDepth && ++depth > maxDepth) {
			[self addErrorWithCode:EDEPTH description:@"Nested too deep"];
			return NO;
		}
		[json appendString:@"["];
		
		BOOL addComma = NO;
		for (id value in fragment) {
			if (addComma) {
				[json appendString:@","];
			}
			else {
				addComma = YES;
			}
			
			if ([self humanReadable]) {
				[json appendString:[self indent]];
			}
			
			if (![self appendValue:value into:json]) {
				return NO;
			}
		}
		
		depth--;
		if ([self humanReadable] && [fragment count]) {
			[json appendString:[self indent]];
		}
		[json appendString:@"]"];
		return YES;
	}

	-(BOOL) appendDictionary:(NSDictionary *)fragment into:(NSMutableString *)json {
		if (maxDepth && ++depth > maxDepth) {
			[self addErrorWithCode:EDEPTH description:@"Nested too deep"];
			return NO;
		}
		[json appendString:@"{"];
		
		NSString *colon = [self humanReadable] ? @" : " : @":";
		BOOL addComma = NO;
		NSArray *keys = [fragment allKeys];
		if (self.sortKeys) {
			keys = [keys sortedArrayUsingSelector:@selector(compare:)];
		}
		
		for (id value in keys) {
			if (addComma) {
				[json appendString:@","];
			}
			else {
				addComma = YES;
			}
			
			if ([self humanReadable]) {
				[json appendString:[self indent]];
			}
			
			if (![value isKindOfClass:[NSString class]]) {
				[self addErrorWithCode:EUNSUPPORTED description:@"JSON object key must be string"];
				return NO;
			}
			
			if (![self appendString:value into:json]) {
				return NO;
			}
			
			[json appendString:colon];
			if (![self appendValue:[fragment objectForKey:value] into:json]) {
				[self addErrorWithCode:EUNSUPPORTED description:[NSString stringWithFormat:@"Unsupported value for key %@ in object", value]];
				return NO;
			}
		}
		
		depth--;
		if ([self humanReadable] && [fragment count]) {
			[json appendString:[self indent]];
		}
		[json appendString:@"}"];
		return YES;
	}

	-(BOOL) appendString:(NSString *)fragment into:(NSMutableString *)json {
		[json appendString:@"\""];
		
		NSRange esc = [fragment rangeOfCharacterFromSet:kEscapeChars];
		if (!esc.length) {
			// No special chars -- can just add the raw string:
			[json appendString:fragment];
		}
		else {
			NSUInteger length = [fragment length];
			for (NSUInteger i = 0; i < length; i++) {
				unichar uc = [fragment characterAtIndex:i];
				switch (uc) {
					case '"' :
						[json appendString:@"\\\""];
						break;
					case '\\':
						[json appendString:@"\\\\"];
						break;
					case '\t':
						[json appendString:@"\\t"];
						break;
					case '\n':
						[json appendString:@"\\n"];
						break;
					case '\r':
						[json appendString:@"\\r"];
						break;
					case '\b':
						[json appendString:@"\\b"];
						break;
					case '\f':
						[json appendString:@"\\f"];
						break;
					default:
						if (uc < 0x20) {
							[json appendFormat:@"\\u%04x", uc];
						}
						else {
							CFStringAppendCharacters((CFMutableStringRef)json, &uc, 1);
						}
						break;
				}
			}
		}
		[json appendString:@"\""];
		return YES;
	}

@end
