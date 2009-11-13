
/*!
@project	UXKit
@header     UXURLCache.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXGlobal.h>

@class UXURLRequest;

/*!
@class UXURLCache
@superclass NSObject
@abstract
@discussion
*/
@interface UXURLCache : NSObject {
	NSString *_name;
	NSString *_cachePath;
	NSMutableDictionary *_imageCache;
	NSMutableArray *_imageSortedList;
	NSUInteger _totalPixelCount;
	NSUInteger _maxPixelCount;
	NSUInteger fileReadOptions;
	NSInteger _totalLoading;
	NSTimeInterval _invalidationAge;
	BOOL _disableDiskCache;
	BOOL _disableImageCache;
}
	/*!
	@abstract Gets the path to the directory of the disk cache.
	*/
	@property (nonatomic, copy) NSString *cachePath;

	/*!
	@abstract Disables the disk cache.
	*/
	@property (nonatomic, assign) BOOL disableDiskCache;

	/*!
	@abstract Disables the in-memory cache for images.
	*/
	@property (nonatomic, assign) BOOL disableImageCache;

	/*!
	@abstract The maximum number of pixels to keep in memory for cached images.
	@discussion Setting this to zero will allow an unlimited number of images 
	to be cached.  The default is zero.
	*/
	@property (nonatomic, assign) NSUInteger maxPixelCount;

	/*!
	@abstract The amount of time to set back the modification timestamp on 
	files when invalidating them.
	*/
	@property (nonatomic, assign) NSTimeInterval invalidationAge;

	/*!
	@abstract Options for data files reading.
	@discussion See "Options for NSData Reading Methods" in documention. 
	Default is zero.
	*/
	@property (nonatomic, assign) NSUInteger fileReadOptions;


	#pragma mark Shared Cache

	/*!
	@abstract Gets a shared cache identified with a unique name.
	 */
	+(UXURLCache *) cacheWithName:(NSString *)aName;

	/*!
	@abstract Gets the shared cache singleton used across the application.
	*/
	+(UXURLCache *) sharedCache;

	/*!
	@abstract Sets the shared cache singleton used across the application.
	*/
	+(void) setSharedCache:(UXURLCache *)aCache;


	#pragma mark -
	
	-(id) initWithName:(NSString *)aName;


	#pragma mark -

	/*!
	@abstract Gets the key that would be used to cache a URL response.
	*/
	-(NSString *) keyForURL:(NSString *)aURLString;

	/*!
	@abstract Gets the path in the cache where a URL may be stored.
	*/
	-(NSString *) cachePathForURL:(NSString *)aURLString;

	/*!
	@abstract Gets the path in the cache where a key may be stored.
	*/
	-(NSString *) cachePathForKey:(NSString *)aKey;

	/*!
	@abstract Determines if there is a cache entry for a URL.
	*/
	-(BOOL) hasDataForURL:(NSString *)aURL;

	/*!
	@abstract Gets the data for a URL from the cache if it exists.
	@result nil if the URL is not cached.
	*/
	-(NSData *) dataForURL:(NSString *)aURL;

	/*!
	@abstract Gets the data for a URL from the cache if it exists and is 
	newer than a minimum timestamp.
	@result nil if hthe URL is not cached or if the cache entry is older 
	than the minimum.
	*/
	-(NSData *) dataForURL:(NSString *)aURL expires:(NSTimeInterval)expirationAge timestamp:(NSDate **)aTimestamp;
	-(NSData *) dataForKey:(NSString *)key  expires:(NSTimeInterval)expirationAge timestamp:(NSDate **)timestamp;

	/*!
	@abstract Gets an image from the in-memory image cache.
	@result nil if the URL is not cached.
	*/
	-(id) imageForURL:(NSString *)aURL;
	-(id) imageForURL:(NSString *)aURL fromDisk:(BOOL)fromDisk;

	/*!
	@abstract Stores a data on disk.
	*/
	-(void) storeData:(NSData *)data forURL:(NSString *)aURL;
	-(void) storeData:(NSData *)data forKey:(NSString *)aKey;

	/*!
	@abstract Stores an image in the memory cache.
	*/
	-(void) storeImage:(UIImage *)anImage forURL:(NSString *)aURL;

	/*!
	@abstract Convenient way to create a temporary URL for some data and cache it in memory.
	@result The temporary URL
	*/
	-(NSString *) storeTemporaryImage:(UIImage *)anImage toDisk:(BOOL)toDisk;

	/*!
	@abstract Convenient way to create a temporary URL for some data and cache in on disk.
	@result The temporary URL
	*/
	-(NSString *) storeTemporaryData:(NSData *)data;

	/*!
	@abstract Convenient way to create a temporary URL for a file and move it to the disk cache.
	@result The temporary URL
	*/
	-(NSString *) storeTemporaryFile:(NSURL *)fileURL;

	/*!
	@abstract Moves the data currently stored under one URL to another URL.
	@discussion This is handy when you are caching data at a temporary URL 
	while the permanent URL is being retrieved from a server.  Once you know 
	the permanent URL you can use this to move the data.
	*/
	-(void) moveDataForURL:(NSString *)oldURL toURL:(NSString *)newURL;

	-(void) moveDataFromPath:(NSString *)path toURL:(NSString *)newURL;
	
	-(NSString *) moveDataFromPathToTemporaryURL:(NSString *)path;


	/*!
	@abstract Removes the data for a URL from the memory cache and optionally 
	from the disk cache.
	*/
	-(void) removeURL:(NSString *)aURL fromDisk:(BOOL)fromDisk;

	/*!
	@abstract
	*/
	-(void) removeKey:(NSString *)aKey;

	/*!
	@abstract Erases the memory cache and optionally the disk cache.
	*/
	-(void) removeAll:(BOOL)fromDisk;

	/*!
	@abstract Invalidates the file in the disk cache so that its modified timestamp 
	is the current time minus the default cache expiration age.
	@discussion This ensures that the next time the URL is requested from the cache 
	it will be loaded from the network if the default cache expiration age is used.
	*/
	-(void) invalidateURL:(NSString *)aURL;
	-(void) invalidateKey:(NSString *)aKey;

	/*!
	@abstract Invalidates all files in the disk cache according to rules explained 
	in 'invalidateURL'.
	*/
	-(void) invalidateAll;
	
	#pragma mark -

	/*!
	 Retrieves the last modification date of cached element
	 */
	-(NSDate *) cacheModificationDateFromURL:(NSString *)aURL;
	-(NSDate *) cacheModificationDateFromKey:(NSString *)aKey;

	#pragma mark -

	-(void) logMemoryUsage;

@end
