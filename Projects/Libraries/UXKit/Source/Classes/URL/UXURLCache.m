
#import <UXKit/UXURLCache.h>
#import <QuartzCore/QuartzCore.h>
#import <CommonCrypto/CommonDigest.h>

#define UX_LARGE_IMAGE_SIZE (600 * 400)

static NSString*			kDefaultCacheName	= @"UXKit";
static UXURLCache*			gSharedCache		= nil;
static NSMutableDictionary* gNamedCaches		= nil;

#pragma mark -

@implementation UXURLCache

	@synthesize disableDiskCache	= _disableDiskCache;
	@synthesize disableImageCache	= _disableImageCache;
	@synthesize cachePath			= _cachePath;
	@synthesize maxPixelCount		= _maxPixelCount;
	@synthesize invalidationAge		= _invalidationAge;
	@synthesize fileReadOptions;

	#pragma mark Shared Constructor

	+(UXURLCache *) cacheWithName:(NSString *)name {
		if (!gNamedCaches) {
			gNamedCaches = [[NSMutableDictionary alloc] init];
		}
		UXURLCache *cache = [gNamedCaches objectForKey:name];
		if (!cache) {
			cache = [[[UXURLCache alloc] initWithName:name] autorelease];
			[gNamedCaches setObject:cache forKey:name];
		}
		return cache;
	}

	+(UXURLCache *) sharedCache {
		if (!gSharedCache) {
			gSharedCache = [[UXURLCache alloc] init];
		}
		return gSharedCache;
	}

	+(void) setSharedCache:(UXURLCache *)cache {
		if (gSharedCache != cache) {
			[gSharedCache release];
			gSharedCache = [cache retain];
		}
	}

	+(NSString *) cachePathWithName:(NSString *)name {
		NSArray *paths			= NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
		NSString *cachesPath	= [paths objectAtIndex:0];
		NSString *cachePath		= [cachesPath stringByAppendingPathComponent:name];
		NSFileManager *fm		= [NSFileManager defaultManager];
		if (![fm fileExistsAtPath:cachesPath]) {
			[fm createDirectoryAtPath:cachesPath attributes:nil];
		}
		if (![fm fileExistsAtPath:cachePath]) {
			[fm createDirectoryAtPath:cachePath attributes:nil];
		}
		return cachePath;
	}


	#pragma mark SPI

	-(void) expireImagesFromMemory {
		while (_imageSortedList.count) {
			NSString *key	= [_imageSortedList objectAtIndex:0];
			UIImage *image	= [_imageCache objectForKey:key];
			// UXLOG(@"EXPIRING %@", key);
			_totalPixelCount -= image.size.width * image.size.height;
			[_imageCache removeObjectForKey:key];
			[_imageSortedList removeObjectAtIndex:0];
			
			if (_totalPixelCount <= _maxPixelCount) {
				break;
			}
		}
	}

	-(void) storeImage:(UIImage *)image forURL:(NSString *)URL force:(BOOL)force {
		if (image && (force || !_disableImageCache)) {
			NSInteger pixelCount = image.size.width * image.size.height;
			if (force || (pixelCount < UX_LARGE_IMAGE_SIZE)) {
				_totalPixelCount += pixelCount;
				if ((_totalPixelCount > _maxPixelCount) && _maxPixelCount) {
					[self expireImagesFromMemory];
				}
				
				if (!_imageCache) {
					_imageCache = [[NSMutableDictionary alloc] init];
				}
				if (!_imageSortedList) {
					_imageSortedList = [[NSMutableArray alloc] init];
				}
				[_imageSortedList addObject:URL];
				[_imageCache setObject:image forKey:URL];
			}
		}
	}

	-(UIImage *) loadImageFromBundle:(NSString *)aURL {
		NSString *path	= UXPathForBundleResource([aURL substringFromIndex:9]);
		//NSData *data	= [NSData dataWithContentsOfFile:path];
		// Bundles shouldn't change during NSData object existence, so we could safely use mapped version here.
		NSData *data	= [NSData dataWithContentsOfMappedFile:path];
		return [UIImage imageWithData:data];
	}

	-(UIImage *) loadImageFromDocuments:(NSString *)aURL {
		NSString *path	= UXPathForDocumentsResource([aURL substringFromIndex:12]);
		//NSData *data	= [NSData dataWithContentsOfFile:path];
		NSData *data	= [NSData dataWithContentsOfFile:path options:fileReadOptions error:nil];
		return [UIImage imageWithData:data];
	}

	-(UIImage *) loadImageFromFile:(NSString *)URL {
		NSData *data = [NSData dataWithContentsOfFile:[URL substringFromIndex:7]];
		return [UIImage imageWithData:data];
	}

	-(UIImage *) loadImageFromTemp:(NSString *)aURL {
		NSString *path = UXPathForTempResource([aURL substringFromIndex:7]);
		NSData *data = [NSData dataWithContentsOfFile:path];
		return [UIImage imageWithData:data];
	}

	-(NSString *) createTemporaryURL {
		static int temporaryURLIncrement = 0;
		return [NSString stringWithFormat:@"temp:%d", temporaryURLIncrement++];
	}

	-(NSString *) createUniqueTemporaryURL {
		NSFileManager *fm = [NSFileManager defaultManager];
		NSString *tempURL = nil;
		NSString *newPath = nil;
		do {
			tempURL = [self createTemporaryURL];
			newPath = [self cachePathForURL:tempURL];
		} while ([fm fileExistsAtPath:newPath]);
		return tempURL;
	}

	
	#pragma mark NSObject

	-(id) initWithName:(NSString *)aName {
		if (self == [super init]) {
			_name				= [aName copy];
			_cachePath			= [[UXURLCache cachePathWithName:aName] retain];
			_imageCache			= nil;
			_imageSortedList	= nil;
			_totalLoading		= 0;
			_disableDiskCache	= NO;
			_disableImageCache	= NO;
			_invalidationAge	= UX_DEFAULT_CACHE_INVALIDATION_AGE;
			_maxPixelCount		= 0;
			_totalPixelCount	= 0;
			fileReadOptions		= 0;
			
			// Disabling the built-in cache may save memory but it also makes UIWebView slow
			// NSURLCache* sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
			// [NSURLCache setSharedURLCache:sharedCache];
			// [sharedCache release];
			[[NSNotificationCenter defaultCenter] addObserver:self
													 selector:@selector(didReceiveMemoryWarning:)
														 name:UIApplicationDidReceiveMemoryWarningNotification
													   object:nil];
		}
		return self;
	}

	-(id) init {
		return [self initWithName:kDefaultCacheName];
	}

	-(void) dealloc {
		[[NSNotificationCenter defaultCenter] removeObserver:self
														name:UIApplicationDidReceiveMemoryWarningNotification
													  object:nil];
		UX_SAFE_RELEASE(_name);
		UX_SAFE_RELEASE(_imageCache);
		UX_SAFE_RELEASE(_imageSortedList);
		UX_SAFE_RELEASE(_cachePath);
		[super dealloc];
	}

	
	#pragma mark NSNotifications
	
	/*!
	Empty the memory cache when memory is low
	*/
	-(void) didReceiveMemoryWarning:(void *)object {
		[self removeAll:NO];
	}

	
	#pragma mark API

	-(NSString *) keyForURL:(NSString *)aURL {
		const char *str = [aURL UTF8String];
		unsigned char result[CC_MD5_DIGEST_LENGTH];
		CC_MD5(str, strlen(str), result);
		
		return [NSString stringWithFormat:
				@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
				result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
				result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
				];
	}

	-(NSString *) cachePathForURL:(NSString *)aURL {
		NSString *key = [self keyForURL:aURL];
		return [self cachePathForKey:key];
	}

	-(NSString *) cachePathForKey:(NSString *)aKey {
		return [_cachePath stringByAppendingPathComponent:aKey];
	}

	-(BOOL) hasDataForURL:(NSString *)URL {
		NSString *filePath	= [self cachePathForURL:URL];
		NSFileManager *fm	= [NSFileManager defaultManager];
		return [fm fileExistsAtPath:filePath];
	}

	-(NSData *) dataForURL:(NSString *)URL {
		return [self dataForURL:URL expires:0 timestamp:nil];
	}

	-(NSData *) dataForURL:(NSString *)URL expires:(NSTimeInterval)expirationAge timestamp:(NSDate **)timestamp {
		NSString *key = [self keyForURL:URL];
		return [self dataForKey:key expires:expirationAge timestamp:timestamp];
	}

	-(NSData *) dataForKey:(NSString *)key expires:(NSTimeInterval)expirationAge timestamp:(NSDate **)timestamp {
		NSString *filePath	= [self cachePathForKey:key];
		NSFileManager *fm	= [NSFileManager defaultManager];
		if ([fm fileExistsAtPath:filePath]) {
			NSDictionary *attrs = [fm attributesOfItemAtPath:filePath error:nil];
			NSDate *modified	= [attrs objectForKey:NSFileModificationDate];
			if (expirationAge && ([modified timeIntervalSinceNow] < -expirationAge) ) {
				return nil;
			}
			if (timestamp) {
				*timestamp = modified;
			}
			//return [NSData dataWithContentsOfFile:filePath];
			return [NSData dataWithContentsOfFile:filePath options:fileReadOptions error:nil];
		}
		return nil;
	}

	-(id) imageForURL:(NSString *)aURL {
		return [self imageForURL:aURL fromDisk:YES];
	}

	-(id) imageForURL:(NSString *)aURL fromDisk:(BOOL)fromDisk {
		UIImage *image = [_imageCache objectForKey:aURL];
		if (!image && fromDisk) {
			if (UXIsBundleURL(aURL)) {
				image = [self loadImageFromBundle:aURL];
				[self storeImage:image forURL:aURL];
			}
			else if (UXIsDocumentsURL(aURL))  {
				image = [self loadImageFromDocuments:aURL];
				[self storeImage:image forURL:aURL];
			}
			else if (UXIsFileURL(aURL)) {
				image = [self loadImageFromFile:aURL];
				[self storeImage:image forURL:aURL];
			}
			else if (UXIsTempURL(aURL)) {
				image = [self loadImageFromTemp:aURL];
				[self storeImage:image forURL:aURL];
			}
		}
		return image;
	}


	#pragma mark -

	-(void) storeData:(NSData *)data forURL:(NSString *)aURL {
		NSString *key = [self keyForURL:aURL];
		[self storeData:data forKey:key];
	}

	-(void) storeData:(NSData *)data forKey:(NSString *)aKey {
		if (!_disableDiskCache) {
			NSString *filePath	= [self cachePathForKey:aKey];
			NSFileManager *fm	= [NSFileManager defaultManager];
			[fm createFileAtPath:filePath contents:data attributes:nil];
		}
	}

	-(void) storeImage:(UIImage *)anImage forURL:(NSString *)aURL {
		[self storeImage:anImage forURL:aURL force:NO];
	}

	-(NSString *) storeTemporaryData:(NSData *)data {
		NSString *URL = [self createUniqueTemporaryURL];
		[self storeData:data forURL:URL];
		return URL;
	}

	-(NSString *) storeTemporaryFile:(NSURL *)aFileURL {
		if ([aFileURL isFileURL]) {
			NSString *filePath	= [aFileURL path];
			NSFileManager *fm	= [NSFileManager defaultManager];
			if ([fm fileExistsAtPath:filePath]) {
				NSString *tempURL = nil;
				NSString *newPath = nil;
				do {
					tempURL = [self createTemporaryURL];
					newPath = [self cachePathForURL:tempURL];
				} while ([fm fileExistsAtPath:newPath]);
				
				if ([fm moveItemAtPath:filePath toPath:newPath error:nil]) {
					return tempURL;
				}
			}
		}
		return nil;
	}

	-(NSString *) storeTemporaryImage:(UIImage *)anImage toDisk:(BOOL)toDisk {
		NSString *URL	= [self createUniqueTemporaryURL];
		[self storeImage:anImage forURL:URL force:YES];
		NSData *data	= UIImagePNGRepresentation(anImage);
		[self storeData:data forURL:URL];
		return URL;
	}


	#pragma mark -

	-(void) moveDataForURL:(NSString *)oldURL toURL:(NSString *)newURL {
		NSString *oldKey	= [self keyForURL:oldURL];
		NSString *newKey	= [self keyForURL:newURL];
		id image			= [self imageForURL:oldKey];
		if (image) {
			[_imageSortedList removeObject:oldKey];
			[_imageCache removeObjectForKey:oldKey];
			[_imageSortedList addObject:newKey];
			[_imageCache setObject:image forKey:newKey];
		}
		NSString *oldPath = [self cachePathForKey:oldKey];
		NSFileManager *fm = [NSFileManager defaultManager];
		if ([fm fileExistsAtPath:oldPath]) {
			NSString *newPath = [self cachePathForKey:newKey];
			[fm moveItemAtPath:oldPath toPath:newPath error:nil];
		}
	}

	-(void) moveDataFromPath:(NSString *)path toURL:(NSString *)newURL {
		NSString *newKey	= [self keyForURL:newURL];
		NSFileManager *fm	= [NSFileManager defaultManager];
		if ([fm fileExistsAtPath:path]) {
			NSString *newPath = [self cachePathForKey:newKey];
			[fm moveItemAtPath:path toPath:newPath error:nil];
		}
	}

	-(NSString *) moveDataFromPathToTemporaryURL:(NSString *)path {
		NSString *tempURL = [self createUniqueTemporaryURL];
		[self moveDataFromPath:path toURL:tempURL];
		return tempURL;
	}


	#pragma mark -

	-(void) removeURL:(NSString *)aURL fromDisk:(BOOL)fromDisk {
		NSString *key = [self keyForURL:aURL];
		[_imageSortedList removeObject:key];
		[_imageCache removeObjectForKey:key];
		if (fromDisk) {
			NSString *filePath	= [self cachePathForKey:key];
			NSFileManager *fm	= [NSFileManager defaultManager];
			if (filePath && [fm fileExistsAtPath:filePath]) {
				[fm removeItemAtPath:filePath error:nil];
			}
		}
	}

	-(void) removeKey:(NSString *)aKey {
		NSString *filePath	= [self cachePathForKey:aKey];
		NSFileManager *fm	= [NSFileManager defaultManager];
		if (filePath && [fm fileExistsAtPath:filePath]) {
			[fm removeItemAtPath:filePath error:nil];
		}
	}

	-(void) removeAll:(BOOL)fromDisk {
		[_imageCache removeAllObjects];
		[_imageSortedList removeAllObjects];
		_totalPixelCount = 0;
		if (fromDisk) {
			NSFileManager *fm = [NSFileManager defaultManager];
			[fm removeItemAtPath:_cachePath error:nil];
			[fm createDirectoryAtPath:_cachePath attributes:nil];
		}
	}


	#pragma mark -

	-(void) invalidateURL:(NSString *)aURLString {
		NSString *key = [self keyForURL:aURLString];
		return [self invalidateKey:key];
	}

	-(void) invalidateKey:(NSString *)aKey {
		NSString *filePath	= [self cachePathForKey:aKey];
		NSFileManager *fm	= [NSFileManager defaultManager];
		if (filePath && [fm fileExistsAtPath:filePath]) {
			NSDate *invalidDate = [NSDate dateWithTimeIntervalSinceNow:-_invalidationAge];
			NSDictionary *attrs = [NSDictionary dictionaryWithObject:invalidDate forKey:NSFileModificationDate];
			[fm changeFileAttributes:attrs atPath:filePath];
		}
	}

	-(void) invalidateAll {
		NSDate *invalidDate			= [NSDate dateWithTimeIntervalSinceNow:-_invalidationAge];
		NSDictionary *attrs			= [NSDictionary dictionaryWithObject:invalidDate forKey:NSFileModificationDate];
		NSFileManager *fm			= [NSFileManager defaultManager];
		NSDirectoryEnumerator *e	= [fm enumeratorAtPath:_cachePath];
		for (NSString *fileName; fileName = [e nextObject]; ) {
			NSString *filePath = [_cachePath stringByAppendingPathComponent:fileName];
			[fm changeFileAttributes:attrs atPath:filePath];
		}
	}


	#pragma mark -

	-(NSDate *) cacheModificationDateFromURL:(NSString *)url {
		NSString *urlKey = [self keyForURL:url];
		return [self cacheModificationDateFromKey:urlKey];
	}

	-(NSDate *) cacheModificationDateFromKey:(NSString *)key {
		NSString *filePath	= [self cachePathForKey:key];
		NSFileManager *fm	= [NSFileManager defaultManager];
		
		if (filePath && [fm fileExistsAtPath:filePath]) {
			
			NSError *error		= nil;
			NSDictionary *attrs = [fm attributesOfItemAtPath:filePath error:&error];
			if (!error) {
				return [attrs objectForKey:NSFileModificationDate];
			}
			else {
				UXLOG(@"failure to obtain modification date of key '%@' in cache", key);
			}
		}
		return [NSDate distantPast];
	}

	#pragma mark -

	-(void) logMemoryUsage {
		UXLOG(@"======= IMAGE CACHE: %d images, %d pixels ========", _imageCache.count, _totalPixelCount);
		NSEnumerator *e = [_imageCache keyEnumerator];
		for (NSString *key; key = [e nextObject];) {
			UIImage *image = [_imageCache objectForKey:key];
			UXLOG(@"  %f x %f %@", image.size.width, image.size.height, key);
		}
	}

@end
