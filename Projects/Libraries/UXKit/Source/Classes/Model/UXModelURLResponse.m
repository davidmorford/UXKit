
#import <UXKit/UXModelURLResponse.h>

NSString* const UXModelURLResponseJSONFormat	= @"json";
NSString* const UXModelURLResponseSOAPFormat	= @"soap";
NSString* const UXModelURLResponseRSSFormat	= @"rss";
NSString* const UXModelURLResponseATOMFormat	= @"atom";

@implementation UXModelURLResponse

	@synthesize objects;
	@synthesize remoteObjectCount;

	#pragma mark Constructor

	+(id) response {
		return [[[[self class] alloc] init] autorelease];
	}

	#pragma mark Initializer

	-(id) init {
		if ((self = [super init])) {
			objects = [[NSMutableArray alloc] init];
		}
		return self;
	}

	#pragma mark <UXURLResponse>

	-(NSError *) request:(UXURLRequest *)aRequest processResponse:(NSHTTPURLResponse *)aResponse data:(id)aByteArray {
		NSAssert(NO, @"UXURLModelResponse is an abstract class. Subclasses must implement request:processResponse:data:");
		return nil;
	}

	
	#pragma mark Response Format

	-(NSString *) responseFormatType {
		NSAssert(NO, @"UXURLModelResponse is an abstract class. Subclasses implement format.");
		return nil;
	}

	#pragma mark -

	-(void) dealloc {
		[objects release];
		[super dealloc];
	}

@end
