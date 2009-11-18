
#import "TestModel.h"

@implementation TestModelItem

	@synthesize title;
	@synthesize bigImageURL; 
	@synthesize thumbnailURL;
	@synthesize bigImageSize;
	@synthesize listingID;
	@synthesize statusType;
	@synthesize startDateTime;
	@synthesize endDateTime;
	@synthesize bidCount;

	-(void) dealloc {
		[listingID release]; listingID = nil;
		[statusType release]; statusType = nil;
		[startDateTime release]; startDateTime = nil;
		[endDateTime release]; endDateTime = nil;
		[bidCount release]; bidCount = nil;
		[title release]; title = nil;
		[bigImageURL release]; bigImageURL = nil;
		[thumbnailURL release]; thumbnailURL = nil;
		[super dealloc];
	}

@end

