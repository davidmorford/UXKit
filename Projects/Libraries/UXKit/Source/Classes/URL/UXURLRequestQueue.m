
#import <UXKit/UXURLRequestQueue.h>
#import <UXKit/UXURLRequestLoader.h>
#import <UXKit/UXURLRequest.h>
#import <UXKit/UXURLResponse.h>
#import <UXKit/UXURLCache.h>

static const NSTimeInterval kFlushDelay					= 0.3;
static const NSTimeInterval	kTimeout					= 300.0;
static const NSInteger		kMaxConcurrentLoads			= 5;
static NSUInteger			kDefaultMaxContentLength	= 150000;
static NSString*			kSafariUserAgent			= @"Mozilla/5.0 (iPhone; U; CPU iPhone OS 3_0 like Mac OS X; en-us) AppleWebKit/528.18 (KHTML, like Gecko) Version/4.0 Mobile/7A341 Safari/528.16";

#pragma mark -

@interface NSURLRequest (UXURLRequestPrivate)
	+(BOOL) allowsAnyHTTPSCertificateForHost:(NSString *)aHostName;
	+(void) setAllowsAnyHTTPSCertificate:(BOOL)flag forHost:(NSString *)aHostName;
	
	+(id) allowsSpecificHTTPSCertificateForHost:(NSString *)aHostName;
	+(void) setAllowsSpecificHTTPCertificate:(id)aCertificate forHost:(NSString *)aHostName;
@end

#pragma mark -

static UXURLRequestQueue *gMainQueue = nil;

#pragma mark -

