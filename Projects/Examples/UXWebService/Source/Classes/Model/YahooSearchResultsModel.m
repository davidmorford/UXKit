
#import "YahooSearchResultsModel.h"
#import "YahooJSONResponse.h"
#import "YahooXMLResponse.h"
#import "UXNSDictionary+URLArguments.h"

const static NSUInteger kYahooBatchSize = 16;   // The number of results to pull down with each request to the server.

@implementation YahooSearchResultsModel

	@synthesize searchTerms;

	-(id) initWithResponseFormat:(SearchResponseFormat)responseFormat {
		if ((self = [super init])) {
			switch ( responseFormat ) {
				case SearchResponseFormatJSON:
					responseProcessor = [[YahooJSONResponse alloc] init];
					break;
				case SearchResponseFormatXML:
					responseProcessor = [[YahooXMLResponse alloc] init];
					break;
				default:
					[NSException raise:@"SearchResponseFormat unknown!" format:nil];
			}
			// Yahoo's API offset is 1-based.
			recordOffset = 1;
		}
		return self;
	}

	-(id) init {
		return [self initWithResponseFormat:CurrentSearchResponseFormat];
	}

	-(void) load:(UXURLRequestCachePolicy)cachePolicy more:(BOOL)more {
		if (!searchTerms) {
			UXLOG(@"No search terms specified. Cannot load the model resource.");
			return;
		}
		
		if (more) {
			recordOffset += kYahooBatchSize;
		}
		else {
			// Clear out data from previous request.
			[responseProcessor.objects removeAllObjects];
			
		}
		NSString *offset	= [NSString stringWithFormat:@"%lu", (unsigned long)recordOffset];
		NSString *batchSize = [NSString stringWithFormat:@"%lu", (unsigned long)kYahooBatchSize];
		
		// Construct the request.
		NSString *host	= @"http://search.yahooapis.com";
		NSString *path	= @"/ImageSearchService/V1/imageSearch";
		NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
									searchTerms, @"query",
									@"YahooDemo", @"appid",
									[responseProcessor format], @"output",
									offset, @"start",
									batchSize, @"results",
									nil];
		
		NSString *url			= [host stringByAppendingFormat:@"%@?%@", path, [parameters httpArgumentsString]];
		UXURLRequest *request	= [UXURLRequest requestWithURL:url delegate:self];
		request.cachePolicy		= cachePolicy;
		request.response		= responseProcessor;
		request.httpMethod		= @"GET";
		
		// Dispatch the request.
		[request send];
	}

	-(void) reset {
		[super reset];
		[searchTerms release];
		searchTerms		= nil;
		recordOffset	= 1;
		[[responseProcessor objects] removeAllObjects];
	}

	-(void) setSearchTerms:(NSString *)theSearchTerms {
		if (![theSearchTerms isEqualToString:searchTerms]) {
			[searchTerms release];
			searchTerms		= [theSearchTerms retain];
			recordOffset	= 1;
		}
	}

	-(NSArray *) results {
		return [[[responseProcessor objects] copy] autorelease];
	}

	-(NSUInteger) totalResultsAvailableOnServer {
		return [responseProcessor totalObjectsAvailableOnServer];
	}

	-(void) dealloc {
		[searchTerms release];
		[responseProcessor release];
		[super dealloc];
	}

@end
