
/*!
@project    UXCatalog
@header     MockPhotoSource.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXKit.h>

typedef NSUInteger MockPhotoSourceType;
enum {
	MockPhotoSourceNormal			= 0,
	MockPhotoSourceDelayed			= 1,
	MockPhotoSourceVariableCount	= 2,
	MockPhotoSourceLoadError		= 4,
};


/*!
@class MockPhotoSource
@superclass UXURLRequestModel <UXPhotoSource>
@abstract
@discussion
*/
@interface MockPhotoSource : UXURLRequestModel <UXPhotoSource> {
	MockPhotoSourceType _type;
	NSString *_title;
	NSMutableArray *_photos;
	NSArray *_tempPhotos;
	NSTimer *_fakeLoadTimer;
}

	-(id) initWithType:(MockPhotoSourceType)aType title:(NSString *)aTitle photos:(NSArray *)photos photos2:(NSArray *)photos2;

@end

#pragma mark -

/*!
@class MockPhoto
@superclass NSObject <UXPhoto>
@abstract
@discussion
*/
@interface MockPhoto : NSObject <UXPhoto> {
	id <UXPhotoSource> _photoSource;
	NSString *_thumbURL;
	NSString *_smallURL;
	NSString *_URL;
	CGSize _size;
	NSInteger _index;
	NSString *_caption;
}

	-(id) initWithURL:(NSString *)aURL smallURL:(NSString *)aSmallURL size:(CGSize)aSize;

	-(id) initWithURL:(NSString *)aURL smallURL:(NSString *)aSmallURL size:(CGSize)aSize caption:(NSString *)aCaption;

@end
