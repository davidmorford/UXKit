
#import <JSONKit/JKNSString+JSON.h>
#import <JSONKit/JKJSONParser.h>

@implementation NSString (JKJSON)

	-(id) JSONFragmentValue {
		JKJSONParser *jsonParser = [JKJSONParser new];
		id repr = [jsonParser fragmentWithString:self];
		if (!repr) {
			NSLog(@"-JSONFragmentValue failed. Error trace is: %@", [jsonParser errorTrace]);
		}
		[jsonParser release];
		return repr;
	}

	-(id) JSONValue {
		JKJSONParser *jsonParser = [JKJSONParser new];
		id repr = [jsonParser objectWithString:self];
		if (!repr) {
			NSLog(@"-JSONValue failed. Error trace is: %@", [jsonParser errorTrace]);
		}
		[jsonParser release];
		return repr;
	}

@end
