
#import <UXKit/UXTableItem.h>
#import <UXKit/UXStyledNode.h>
#import <UXKit/UXStyledText.h>

@implementation UXTableItem

	@synthesize userInfo = _userInfo;

	#pragma mark NSObject

	-(id) init {
		if (self = [super init]) {
			_userInfo = nil;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_userInfo);
		[super dealloc];
	}


	#pragma mark NSCoding

	-(id) initWithCoder:(NSCoder *)decoder {
		return [self init];
	}

	-(void) encodeWithCoder:(NSCoder *)encoder {
	
	}

@end

#pragma mark

@implementation UXTableLinkedItem

	@synthesize URL				= _URL;
	@synthesize accessoryURL	= _accessoryURL;
	@synthesize query			= _query;


	#pragma mark NSObject

	-(id) init {
		if (self = [super init]) {
			_URL = nil;
			_accessoryURL = nil;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_URL);
		UX_SAFE_RELEASE(_query);
		UX_SAFE_RELEASE(_accessoryURL);
		[super dealloc];
	}


	#pragma mark NSCoding

	-(id) initWithCoder:(NSCoder *)decoder {
		if (self = [super initWithCoder:decoder]) {
			self.URL = [decoder decodeObjectForKey:@"URL"];
		}
		return self;
	}

	-(void) encodeWithCoder:(NSCoder *)encoder {
		[super encodeWithCoder:encoder];
		if (self.URL) {
			[encoder encodeObject:self.URL forKey:@"URL"];
		}
		if (self.accessoryURL) {
			[encoder encodeObject:self.accessoryURL forKey:@"URL"];
		}
	}

@end

#pragma mark

@implementation UXTableTextItem

	@synthesize text = _text;


	#pragma mark class Constructors

	+(id) itemWithText:(NSString *)aTextString {
		UXTableTextItem *item = [[[self alloc] init] autorelease];
		item.text = aTextString;
		return item;
	}

	+(id) itemWithText:(NSString *)aTextString URL:(NSString *)aURLString {
		UXTableTextItem *item = [[[self alloc] init] autorelease];
		item.text = aTextString;
		item.URL = aURLString;
		return item;
	}

	+(id) itemWithText:(NSString *)aTextString URL:(NSString *)aURL query:(NSDictionary *)aQuery {
		UXTableTextItem *item = [[[self alloc] init] autorelease];
		item.text	= aTextString;
		item.URL	= aURL;
		item.query	= aQuery;
		return item;
	}

	+(id) itemWithText:(NSString *)aTextString URL:(NSString *)aURL accessoryURL:(NSString *)anAccessoryURL {
		UXTableTextItem *item = [[[self alloc] init] autorelease];
		item.text			= aTextString;
		item.URL			= aURL;
		item.accessoryURL	= anAccessoryURL;
		return item;
	}


	#pragma mark NSObject

	-(id) init {
		if (self = [super init]) {
			_text = nil;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_text);
		[super dealloc];
	}


	#pragma mark NSCoding

	-(id) initWithCoder:(NSCoder *)decoder {
		if (self = [super initWithCoder:decoder]) {
			self.text = [decoder decodeObjectForKey:@"text"];
		}
		return self;
	}

	-(void) encodeWithCoder:(NSCoder *)encoder {
		[super encodeWithCoder:encoder];
		if (self.text) {
			[encoder encodeObject:self.text forKey:@"text"];
		}
	}

@end

#pragma mark

@implementation UXTableCaptionItem

	@synthesize caption = _caption;


	#pragma mark class Constructors

	+(id) itemWithText:(NSString *)aTextString caption:(NSString *)caption {
		UXTableCaptionItem *item = [[[self alloc] init] autorelease];
		item.text = aTextString;
		item.caption = caption;
		return item;
	}

	+(id) itemWithText:(NSString *)aTextString caption:(NSString *)caption URL:(NSString *)URL {
		UXTableCaptionItem *item = [[[self alloc] init] autorelease];
		item.text = aTextString;
		item.caption = caption;
		item.URL = URL;
		return item;
	}

	+(id) itemWithText:(NSString *)aTextString caption:(NSString *)caption URL:(NSString *)URL accessoryURL:(NSString *)accessoryURL {
		UXTableCaptionItem *item = [[[self alloc] init] autorelease];
		item.text			= aTextString;
		item.caption		= caption;
		item.URL			= URL;
		item.accessoryURL	= accessoryURL;
		return item;
	}


	#pragma mark NSObject

	-(id) init {
		if (self = [super init]) {
			_caption = nil;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_caption);
		[super dealloc];
	}


	#pragma mark NSCoding

	-(id) initWithCoder:(NSCoder *)decoder {
		if (self = [super initWithCoder:decoder]) {
			self.caption = [decoder decodeObjectForKey:@"caption"];
		}
		return self;
	}

	-(void) encodeWithCoder:(NSCoder *)encoder {
		[super encodeWithCoder:encoder];
		if (self.caption) {
			[encoder encodeObject:self.caption forKey:@"caption"];
		}
	}

