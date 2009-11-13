
#import <UXKit/UXLauncherItem.h>

@implementation UXLauncherItem

	@synthesize launcher	= _launcher;
	@synthesize title		= _title;
	@synthesize image		= _image;
	@synthesize URL			= _URL;
	@synthesize style		= _style;
	@synthesize badgeNumber = _badgeNumber;
	@synthesize canDelete	= _canDelete;

	#pragma mark Initializers

	-(id) initWithTitle:(NSString *)aTitle image:(NSString *)anImageName URL:(NSString *)aURLString {
		return [self initWithTitle:aTitle image:anImageName URL:aURLString canDelete:FALSE];
	}

	-(id) initWithTitle:(NSString *)aTitle image:(NSString *)anImage URL:(NSString *)aURL canDelete:(BOOL)flag {
		if (self = [super init]) {
			_launcher		= nil;
			_title			= nil;
			_image			= nil;
			_URL			= nil;
			_style			= nil;
			_badgeNumber	= 0;
			_canDelete		= flag;
			self.title		= aTitle;
			self.image		= anImage;
			self.URL		= aURL;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_title);
		UX_SAFE_RELEASE(_image);
		UX_SAFE_RELEASE(_URL);
		UX_SAFE_RELEASE(_style);
		[super dealloc];
	}


	#pragma mark <NSCoding>

	-(id) initWithCoder:(NSCoder *)decoder {
		if (self = [super init]) {
			self.title		= [decoder decodeObjectForKey:@"title"];
			self.image		= [decoder decodeObjectForKey:@"image"];
			self.URL		= [decoder decodeObjectForKey:@"URL"];
			self.style		= [decoder decodeObjectForKey:@"style"];
			self.canDelete	= [decoder decodeBoolForKey:@"canDelete"];
		}
		return self;
	}

	-(void) encodeWithCoder:(NSCoder *)encoder {
		[encoder encodeObject:_title	forKey:@"title"];
		[encoder encodeObject:_image	forKey:@"image"];
		[encoder encodeObject:_URL		forKey:@"URL"];
		[encoder encodeObject:_style	forKey:@"style"];
		[encoder encodeBool:_canDelete	forKey:@"canDelete"];
	}


	#pragma mark API

	-(void) setBadgeNumber:(NSInteger)aCount {
		_badgeNumber = aCount;
		[_launcher performSelector:@selector(updateItemBadge:) withObject:self];
	}

@end
