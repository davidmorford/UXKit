
#import <UXKit/UXURLRequestLoader.h>
#import <UXKit/UXURLCache.h>
#import <UXKit/UXURLRequestQueue.h>
#import <UXKit/UXURLRequest.h>
#import <UXKit/UXURLResponse.h>

NSInteger const UXURLRequestLoaderMaxRetries = 2;

@implementation UXURLRequestLoader

	@synthesize URL					= _URL;
	@synthesize requests			= _requests; 
	@synthesize cacheKey			= _cacheKey;
	@synthesize cachePolicy			= _cachePolicy;
	@synthesize cacheExpirationAge	= _cacheExpirationAge;
	@synthesize credential			= _credential;


	#pragma mark Initializer

	-(id) initForRequest:(UXURLRequest *)aRequest queue:(UXURLRequestQueue *)aQueue {
		if (self = [super init]) {
			_URL				= [aRequest.URL copy];
			_queue				= aQueue;
			_cacheKey			= [aRequest.cacheKey retain];
			_cachePolicy		= aRequest.cachePolicy;
			_cacheExpirationAge = aRequest.cacheExpirationAge;
			_requests			= [[NSMutableArray alloc] init];
			_connection			= nil;
			_retriesLeft		= UXURLRequestLoaderMaxRetries;
			_response			= nil;
			_responseData		= nil;
			_credential			= [aRequest.credential retain];
			[self addRequest:aRequest];
		}
		return self;
	}


	#pragma mark -

	-(NSError *) processResponse:(NSURLResponse *)aResponse data:(id)data {
		for (UXURLRequest *request in _requests) {
			NSError *error = [request.response request:request processResponse:aResponse data:data];
			if (error) {
				return error;
			}
		}
		return nil;
	}

	-(void) dispatchLoadedBytes:(NSInteger)bytesLoaded expected:(NSInteger)bytesExpected {
		for (UXURLRequest *request in [[_requests copy] autorelease]) {
			request.totalBytesLoaded	= bytesLoaded;
			request.totalBytesExpected	= bytesExpected;
			for (id <UXURLRequestDelegate> delegate in request.delegates) {
				if ([delegate respondsToSelector:@selector(requestDidUploadData:)]) {
					[delegate requestDidUploadData:request];
				}
			}
		}
	}

	-(void) dispatchLoaded:(NSDate *)timestamp {
		for (UXURLRequest *request in [[_requests copy] autorelease]) {
			request.timestamp = timestamp;
			request.isLoading = NO;
			for (id <UXURLRequestDelegate> delegate in request.delegates) {
				if ([delegate respondsToSelector:@selector(requestDidFinishLoad:)]) {
					[delegate requestDidFinishLoad:request];
				}
			}
		}
	}

	-(void) dispatchError:(NSError *)error {
		for (UXURLRequest *request in [[_requests copy] autorelease]) {
			request.isLoading = NO;
			for (id <UXURLRequestDelegate> delegate in request.delegates) {
				if ([delegate respondsToSelector:@selector(request:didFailLoadWithError:)]) {
					[delegate request:request didFailLoadWithError:error];
				}
			}
		}
	}


	#pragma mark <NSURLConnectionDelegate>

	-(BOOL) connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
		return YES;
	}

	-(void) connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
		if ([challenge proposedCredential]) {
			UXLOG(@"proposedCredential: %@", [challenge proposedCredential]);
		}
		if ([challenge error]) {
			UXLOG(@"error: %@", [challenge error]);
		}
		
		UXLOG(@"previousFailureCount: %d", [challenge previousFailureCount]);
		
		if (([challenge previousFailureCount] == 0) && self.credential) {
			[[challenge sender] useCredential:self.credential forAuthenticationChallenge:challenge];
		}
		else {
			[[challenge sender] cancelAuthenticationChallenge:challenge];
		}
	}

	/*
	-(void) connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	}
	*/

	/*
	-(BOOL) connectionShouldUseCredentialStorage:(NSURLConnection *)connection {
		UXLOG(@"connectionShouldUseCredentialStorage");
	}
	*/

	-(void) connection:(NSURLConnection *)aConnection didReceiveResponse:(NSHTTPURLResponse *)aResponse {
		_response				= [aResponse retain];
		/*
		NSDictionary *headers	= [aResponse allHeaderFields];
		NSInteger contentLength	= [[headers objectForKey:@"Content-Length"] integerValue];
		if ((contentLength > _queue.maxContentLength) && _queue.maxContentLength) {
			UXLOG(@"MAX CONTENT LENGTH EXCEEDED (%d) %@", contentLength, _URL);
			[self cancel];
		}
		*/
		NSInteger contentLength = 0;
		if ([aResponse isKindOfClass:[NSHTTPURLResponse class]]) {
			NSDictionary *headers	= [(NSHTTPURLResponse *)aResponse allHeaderFields];
			NSInteger contentLength	= [[headers objectForKey:@"Content-Length"] intValue];
			if ((contentLength > _queue.maxContentLength) && _queue.maxContentLength) {
				UXLOG(@"MAX CONTENT LENGTH EXCEEDED (%d) %@", contentLength, _URL);
				[self cancel];
			}
		}
		_responseData = [[NSMutableData alloc] initWithCapacity:contentLength];
	}

	-(void) connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)data {
		[_responseData appendData:data];
	}

	-(void) connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
		[self dispatchLoadedBytes:totalBytesWritten expected:totalBytesExpectedToWrite];
	}

	-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
		UXLOG(@"  FAILED LOADING %@ FOR %@", _URL, error);
		UXNetworkRequestStopped();
		UX_SAFE_RELEASE(_responseData);
		UX_SAFE_RELEASE(_connection);
		if ([error.domain isEqualToString:NSURLErrorDomain] && (error.code == NSURLErrorCannotFindHost) && _retriesLeft) {
			// If there is a network error then we will wait and retry a few times just in case
			// it was just a temporary blip in connectivity
			--_retriesLeft;
			[self load:[NSURL URLWithString:_URL]];
		}
		else {
			[_queue performSelector:@selector(loader:didFailLoadWithError:) withObject:self withObject:error];
		}
	}

	-(void) connectionDidFinishLoading:(NSURLConnection *)aConnection {
		UXNetworkRequestStopped();
		/* 
		Assume if we're not servicing an HTTP url response, it succeeded. Other URL
		schemes such as file:// will fail with connection:didFailWithError:
		*/
		NSInteger statusCode = 200;
		if ([_response isKindOfClass:[NSHTTPURLResponse class]]) {
			NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)_response;
			statusCode						= httpResponse.statusCode;
		}
		
		if (statusCode == 200 /*|| statusCode == 201*/) {
			[_queue performSelector:@selector(loader:didLoadResponse:data:) withObject:self withObject:_response withObject:_responseData];
		}
		else {
			UXLOG(@"  FAILED LOADING (%d) %@", statusCode, _URL);
			NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:statusCode userInfo:[NSDictionary dictionaryWithObject:_responseData forKey:@"response"]];
			[_queue performSelector:@selector(loader:didFailLoadWithError:) withObject:self withObject:error];
		}
		UX_SAFE_RELEASE(_responseData);
		UX_SAFE_RELEASE(_connection);
	}

	-(NSCachedURLResponse *) connection:(NSURLConnection *)aConnection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
		return nil;
	}


	#pragma mark -

	-(void) connectToURL:(NSURL *)aURL {
		UXLOG(@"Connecting to %@", _URL);
		UXNetworkRequestStarted();
		UXURLRequest *request		= _requests.count == 1 ? [_requests objectAtIndex:0] : nil;
		NSURLRequest *URLRequest	= [_queue createNSURLRequest:request URL:aURL];
		_connection					= [[NSURLConnection alloc] initWithRequest:URLRequest delegate:self];
	}

	-(BOOL) isLoading {
		return !!_connection;
	}

	-(void) addRequest:(UXURLRequest *)aRequest {
		[_requests addObject:aRequest];
	}

	-(void) removeRequest:(UXURLRequest *)aRequest {
		[_requests removeObject:aRequest];
	}

	-(void) load:(NSURL *)aURL {
		if (!_connection) {
			[self connectToURL:aURL];
		}
	}

	-(void) cancel {
		NSArray *requestsToCancel = [_requests copy];
		for (id request in requestsToCancel) {
			[self cancel:request];
		}
		[requestsToCancel release];
	}

	-(BOOL) cancel:(UXURLRequest *)request {
		NSUInteger index = [_requests indexOfObject:request];
		if (index != NSNotFound) {
			request.isLoading = NO;
			for (id <UXURLRequestDelegate> delegate in request.delegates) {
				if ([delegate respondsToSelector:@selector(requestDidCancelLoad:)]) {
					[delegate requestDidCancelLoad:request];
				}
			}
			[_requests removeObjectAtIndex:index];
		}
		if (![_requests count]) {
			[_queue performSelector:@selector(loaderDidCancel:wasLoading:) withObject:self withObject:(id) !!_connection];
			if (_connection) {
				UXNetworkRequestStopped();
				[_connection cancel];
				UX_SAFE_RELEASE(_connection);
			}
			return NO;
		}
		else {
			return YES;
		}
	}


	#pragma mark -

	-(void) dealloc {
		[_connection cancel];
		UX_SAFE_RELEASE(_connection);
		UX_SAFE_RELEASE(_response);
		UX_SAFE_RELEASE(_responseData);
		UX_SAFE_RELEASE(_URL);
		UX_SAFE_RELEASE(_cacheKey);
		UX_SAFE_RELEASE(_requests);
		UX_SAFE_RELEASE(_credential);
		[super dealloc];
	}

@end