@end

#pragma mark

@implementation UXTableRightCaptionItem
@end

#pragma mark

@implementation UXTableSubtextItem
@end

#pragma mark

@implementation UXTableSubtitleItem

	@synthesize subtitle		= _subtitle;
	@synthesize imageURL		= _imageURL;
	@synthesize defaultImage	= _defaultImage;


	#pragma mark class Constructors

	+(id) itemWithText:(NSString *)aTextString subtitle:(NSString *)aSubtitle {
		UXTableSubtitleItem *item = [[[self alloc] init] autorelease];
		item.text		= aTextString;
		item.subtitle	= aSubtitle;
		return item;
	}

	+(id) itemWithText:(NSString *)text subtitle:(NSString *)subtitle URL:(NSString *)URL {
		UXTableSubtitleItem *item = [[[self alloc] init] autorelease];
		item.text		= text;
		item.subtitle	= subtitle;
		item.URL		= URL;
		return item;
	}

	+(id) itemWithText:(NSString *)text subtitle:(NSString *)subtitle URL:(NSString *)URL accessoryURL:(NSString *)accessoryURL {
		UXTableSubtitleItem *item = [[[self alloc] init] autorelease];
		item.text			= text;
		item.subtitle		= subtitle;
		item.URL			= URL;
		item.accessoryURL	= accessoryURL;
		return item;
	}

	+(id) itemWithText:(NSString *)text subtitle:(NSString *)subtitle imageURL:(NSString *)imageURL URL:(NSString *)URL {
		UXTableSubtitleItem *item = [[[self alloc] init] autorelease];
		item.text			= text;
		item.subtitle		= subtitle;
		item.imageURL		= imageURL;
		item.URL			= URL;
		return item;
	}

	+(id) itemWithText:(NSString *)text subtitle:(NSString *)subtitle imageURL:(NSString *)imageURL defaultImage:(UIImage *)defaultImage URL:(NSString *)URL accessoryURL:(NSString *)accessoryURL {
		UXTableSubtitleItem *item = [[[self alloc] init] autorelease];
		item.text			= text;
		item.subtitle		= subtitle;
		item.imageURL		= imageURL;
		item.defaultImage	= defaultImage;
		item.URL			= URL;
		item.accessoryURL	= accessoryURL;
		return item;
	}

	
	#pragma mark Initializer

	-(id) init {
		if (self = [super init]) {
			_subtitle		= nil;
			_imageURL		= nil;
			_defaultImage	= nil;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_subtitle);
		UX_SAFE_RELEASE(_imageURL);
		UX_SAFE_RELEASE(_defaultImage);
		[super dealloc];
	}

	
	#pragma mark NSCoding

	-(id) initWithCoder:(NSCoder *)decoder {
		if (self = [super initWithCoder:decoder]) {
			self.subtitle = [decoder decodeObjectForKey:@"subtitle"];
			self.imageURL = [decoder decodeObjectForKey:@"imageURL"];
		}
		return self;
	}

	-(void) encodeWithCoder:(NSCoder *)encoder {
		[super encodeWithCoder:encoder];
		if (self.subtitle) {
			[encoder encodeObject:self.subtitle forKey:@"subtitle"];
		}
		if (self.imageURL) {
			[encoder encodeObject:self.imageURL forKey:@"imageURL"];
		}
	}

@end

#pragma mark

