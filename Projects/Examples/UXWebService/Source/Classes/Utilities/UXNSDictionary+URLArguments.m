
#import "UXNSDictionary+URLArguments.h"
#import "UXNSString+URLArguments.h"

@implementation NSDictionary (UXNSDictionaryURLArguments)

	-(NSString *) httpArgumentsString {
		NSMutableArray *arguments	= [NSMutableArray arrayWithCapacity:[self count]];
		NSEnumerator *keyEnumerator = [self keyEnumerator];
		NSString *key;
		while ((key = [keyEnumerator nextObject])) {
			[arguments addObject:[NSString stringWithFormat:@"%@=%@",
								  [key stringByEscapingForURLArgument], [[[self objectForKey:key] description] stringByEscapingForURLArgument]]];
		}
		return [arguments componentsJoinedByString:@"&"];
	}

@end
