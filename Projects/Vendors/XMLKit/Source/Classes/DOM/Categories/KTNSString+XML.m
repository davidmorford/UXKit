
#import <XMLKit/KTNSString+XML.h>

@implementation NSString (KTNSStringXML)

	-(const xmlChar *) xmlChar {
		return (const xmlChar *)[self UTF8String];
	}

	-(NSString *) trimWhitespace {
		NSMutableString *mStr	= [self mutableCopy];
		CFStringTrimWhitespace((CFMutableStringRef)mStr);
		NSString *result		= [mStr copy];
		[mStr release];
		return [result autorelease];
	}

@end