@implementation UXTableMessageItem

	@synthesize title		= _title;
	@synthesize caption		= _caption;
	@synthesize timestamp	= _timestamp;
	@synthesize imageURL	= _imageURL;


	#pragma mark Constructors

	+(id) itemWithTitle:(NSString *)title caption:(NSString *)caption text:(NSString *)text timestamp:(NSDate *)timestamp URL:(NSString *)URL {
		UXTableMessageItem *item = [[[self alloc] init] autorelease];
		item.title		= title;
		item.caption	= caption;
		item.text		= text;
		item.timestamp	= timestamp;
		item.URL		= URL;
		return item;
	}

	+(id) itemWithTitle:(NSString *)title caption:(NSString *)caption text:(NSString *)text timestamp:(NSDate *)timestamp imageURL:(NSString *)imageURL URL:(NSString *)URL {
		UXTableMessageItem *item = [[[self alloc] init] autorelease];
		item.title		= title;
		item.caption	= caption;
		item.text		= text;
		item.timestamp	= timestamp;
		item.imageURL	= imageURL;
		item.URL		= URL;
		return item;
	}

	
	#pragma mark NSObject

	-(id) init {
		if (self = [super init]) {
			_title		= nil;
			_caption	= nil;
			_timestamp	= nil;
			_imageURL	= nil;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_title);
		UX_SAFE_RELEASE(_caption);
		UX_SAFE_RELEASE(_timestamp);
		UX_SAFE_RELEASE(_imageURL);
		[super dealloc];
	}

	
	#pragma mark NSCoding

	-(id) initWithCoder:(NSCoder *)decoder {
		if (self = [super initWithCoder:decoder]) {
			self.title		= [decoder decodeObjectForKey:@"title"];
			self.caption	= [decoder decodeObjectForKey:@"caption"];
			self.timestamp	= [decoder decodeObjectForKey:@"timestamp"];
			self.imageURL	= [decoder decodeObjectForKey:@"imageURL"];
		}
		return self;
	}

	-(void) encodeWithCoder:(NSCoder *)encoder {
		[super encodeWithCoder:encoder];
		if (self.title) {
			[encoder encodeObject:self.title forKey:@"title"];
		}
		if (self.caption) {
			[encoder encodeObject:self.caption forKey:@"caption"];
		}
		if (self.timestamp) {
			[encoder encodeObject:self.timestamp forKey:@"timestamp"];
		}
		if (self.imageURL) {
			[encoder encodeObject:self.imageURL forKey:@"imageURL"];
		}
	}

@end

#pragma mark

@implementation UXTableLongTextItem
@end

#pragma mark

@implementation UXTableGrayTextItem
@end

#pragma mark

@implementation UXTableSummaryItem
@end

#pragma mark

@implementation UXTableLink
@end

#pragma mark

@implementation UXTableButton
@end

#pragma mark

@implementation UXTableMoreButton

	@synthesize isLoading = _isLoading;

	-(id) init {
		if (self = [super init]) {
			_isLoading = NO;
		}
		return self;
	}

	-(void) dealloc {
		[super dealloc];
	}

@end

#pragma mark

@implementation UXTableImageItem

	@synthesize imageURL		= _imageURL;
	@synthesize defaultImage	= _defaultImage;
	@synthesize imageStyle		= _imageStyle;


	#pragma mark Constructors

	+(id) itemWithText:(NSString *)text imageURL:(NSString *)imageURL {
		UXTableImageItem *item = [[[self alloc] init] autorelease];
		item.text		= text;
		item.imageURL	= imageURL;
		return item;
	}

	+(id) itemWithText:(NSString *)text imageURL:(NSString *)imageURL URL:(NSString *)URL {
		UXTableImageItem *item = [[[self alloc] init] autorelease];
		item.text		= text;
		item.imageURL	= imageURL;
		item.URL		= URL;
		return item;
	}

	+(id) itemWithText:(NSString *)text imageURL:(NSString *)imageURL defaultImage:(UIImage *)defaultImage URL:(NSString *)URL {
		UXTableImageItem *item = [[[self alloc] init] autorelease];
		item.text			= text;
		item.imageURL		= imageURL;
		item.defaultImage	= defaultImage;
		item.URL			= URL;
		return item;
	}

	+(id) itemWithText:(NSString *)text imageURL:(NSString *)imageURL defaultImage:(UIImage *)defaultImage imageStyle:(UXStyle *)imageStyle URL:(NSString *)URL {
		UXTableImageItem *item = [[[self alloc] init] autorelease];
		item.text			= text;
		item.imageURL		= imageURL;
		item.defaultImage	= defaultImage;
		item.imageStyle		= imageStyle;
		item.URL			= URL;
		return item;
	}


	#pragma mark NSObject

	-(id) init {
		if (self = [super init]) {
			_defaultImage	= nil;
			_imageURL		= nil;
			_imageStyle		= nil;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_imageURL);
		UX_SAFE_RELEASE(_defaultImage);
		UX_SAFE_RELEASE(_imageStyle);
		[super dealloc];
	}

	
	#pragma mark NSCoding

	-(id) initWithCoder:(NSCoder *)decoder {
		if (self = [super initWithCoder:decoder]) {
			self.imageURL = [decoder decodeObjectForKey:@"imageURL"];
		}
		return self;
	}

	-(void) encodeWithCoder:(NSCoder *)encoder {
		[super encodeWithCoder:encoder];
		if (self.imageURL) {
			[encoder encodeObject:self.imageURL forKey:@"imageURL"];
		}
	}