@implementation UXURLRequestQueue
	
	@synthesize delegate;
	@synthesize	maxConcurrentLoads;
	@synthesize maxContentLength		= _maxContentLength;
	@synthesize userAgent				= _userAgent;
	@synthesize suspended				= _suspended;
	@synthesize imageCompressionQuality = _imageCompressionQuality;


	#pragma mark Shared Queue

	+(UXURLRequestQueue *) mainQueue {
		if (!gMainQueue) {
			gMainQueue = [[UXURLRequestQueue alloc] init];
		}
		return gMainQueue;
	}

	+(void) setMainQueue:(UXURLRequestQueue *)queue {
		if (gMainQueue != queue) {
			[gMainQueue release];
			gMainQueue = [queue retain];
		}
	}


	#pragma mark Initializer

	-(id) init {
		if (self == [super init]) {
			_loaders					= [[NSMutableDictionary alloc] init];
			_loaderQueue				= [[NSMutableArray alloc] init];
			_loaderQueueTimer			= nil;
			_totalLoading				= 0;
			maxConcurrentLoads			= kMaxConcurrentLoads;
			_maxContentLength			= kDefaultMaxContentLength;
			_imageCompressionQuality	= 0.75;
			_userAgent					= [kSafariUserAgent copy];
			_suspended					= NO;
		}
		return self;
	}

	-(void) dealloc {
		delegate = nil;
		[_loaderQueueTimer invalidate];
		UX_SAFE_RELEASE(_loaders);
		UX_SAFE_RELEASE(_loaderQueue);
		UX_SAFE_RELEASE(_userAgent);
		[super dealloc];
	}


	#pragma mark -

	-(NSData *) loadFromBundle:(NSString *)URL error:(NSError **)error {
		NSString *path		= UXPathForBundleResource([URL substringFromIndex:9]);
		NSFileManager *fm	= [NSFileManager defaultManager];
		if ([fm fileExistsAtPath:path]) {
			/*
			return [NSData dataWithContentsOfFile:path];
			*/
			// Bundles shouldn't change during NSData object existence, so we 
			// could safely use mapped version here.
			return [NSData dataWithContentsOfMappedFile:path];
		}
		else if (error)  {
			*error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileReadNoSuchFileError userInfo:nil];
		}
		return nil;
	}

	-(NSData *) loadFromDocuments:(NSString *)URL error:(NSError **)error {
		NSString *path		= UXPathForDocumentsResource([URL substringFromIndex:12]);
		NSFileManager *fm	= [NSFileManager defaultManager];
		if ([fm fileExistsAtPath:path]) {
			/*
			return [NSData dataWithContentsOfFile:path];
			*/
			return [NSData dataWithContentsOfFile:path 
										  options:[UXURLCache sharedCache].fileReadOptions 
											error:nil];
		}
		else if (error)  {
			*error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileReadNoSuchFileError userInfo:nil];
		}
		return nil;
	}

	-(id) loadFromDelegate:(NSString *)URL error:(NSError **)error {
		id data = nil;
		if (delegate && [delegate respondsToSelector:@selector(imageForURL:)]) {
			data = [delegate imageForURL:URL];
		}
		else if (error) {
			*error = [NSError errorWithDomain:NSCocoaErrorDomain
										 code:NSFileReadNoSuchFileError 
									 userInfo:nil];
		}
		return data;
	}

	-(BOOL) loadFromCache:(NSString *)URL cacheKey:(NSString *)cacheKey expires:(NSTimeInterval)expirationAge fromDisk:(BOOL)fromDisk data:(id *)data error:(NSError **)error timestamp:(NSDate **)timestamp {
		UIImage *image = [[UXURLCache sharedCache] imageForURL:URL fromDisk:fromDisk];
		if (image) {
			*data = image;
			return YES;
		}
		else if (fromDisk)  {
			if (UXIsBundleURL(URL)) {
				*data = [self loadFromBundle:URL error:error];
				return YES;
			}
			else if (UXIsDocumentsURL(URL))  {
				*data = [self loadFromDocuments:URL error:error];
				return YES;
			}
			else if (UXIsAskDelegateURL(URL)){
				*data = [self loadFromDelegate:URL error:error];
				return TRUE;
			}
			else {
				*data = [[UXURLCache sharedCache] dataForKey:cacheKey expires:expirationAge timestamp:timestamp];
				if (*data) {
					return YES;
				}
			}
		}
		return NO;
	}

	-(BOOL) loadRequestFromCache:(UXURLRequest *)request {
		if (!request.cacheKey) {
			request.cacheKey = [[UXURLCache sharedCache] keyForURL:request.URL];
		}

		if (request.cachePolicy & (UXURLRequestCachePolicyDisk | UXURLRequestCachePolicyMemory)) {
			id data				= nil;
			NSDate *timestamp	= nil;
			NSError *error		= nil;

			BOOL loadedFromCache = [self loadFromCache:request.URL 
											  cacheKey:request.cacheKey
											   expires:request.cacheExpirationAge
											  fromDisk:!_suspended && request.cachePolicy & UXURLRequestCachePolicyDisk
												  data:&data 
												 error:&error 
											 timestamp:&timestamp];
			if (loadedFromCache) {
				request.isLoading = NO;

				if (!error) {
					error = [request.response request:request processResponse:nil data:data];
				}

				if (error) {
					for (id <UXURLRequestDelegate> aDelegate in request.delegates) {
						if ([aDelegate respondsToSelector:@selector(request:didFailLoadWithError:)]) {
							[aDelegate request:request didFailLoadWithError:error];
						}
					}
				}
				else {
					request.timestamp			= timestamp ? timestamp : [NSDate date];
					request.respondedFromCache	= YES;

					for (id <UXURLRequestDelegate> aDelegate in request.delegates) {
						if ([aDelegate respondsToSelector:@selector(requestDidFinishLoad:)]) {
							[aDelegate requestDidFinishLoad:request];
						}
					}
				}
				return YES;
			}
		}
		return NO;
	}

	-(void) executeLoader:(UXURLRequestLoader *)loader {
		id data				= nil;
		NSDate *timestamp	= nil;
		NSError *error		= nil;

		if ((loader.cachePolicy & (UXURLRequestCachePolicyDisk | UXURLRequestCachePolicyMemory))
			&& [self loadFromCache:loader.URL cacheKey:loader.cacheKey
						   expires:loader.cacheExpirationAge
						  fromDisk:loader.cachePolicy & UXURLRequestCachePolicyDisk
							  data:&data error:&error timestamp:&timestamp]) {
			[_loaders removeObjectForKey:loader.cacheKey];

			if (!error) {
				error = [loader processResponse:nil data:data];
			}
			if (error) {
				[loader dispatchError:error];
			}
			else {
				[loader dispatchLoaded:timestamp];
			}
		}
		else {
			++_totalLoading;
			[loader load:[NSURL URLWithString:loader.URL]];
		}
	}

	-(void) loadNextInQueueDelayed {
		if (!_loaderQueueTimer) {
			_loaderQueueTimer = [NSTimer scheduledTimerWithTimeInterval:kFlushDelay 
																 target:self
															   selector:@selector(loadNextInQueue) 
															   userInfo:nil 
																repeats:NO];
		}
	}

	-(void) loadNextInQueue {
		_loaderQueueTimer = nil;

		for (NSInteger i = 0; i < maxConcurrentLoads && _totalLoading < maxConcurrentLoads && _loaderQueue.count; ++i) {
			UXURLRequestLoader *loader = [[_loaderQueue objectAtIndex:0] retain];
			[_loaderQueue removeObjectAtIndex:0];
			[self executeLoader:loader];
			[loader release];
		}
		if (_loaderQueue.count && !_suspended) {
			[self loadNextInQueueDelayed];
		}
	}

	-(void) removeLoader:(UXURLRequestLoader *)loader {
		--_totalLoading;
		[_loaders removeObjectForKey:loader.cacheKey];
	}

	-(void) loader:(UXURLRequestLoader *)loader didLoadResponse:(NSHTTPURLResponse *)response data:(id)data {
		[loader retain];
		[self removeLoader:loader];
		
		NSError *error = [loader processResponse:response data:data];
		if (error) {
			[loader dispatchError:error];
		}
		else {
			if (!(loader.cachePolicy & UXURLRequestCachePolicyNoCache)) {
				[[UXURLCache sharedCache] storeData:data forKey:loader.cacheKey];
			}
			[loader dispatchLoaded:[NSDate date]];
		}
		[loader release];
		
		[self loadNextInQueue];
	}

	-(void) loader:(UXURLRequestLoader *)loader didFailLoadWithError:(NSError *)error {
		UXLOG(@"ERROR: %@", error);
		[self removeLoader:loader];
		[loader dispatchError:error];
		[self loadNextInQueue];
	}

	-(void) loaderDidCancel:(UXURLRequestLoader *)loader wasLoading:(BOOL)wasLoading {
		if (wasLoading) {
			[self removeLoader:loader];
			[self loadNextInQueue];
		}
		else {
			[_loaders removeObjectForKey:loader.cacheKey];
		}
	}


	#pragma mark -

	-(void) setSuspended:(BOOL)isSuspended {
		// UXLOG(@"SUSPEND LOADING %d", isSuspended);
		_suspended = isSuspended;

		if (!_suspended) {
			[self loadNextInQueue];
		}
		else if (_loaderQueueTimer)  {
			[_loaderQueueTimer invalidate];
			_loaderQueueTimer = nil;
		}
	}

	-(BOOL) sendRequest:(UXURLRequest *)request {
		if ([self loadRequestFromCache:request]) {
			return YES;
		}
		for (id <UXURLRequestDelegate> aDelegate in request.delegates) {
			if ([aDelegate respondsToSelector:@selector(requestDidStartLoad:)]) {
				[aDelegate requestDidStartLoad:request];
			}
		}
		if (!request.URL.length) {
			NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadURL userInfo:nil];
			for (id <UXURLRequestDelegate> aDelegate in request.delegates) {
				if ([aDelegate respondsToSelector:@selector(request:didFailLoadWithError:)]) {
					[aDelegate request:request didFailLoadWithError:error];
				}
			}
			return NO;
		}

		request.isLoading				= YES;
		UXURLRequestLoader *loader	= nil;
		if (![request.httpMethod isEqualToString:@"POST"]) {
			/*
			Next, see if there is an active loader for the URL and if so join that bandwagon
			*/
			loader = [_loaders objectForKey:request.cacheKey];
			if (loader) {
				[loader addRequest:request];
				return NO;
			}
		}

		// Finally, create a new loader and hit the network (unless we are suspended)
		loader = [[UXURLRequestLoader alloc] initForRequest:request queue:self];
		[_loaders setObject:loader forKey:request.cacheKey];
		if (_suspended || (_totalLoading == maxConcurrentLoads) ) {
			[_loaderQueue addObject:loader];
		}
		else {
			++_totalLoading;
			[loader load:[NSURL URLWithString:request.URL]];
		}
		[loader release];
		return NO;
	}

	-(void) cancelRequest:(UXURLRequest *)request {
		if (request) {
			UXURLRequestLoader *loader = [_loaders objectForKey:request.cacheKey];
			if (loader) {
				[loader retain];
				if (![loader cancel:request]) {
					[_loaderQueue removeObject:loader];
				}
				[loader release];
			}
		}
	}

	-(void) cancelRequestsWithDelegate:(id)aDelegate {
		NSMutableArray *requestsToCancel = nil;
		for (UXURLRequestLoader *loader in [_loaders objectEnumerator]) {
			for (UXURLRequest *request in loader.requests) {
				for (id<UXURLRequestDelegate> requestDelegate in request.delegates) {
					if (aDelegate == requestDelegate) {
						if (!requestsToCancel) {
							requestsToCancel = [NSMutableArray array];
						}
						[requestsToCancel addObject:request];
						break;
					}
				}

				if ([request.userInfo isKindOfClass:[UXUserInfo class]]) {
					UXUserInfo *userInfo = request.userInfo;
					if (userInfo.weak && (userInfo.weak == aDelegate) ) {
						if (!requestsToCancel) {
							requestsToCancel = [NSMutableArray array];
						}
						[requestsToCancel addObject:request];
					}
				}
			}
		}
		for (UXURLRequest *request in requestsToCancel) {
			[self cancelRequest:request];
		}
	}

	-(void) cancelAllRequests {
		for (UXURLRequestLoader *loader in [[[_loaders copy] autorelease] objectEnumerator]) {
			[loader cancel];
		}
	}


	#pragma mark -

	-(NSURLRequest *) createNSURLRequest:(UXURLRequest *)aRequest URL:(NSURL *)aURL {
		if (!aURL) {
			aURL = [NSURL URLWithString:aRequest.URL];
		}
		
		[NSURLRequest setAllowsAnyHTTPSCertificate:TRUE 
										   forHost:[aURL host]];
		NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:aURL
																  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
															  timeoutInterval:kTimeout];
		[URLRequest setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];

		if (aRequest) {
			[URLRequest setHTTPShouldHandleCookies:aRequest.shouldHandleCookies];
			
			NSString *method = aRequest.httpMethod;
			if (method) {
				[URLRequest setHTTPMethod:method];
			}
			
			NSString *contentType = aRequest.contentType;
			if (contentType) {
				[URLRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
			}

			NSData *body = aRequest.httpBody;
			if (body) {
				[URLRequest setHTTPBody:body];
			}
			
			NSDictionary* headers = aRequest.headers;
			for (NSString *key in [headers keyEnumerator]) {
				[URLRequest setValue:[headers objectForKey:key] forHTTPHeaderField:key];
			}
		}
		return URLRequest;
	}

@end
