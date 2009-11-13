
#import <UXKit/UXModel.h>
#import <UXKit/UXURLCache.h>
#import <UXKit/UXURLRequestQueue.h>

@implementation UXModel

	#pragma mark <NSObject>

	-(id) init {
		if (self = [super init]) {
			_delegates = nil;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_delegates);
		[super dealloc];
	}


	#pragma mark UXModel

	-(NSMutableArray *) delegates {
		if (!_delegates) {
			_delegates = UXCreateNonRetainingArray();
		}
		return _delegates;
	}

	-(BOOL) isLoaded {
		return YES;
	}

	-(BOOL) isLoading {
		return NO;
	}

	-(BOOL) isLoadingMore {
		return NO;
	}

	-(BOOL) isOutdated {
		return NO;
	}

	-(void) load:(UXURLRequestCachePolicy)cachePolicy more:(BOOL)more {
	}

	-(void) cancel {
	}

	-(void) invalidate:(BOOL)erase {
	}


	#pragma mark API

	-(void) didStartLoad {
		[_delegates perform:@selector(modelDidStartLoad:) withObject:self];
	}

	-(void) didFinishLoad {
		[_delegates perform:@selector(modelDidFinishLoad:) withObject:self];
	}

	-(void) didFailLoadWithError:(NSError *)error {
		[_delegates perform:@selector(model:didFailLoadWithError:) withObject:self withObject:error];
	}

	-(void) didCancelLoad {
		[_delegates perform:@selector(modelDidCancelLoad:) withObject:self];
	}

	-(void) beginUpdates {
		[_delegates perform:@selector(modelDidBeginUpdates:) withObject:self];
	}

	-(void) endUpdates {
		[_delegates perform:@selector(modelDidEndUpdates:) withObject:self];
	}

	-(void) didUpdateObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
		[_delegates perform:@selector(model:didUpdateObject:atIndexPath:) withObject:self withObject:object withObject:indexPath];
	}

	-(void) didInsertObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
		[_delegates perform:@selector(model:didInsertObject:atIndexPath:) withObject:self withObject:object withObject:indexPath];
	}

	-(void) didDeleteObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
		[_delegates perform:@selector(model:didDeleteObject:atIndexPath:) withObject:self withObject:object withObject:indexPath];
	}

	-(void) didChange {
		[_delegates perform:@selector(modelDidChange:) withObject:self];
	}

@end

#pragma mark -

@implementation UXURLRequestModel

	@synthesize loadedTime	= _loadedTime; 
	@synthesize cacheKey	= _cacheKey;
	@synthesize hasNoMore	= _hasNoMore;


	#pragma mark <NSObject>

	-(id) init {
		if (self = [super init]) {
			_loadingRequest = nil;
			_isLoadingMore = NO;
			_loadedTime = nil;
			_cacheKey = nil;
		}
		return self;
	}

	-(void) dealloc {
		[[UXURLRequestQueue mainQueue] cancelRequestsWithDelegate:self];
		[_loadingRequest cancel];
		UX_SAFE_RELEASE(_loadingRequest);
		UX_SAFE_RELEASE(_loadedTime);
		UX_SAFE_RELEASE(_cacheKey);
		[super dealloc];
	}


	#pragma mark <UXModel>

	-(BOOL) isLoaded {
		return !!_loadedTime;
	}

	-(BOOL) isLoading {
		return !!_loadingRequest;
	}

	-(BOOL) isLoadingMore {
		return _isLoadingMore;
	}

	-(BOOL) isOutdated {
		if (!_cacheKey && _loadedTime) {
			return YES;
		}
		else if (!_cacheKey) {
			return NO;
		}
		else {
			NSDate *loadedTime = self.loadedTime;
			if (loadedTime) {
				return -[loadedTime timeIntervalSinceNow] > [UXURLCache sharedCache].invalidationAge;
			}
			else {
				return NO;
			}
		}
	}

	-(void) cancel {
		[_loadingRequest cancel];
	}

	-(void) invalidate:(BOOL)erase {
		if (_cacheKey) {
			if (erase) {
				[[UXURLCache sharedCache] removeKey:_cacheKey];
			}
			else {
				[[UXURLCache sharedCache] invalidateKey:_cacheKey];
			}
			UX_SAFE_RELEASE(_cacheKey);
		}
	}


	#pragma mark <UXURLRequestDelegate>

	-(void) requestDidStartLoad:(UXURLRequest *)request {
		[_loadingRequest release];
		_loadingRequest = [request retain];
		[self didStartLoad];
	}

	-(void) requestDidFinishLoad:(UXURLRequest *)request {
		if (!self.isLoadingMore) {
			[_loadedTime release];
			_loadedTime = [request.timestamp retain];
			self.cacheKey = request.cacheKey;
		}
		
		UX_SAFE_RELEASE(_loadingRequest);
		[self didFinishLoad];
	}

	-(void) request:(UXURLRequest *)request didFailLoadWithError:(NSError *)error {
		UX_SAFE_RELEASE(_loadingRequest);
		[self didFailLoadWithError:error];
	}

	-(void) requestDidCancelLoad:(UXURLRequest *)request {
		UX_SAFE_RELEASE(_loadingRequest);
		[self didCancelLoad];
	}


	#pragma mark API

	-(void) reset {
		UX_SAFE_RELEASE(_cacheKey);
		UX_SAFE_RELEASE(_loadedTime);
	}

@end
