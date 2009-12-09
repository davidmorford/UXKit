
#import <JSONKit/JKNSObject+JSON.h>
#import <JSONKit/JKJSONWriter.h>

@implementation NSObject (JKJSON)

	-(NSString *) JSONFragment {
		JKJSONWriter *jsonWriter = [JKJSONWriter new];
		NSString *json = [jsonWriter stringWithFragment:self];
		if (!json) {
			NSLog(@"-JSONFragment failed. Error trace is: %@", [jsonWriter errorTrace]);
		}
		[jsonWriter release];
		return json;
	}

	-(NSString *) JSONRepresentation {
		JKJSONWriter *jsonWriter = [JKJSONWriter new];
		NSString *json = [jsonWriter stringWithObject:self];
		if (!json) {
			NSLog(@"-JSONRepresentation failed. Error trace is: %@", [jsonWriter errorTrace]);
		}
		[jsonWriter release];
		return json;
	}

@end
