
#import "UXNSString+URLArguments.h"

@implementation NSString (UXNSStringURLArguments)

	-(NSString *) stringByEscapingForURLArgument {
		NSString *escaped = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
																				(CFStringRef)self,
																				NULL,
																				(CFStringRef)@"!*'();:@&=+$,/?%#[]",
																				kCFStringEncodingUTF8);
		return [escaped autorelease];
	}

	-(NSString *) stringByUnescapingFromURLArgument {
		NSMutableString *resultString = [NSMutableString stringWithString:self];
		[resultString replaceOccurrencesOfString:@"+"
									  withString:@" "
										 options:NSLiteralSearch
										   range:NSMakeRange(0, [resultString length])];
		return [resultString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	}

@end
