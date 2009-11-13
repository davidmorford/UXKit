
#import "SearchResultsPhotoSource.h"
#import "YahooSearchResultsModel.h"
#import "SearchResult.h"

@implementation SearchResultsPhotoSource

	@synthesize title = albumTitle;

	#pragma mark -

	-(id) initWithModel:(YahooSearchResultsModel *)theModel {
		if ((self = [super init])) {
			albumTitle = @"Photos";
			model = [theModel retain];
		}
		return self;
	}

	-(id <UXModel>) underlyingModel {
		return model;
	}

	#pragma mark Forwarding

	-(void) forwardInvocation:(NSInvocation *)invocation {
		if ([model respondsToSelector:[invocation selector]]) {
			[invocation invokeWithTarget:model];
		}
		else{
			[super forwardInvocation:invocation];
		}
	}

	-(BOOL) respondsToSelector:(SEL)selector {
		if ([super respondsToSelector:selector]) {
			return YES;
		}
		else{
			return [model respondsToSelector:selector];
		}
	}

	-(BOOL) conformsToProtocol:(Protocol *)protocol {
		if ([super conformsToProtocol:protocol]) {
			return YES;
		}
		else{
			return [model conformsToProtocol:protocol];
		}
	}

	-(NSMethodSignature *) methodSignatureForSelector:(SEL)selector {
		NSMethodSignature *signature = [super methodSignatureForSelector:selector];
		if (!signature) {
			signature = [model methodSignatureForSelector:selector];
		}
		return signature;
	}


	#pragma mark UXPhotoSource

	-(NSInteger) numberOfPhotos {
		return [model totalResultsAvailableOnServer];
	}

	-(NSInteger) maxPhotoIndex {
		return [[model results] count] - 1;
	}

	-(id <UXPhoto>) photoAtIndex:(NSInteger)index {
		if ((index < 0) || (index > [self maxPhotoIndex])) {
			return nil;
		}
		
		// Construct an object (PhotoItem) that is suitable for Three20's
		// photo browsing system from the domain object (SearchResult)
		// at the specified index in the UXModel.
		SearchResult *result	= [[model results] objectAtIndex:index];
		id <UXPhoto> photo		= [PhotoItem itemWithImageURL:result.bigImageURL thumbImageURL:result.thumbnailURL caption:result.title size:result.bigImageSize];
		photo.index				= index;
		photo.photoSource		= self;
		return photo;
	}


	#pragma mark -

	-(NSString *) description {
		return [NSString stringWithFormat:@"%@ delegates: %@", [super description], [self delegates]];
	}

	-(void) dealloc {
		[model release];
		[albumTitle release];
		[super dealloc];
	}

@end

#pragma mark -

@implementation PhotoItem

	@synthesize caption; 
	@synthesize photoSource; 
	@synthesize size; 
	@synthesize index;
	
	@synthesize imageURL;
	@synthesize thumbnailURL;

	#pragma mark -

	+(id) itemWithImageURL:(NSString *)theImageURL thumbImageURL:(NSString *)theThumbImageURL caption:(NSString *)theCaption size:(CGSize)theSize {
		PhotoItem *item		= [[[[self class ] alloc] init] autorelease];
		item.caption		= theCaption;
		item.imageURL		= theImageURL;
		item.thumbnailURL	= theThumbImageURL;
		item.size			= theSize;
		return item;
	}


	#pragma mark UXPhoto

	-(NSString *) URLForVersion:(UXPhotoVersion)version {
		return (version == UXPhotoVersionThumbnail && thumbnailURL) ? thumbnailURL : imageURL;
	}


	#pragma mark -

	-(void) dealloc {
		[caption release];
		[imageURL release];
		[thumbnailURL release];
		[super dealloc];
	}

@end
