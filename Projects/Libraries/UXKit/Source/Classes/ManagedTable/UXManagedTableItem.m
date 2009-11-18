
#import <UXKit/UXManagedTableItem.h>

@implementation UXManagedTableItem

	@synthesize object;

	#pragma mark NSObject

	-(id) initWithManagedObject:(id)anObject {
		if (self = [super init]) {
			self.object = anObject;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(object);
		[super dealloc];
	}

@end

#pragma mark

@implementation UXManagedTableLinkedItem

	@synthesize URL;
	@synthesize accessoryURL;
	@synthesize query;


	#pragma mark NSObject

	-(id) init {
		if (self = [super init]) {
			URL = nil;
			accessoryURL = nil;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(URL);
		UX_SAFE_RELEASE(query);
		UX_SAFE_RELEASE(accessoryURL);
		[super dealloc];
	}

@end

#pragma mark

@implementation UXManagedTableTextItem

	@synthesize text;

	#pragma mark class Constructors

	+(id) itemWithText:(NSString *)aTextString {
		UXManagedTableTextItem *item = [[[self alloc] init] autorelease];
		item.text = aTextString;
		return item;
	}

	+(id) itemWithText:(NSString *)aTextString URL:(NSString *)aURLString {
		UXManagedTableTextItem *item = [[[self alloc] init] autorelease];
		item.text = aTextString;
		item.URL = aURLString;
		return item;
	}

	+(id) itemWithText:(NSString *)aTextString URL:(NSString *)aURL query:(NSDictionary *)aQuery {
		UXManagedTableTextItem *item = [[[self alloc] init] autorelease];
		item.text	= aTextString;
		item.URL	= aURL;
		item.query	= aQuery;
		return item;
	}

	+(id) itemWithText:(NSString *)aTextString URL:(NSString *)aURL accessoryURL:(NSString *)anAccessoryURL {
		UXManagedTableTextItem *item = [[[self alloc] init] autorelease];
		item.text			= aTextString;
		item.URL			= aURL;
		item.accessoryURL	= anAccessoryURL;
		return item;
	}


	#pragma mark NSObject

	-(id) init {
		if (self = [super init]) {
			text = nil;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(text);
		[super dealloc];
	}

@end
