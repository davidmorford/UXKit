
#import "SearchResult.h"

@implementation SearchResult

	@synthesize title, bigImageURL, thumbnailURL, bigImageSize;

	-(void) dealloc {
		[title release];
		[bigImageURL release];
		[thumbnailURL release];
		[super dealloc];
	}

@end
