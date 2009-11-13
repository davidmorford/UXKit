
#import "MockPhotoSource.h"

@implementation MockPhotoSource

	@synthesize title = _title;

	#pragma mark Loading

	-(void) fakeLoadReady {
		_fakeLoadTimer	= nil;
		if (_type & MockPhotoSourceLoadError) {
			[_delegates perform:@selector(model:didFailLoadWithError:) 
					 withObject:self 
					 withObject:nil];
		}
		else {
			NSMutableArray *newPhotos = [NSMutableArray array];
			for (int i = 0; i < _photos.count; ++i) {
				id <UXPhoto> photo = [_photos objectAtIndex:i];
				if ((NSNull *)photo != [NSNull null]) {
					[newPhotos addObject:photo];
				}
			}
			
			[newPhotos addObjectsFromArray:_tempPhotos];
			UX_SAFE_RELEASE(_tempPhotos);
			
			[_photos release];
			_photos = [newPhotos retain];
			
			for (int i = 0; i < _photos.count; ++i) {
				id <UXPhoto> photo	= [_photos objectAtIndex:i];
				if ((NSNull *)photo != [NSNull null]) {
					photo.photoSource	= self;
					photo.index			= i;
				}
			}
			[_delegates perform:@selector(modelDidFinishLoad:) withObject:self];
		}
	}


	#pragma mark Initializer

	-(id) initWithType:(MockPhotoSourceType)type title:(NSString *)title photos:(NSArray *)photos photos2:(NSArray *)photos2 {
		if (self = [super init]) {
			_type			= type;
			_title			= [title copy];
			_photos			= photos2 ? [photos mutableCopy] : [[NSMutableArray alloc] init];
			_tempPhotos		= photos2 ? [photos2 retain] : [photos retain];
			_fakeLoadTimer	= nil;
			
			for (int i = 0; i < _photos.count; ++i) {
				id <UXPhoto> photo	= [_photos objectAtIndex:i];
				if ((NSNull *)photo != [NSNull null]) {
					photo.photoSource	= self;
					photo.index			= i;
				}
			}
			
			if (!(_type & MockPhotoSourceDelayed || photos2)) {
				[self performSelector:@selector(fakeLoadReady)];
			}
		}
		return self;
	}


	#pragma mark <NSObject>

	-(id) init {
		return [self initWithType:MockPhotoSourceNormal title:nil photos:nil photos2:nil];
	}

	-(void) dealloc {
		[_fakeLoadTimer invalidate];
		UX_SAFE_RELEASE(_photos);
		UX_SAFE_RELEASE(_tempPhotos);
		UX_SAFE_RELEASE(_title);
		[super dealloc];
	}

	
	#pragma mark <UXModel>

	-(BOOL) isLoading {
		return !!_fakeLoadTimer;
	}

	-(BOOL) isLoaded {
		return !!_photos;
	}

	-(void) load:(UXURLRequestCachePolicy)cachePolicy more:(BOOL)more {
		if (cachePolicy & UXURLRequestCachePolicyNetwork) {
			
			[_delegates perform:@selector(modelDidStartLoad:)  withObject:self];
			UX_SAFE_RELEASE(_photos);
			_fakeLoadTimer = [NSTimer scheduledTimerWithTimeInterval:2 
															  target:self 
															selector:@selector(fakeLoadReady) 
															userInfo:nil 
															 repeats:NO];
		}
	}

	-(void) cancel {
		[_fakeLoadTimer invalidate];
		_fakeLoadTimer = nil;
	}


	#pragma mark <UXPhotoSource>

	-(NSInteger) numberOfPhotos {
		if (_tempPhotos) {
			return _photos.count + (_type & MockPhotoSourceVariableCount ? 0 : _tempPhotos.count);
		}
		else {
			return _photos.count;
		}
	}

	-(NSInteger) maxPhotoIndex {
		return _photos.count - 1;
	}

	-(id <UXPhoto>) photoAtIndex:(NSInteger)index {
		if (index < _photos.count) {
			id photo = [_photos objectAtIndex:index];
			if (photo == [NSNull null]) {
				return nil;
			}
			else {
				return photo;
			}
		}
		else {
			return nil;
		}
	}

@end

#pragma mark -

@implementation MockPhoto

	@synthesize photoSource		= _photoSource;
	@synthesize size			= _size;
	@synthesize index			= _index;
	@synthesize caption			= _caption;


	#pragma mark Initializer

	-(id) initWithURL:(NSString *)aURL smallURL:(NSString *)aSmallURL size:(CGSize)aSize {
		return [self initWithURL:aURL smallURL:aSmallURL size:aSize caption:nil];
	}

	-(id) initWithURL:(NSString *)aURL smallURL:(NSString *)aSmallURL size:(CGSize)aSize caption:(NSString *)aCaption {
		if (self = [super init]) {
			_photoSource	= nil;
			_URL			= [aURL copy];
			_smallURL		= [aSmallURL copy];
			_thumbURL		= [aSmallURL copy];
			_size			= aSize;
			_caption		= [aCaption copy];
			_index			= NSIntegerMax;
		}
		return self;
	}


	#pragma mark <NSObject>

	-(void) dealloc {
		UX_SAFE_RELEASE(_URL);
		UX_SAFE_RELEASE(_smallURL);
		UX_SAFE_RELEASE(_thumbURL);
		UX_SAFE_RELEASE(_caption);
		[super dealloc];
	}


	#pragma mark <UXPhoto>

	-(NSString *) URLForVersion:(UXPhotoVersion)aVersion {
		if (aVersion == UXPhotoVersionLarge) {
			return _URL;
		}
		else if (aVersion == UXPhotoVersionMedium) {
			return _URL;
		}
		else if (aVersion == UXPhotoVersionSmall) {
			return _smallURL;
		}
		else if (aVersion == UXPhotoVersionThumbnail) {
			return _thumbURL;
		}
		else {
			return nil;
		}
	}

@end
