
#import "URLModelResponse.h"

@implementation URLModelResponse

	@synthesize objects;
	@synthesize totalObjectsAvailableOnServer;

	+(id) response {
		return [[[[self class ] alloc] init] autorelease];
	}

	-(id) init {
		if ((self = [super init])) {
			objects = [[NSMutableArray alloc] init];
		}
		return self;
	}

	#pragma mark UXURLResponse

	-(NSError *) request:(UXURLRequest *)request processResponse:(NSHTTPURLResponse *)response data:(id)data {
		NSAssert(NO, @"URLModelResponse is an abstract class. Sub-classes must implement request:processResponse:data:");
		return nil;
	}

	-(NSString *) format {
		NSAssert(NO, @"URLModelResponse is an abstract class. Sub-classes must implement format");
		return nil;
	}

	-(void) dealloc {
		[objects release];
		[super dealloc];
	}

@end