@end

#pragma mark

@implementation UXTableRightImageItem
@end

#pragma mark

@implementation UXTableActivityItem

	@synthesize text = _text;


	#pragma mark Constructor
	
	+(id) itemWithText:(NSString *)text {
		UXTableActivityItem *item = [[[self alloc] init] autorelease];
		item.text = text;
		return item;
	}


	#pragma mark NSObject

	-(id) init {
		if (self = [super init]) {
			_text = nil;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_text);
		[super dealloc];
	}

@end

#pragma mark

@implementation UXTableStyledTextItem

	@synthesize text	= _text;
	@synthesize margin	= _margin;
	@synthesize padding = _padding;


	#pragma mark Constructors

	+(id) itemWithText:(UXStyledText *)text {
		UXTableStyledTextItem *item = [[[self alloc] init] autorelease];
		item.text = text;
		return item;
	}

	+(id) itemWithText:(UXStyledText *)text URL:(NSString *)URL {
		UXTableStyledTextItem *item = [[[self alloc] init] autorelease];
		item.text	= text;
		item.URL	= URL;
		return item;
	}

	+(id) itemWithText:(UXStyledText *)text URL:(NSString *)URL accessoryURL:(NSString *)accessoryURL {
		UXTableStyledTextItem *item = [[[self alloc] init] autorelease];
		item.text			= text;
		item.URL			= URL;
		item.accessoryURL	= accessoryURL;
		return item;
	}

	
	#pragma mark NSObject

	-(id) init {
		if (self = [super init]) {
			_text		= nil;
			_margin		= UIEdgeInsetsZero;
			_padding	= UIEdgeInsetsMake(6, 6, 6, 6);
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_text);
		[super dealloc];
	}


	#pragma mark NSCoding

	-(id) initWithCoder:(NSCoder *)decoder {
		if (self = [super initWithCoder:decoder]) {
			self.text = [decoder decodeObjectForKey:@"text"];
		}
		return self;
	}

	-(void) encodeWithCoder:(NSCoder *)encoder {
		[super encodeWithCoder:encoder];
		if (self.text) {
			[encoder encodeObject:self.text forKey:@"text"];
		}
	}

@end

#pragma mark

@implementation UXTableControlItem

	@synthesize caption = _caption;
	@synthesize control = _control;
	

	#pragma mark Constructor

	+(id) itemWithCaption:(NSString *)caption control:(UIControl *)control {
		UXTableControlItem *item = [[[self alloc] init] autorelease];
		item.caption = caption;
		item.control = control;
		return item;
	}


	#pragma mark NSObject

	-(id) init {
		if (self = [super init]) {
			_caption = nil;
			_control = nil;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_caption);
		UX_SAFE_RELEASE(_control);
		[super dealloc];
	}


	#pragma mark NSCoding

	-(id) initWithCoder:(NSCoder *)decoder {
		if (self = [super initWithCoder:decoder]) {
			self.caption = [decoder decodeObjectForKey:@"caption"];
			self.control = [decoder decodeObjectForKey:@"control"];
		}
		return self;
	}

	-(void) encodeWithCoder:(NSCoder *)encoder {
		[super encodeWithCoder:encoder];
		if (self.caption) {
			[encoder encodeObject:self.caption forKey:@"caption"];
		}
		if (self.control) {
			[encoder encodeObject:self.control forKey:@"control"];
		}
	}

@end

#pragma mark

@implementation UXTableViewItem

	@synthesize caption = _caption;
	@synthesize view	= _view;


	#pragma mark Constructor

	+(id) itemWithCaption:(NSString *)aCaption view:(UIView *)aView {
		UXTableViewItem *item = [[[self alloc] init] autorelease];
		item.caption	= aCaption;
		item.view		= aView;
		return item;
	}

	
	#pragma mark NSObject

	-(id) init {
		if (self = [super init]) {
			_caption	= nil;
			_view		= nil;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_caption);
		UX_SAFE_RELEASE(_view);
		[super dealloc];
	}


	#pragma mark NSCoding

	-(id) initWithCoder:(NSCoder *)decoder {
		if (self = [super initWithCoder:decoder]) {
			self.caption	= [decoder decodeObjectForKey:@"caption"];
			self.view		= [decoder decodeObjectForKey:@"view"];
		}
		return self;
	}

	-(void) encodeWithCoder:(NSCoder *)encoder {
		[super encodeWithCoder:encoder];
		if (self.caption) {
			[encoder encodeObject:self.caption forKey:@"caption"];
		}
		if (self.view) {
			[encoder encodeObject:self.view forKey:@"control"];
		}
	}

@end
