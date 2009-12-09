
#import <UXKit/UXURLRequest.h>
#import <UXKit/UXURLResponse.h>
#import <UXKit/UXURLRequestQueue.h>
#import <CommonCrypto/CommonDigest.h>

static NSString *kStringBoundary = @"3i2ndDfv2rTHiSisAbouNdArYfORhtTPEefj3q2f";

@implementation UXURLRequest

	@synthesize delegates			= _delegates;
	@synthesize URL					= _URL;
	@synthesize response			= _response;
	@synthesize httpMethod			= _httpMethod;
	@synthesize httpBody			= _httpBody;
	@synthesize parameters			= _parameters;
	@synthesize contentType			= _contentType;
	@synthesize cachePolicy			= _cachePolicy;
	@synthesize cacheExpirationAge	= _cacheExpirationAge;
	@synthesize cacheKey			= _cacheKey;
	@synthesize timestamp			= _timestamp;
	@synthesize userInfo			= _userInfo;
	@synthesize isLoading			= _isLoading;
	@synthesize shouldHandleCookies = _shouldHandleCookies;
	@synthesize totalBytesLoaded	= _totalBytesLoaded;
	@synthesize totalBytesExpected	= _totalBytesExpected;
	@synthesize respondedFromCache	= _respondedFromCache;
	@synthesize headers				= _headers;
	@synthesize filterPasswordLogging = _filterPasswordLogging;
	@synthesize credential			= _credential;
	@synthesize bodySize			= _bodySize;

	#pragma mark Constructors

	+(UXURLRequest *) request {
		return [[[UXURLRequest alloc] init] autorelease];
	}

	+(UXURLRequest *) requestWithURL:(NSString *)aURL delegate:(id <UXURLRequestDelegate>)aDelegate {
		return [[[UXURLRequest alloc] initWithURL:aURL delegate:aDelegate] autorelease];
	}

	
	#pragma mark Intializers

	-(id) initWithURL:(NSString *)aURL delegate:(id <UXURLRequestDelegate>)delegate {
		if (self = [self init]) {
			_URL = [aURL retain];
			if (delegate) {
				[_delegates addObject:delegate];
			}
		}
		return self;
	}

	-(id) init {
		if (self = [super init]) {
			_URL					= nil;
			_httpMethod				= nil;
			_httpBody				= nil;
			_headers				= nil;
			_parameters				= nil;
			_contentType			= nil;
			_delegates				= UXCreateNonRetainingArray();
			_files					= nil;
			_response				= nil;
			_cachePolicy			= UXURLRequestCachePolicyDefault;
			_cacheExpirationAge		= UX_DEFAULT_CACHE_EXPIRATION_AGE;
			_timestamp				= nil;
			_cacheKey				= nil;
			_userInfo				= nil;
			_isLoading				= NO;
			_shouldHandleCookies	= YES;
			_totalBytesLoaded		= 0;
			_totalBytesExpected		= 0;
			_bodySize				= 0;
			_respondedFromCache		= NO;
			 _filterPasswordLogging = NO;
			_credential				= nil;
		}
		return self;
	}


	#pragma mark -

	-(NSMutableDictionary *) headers {
		if (!_headers) {
			_headers = [[NSMutableDictionary alloc] init];
		}
		return _headers;
	}

	-(NSString *) md5HexDigest:(NSString *)input {
		const char *str = [input UTF8String];
		unsigned char result[CC_MD5_DIGEST_LENGTH];
		CC_MD5(str, strlen(str), result);
		return [NSString stringWithFormat:
				@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
				result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
				result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
				];
	}

	-(NSString *) generateCacheKey {
		if ([_httpMethod isEqualToString:@"POST"]) {
			NSMutableString *joined = [[[NSMutableString alloc] initWithString:self.URL] autorelease];
			NSEnumerator *e			= [_parameters keyEnumerator];
			for (id key; key = [e nextObject]; ) {
				[joined appendString:key];
				[joined appendString:@"="];
				NSObject *value = [_parameters valueForKey:key];
				if ([value isKindOfClass:[NSString class]]) {
					[joined appendString:(NSString *)value];
				}
			}
			return [self md5HexDigest:joined];
		}
		else {
			return [self md5HexDigest:self.URL];
		}
	}


	-(NSData *) generatePostBody {
		NSMutableData *body = [NSMutableData data];
		NSString *beginLine = [NSString stringWithFormat:@"\r\n--%@\r\n", kStringBoundary];
		
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n", kStringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
		
		for (id key in [_parameters keyEnumerator]) {
			NSString *value = [_parameters valueForKey:key];
			if (![value isKindOfClass:[UIImage class]]) {
				[body appendData:[beginLine dataUsingEncoding:NSUTF8StringEncoding]];
				[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
				[body appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
			}
		}
		
		NSString *imageKey = nil;
		for (id key in [_parameters keyEnumerator]) {
			
			if ([[_parameters objectForKey:key] isKindOfClass:[UIImage class]]) {
				UIImage *image	= [_parameters objectForKey:key];
				CGFloat quality = [UXURLRequestQueue mainQueue].imageCompressionQuality;
				NSData *data	= UIImageJPEGRepresentation(image, quality);
				
				[body appendData:[beginLine dataUsingEncoding:NSUTF8StringEncoding]];
				[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
				[body appendData:[[NSString stringWithFormat:@"Content-Length: %d\r\n", data.length] dataUsingEncoding:NSUTF8StringEncoding]];
				[body appendData:[[NSString stringWithString:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
				[body appendData:data];
				imageKey = key;
			}
		}
		
		for (NSInteger i = 0; i < _files.count; i += 3) {
			
			NSData *data		= [_files objectAtIndex:i];
			NSString *mimeType	= [_files objectAtIndex:i + 1];
			NSString *fileName	= [_files objectAtIndex:i + 2];
			
			[body appendData:[beginLine dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fileName, fileName] dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:[[NSString stringWithFormat:@"Content-Length: %d\r\n", data.length] dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimeType] dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:data];
		}
		
		[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", kStringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
		
		// If an image was found, remove it from the dictionary to save memory while we perform the upload
		if (imageKey) {
			[_parameters removeObjectForKey:imageKey];
		}
		
		//UXLOG(@"Sending %s", [body bytes]);
		_bodySize = [body length];
		return body;
	}

/*	-(NSData *) generateMultipartPostBody {
		
		NSMutableData *body = [NSMutableData data];
		NSString *beginLine = [NSString stringWithFormat:@"\r\n--%@\r\n", kStringBoundary];
		
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n", kStringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
		
		for (id key in [_parameters keyEnumerator]) {
			
			NSString *value = [_parameters valueForKey:key];
			
			if (![value isKindOfClass:[UIImage class]]) {
				
				[body appendData:[beginLine dataUsingEncoding:NSUTF8StringEncoding]];
				[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
				[body appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
			}
		}
		
		NSString *imageKey = nil;
		for (id key in [_parameters keyEnumerator]) {
		
			if ([[_parameters objectForKey:key] isKindOfClass:[UIImage class ]]) {
			
				UIImage *image	= [_parameters objectForKey:key];
				CGFloat quality = [UXURLRequestQueue mainQueue].imageCompressionQuality;
				NSData *data	= UIImageJPEGRepresentation(image, quality);
				
				[body appendData:[beginLine dataUsingEncoding:NSUTF8StringEncoding]];
				[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
				[body appendData:[[NSString stringWithFormat:@"Content-Length: %d\r\n", data.length] dataUsingEncoding:NSUTF8StringEncoding]];
				[body appendData:[[NSString stringWithString:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
				[body appendData:data];
				imageKey = key;
			}
		}
		
		for (NSInteger i = 0; i < _files.count; i += 3) {
			NSData *data		= [_files objectAtIndex:i];
			NSString *mimeType	= [_files objectAtIndex:i + 1];
			NSString *fileName	= [_files objectAtIndex:i + 2];
			
			[body appendData:[beginLine dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fileName, fileName] dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:[[NSString stringWithFormat:@"Content-Length: %d\r\n", data.length] dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimeType] dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:data];
		}
		
		[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", kStringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
		
		// If an image was found, remove it from the dictionary to save memory while we perform the upload
		if (imageKey) {
			[_parameters removeObjectForKey:imageKey];
		}
		
		//UXLOG(@"Sending %s", [body bytes]);
		return body;
	}
*/
	-(NSData *) generateURLEncodedPostBody {
		NSMutableArray *urlParameters = [NSMutableArray array];
		for (id key in [_parameters keyEnumerator]) {
			if (![[_parameters objectForKey:key] isKindOfClass:[UIImage class ]]) {
				NSString *encodedValue	= [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)[_parameters valueForKey:key], NULL, CFSTR("?=&+;"), kCFStringEncodingUTF8) autorelease];
				NSString *encodedKey	= [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)key, NULL, CFSTR("?=&+;"), kCFStringEncodingUTF8) autorelease];
				[urlParameters addObject:[NSString stringWithFormat:@"%@=%@", encodedKey, encodedValue]];
			}
		}
		return [[urlParameters componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding];
	}


	#pragma mark -


	-(NSMutableDictionary *) parameters {
		if (!_parameters) {
			_parameters = [[NSMutableDictionary alloc] init];
		}
		return _parameters;
	}

	-(NSData *) httpBody {
		if (_httpBody) {
			return _httpBody;
		}
		else if ([[_httpMethod uppercaseString] isEqualToString:@"POST"]) {
			return [self generatePostBody];
		}
		else {
			return nil;
		}
	}

	-(NSString *) contentType {
		if (_contentType) {
			return _contentType;
		}
		else if ([_httpMethod isEqualToString:@"POST"]) {
			return [NSString stringWithFormat:@"multipart/form-data; boundary=%@", kStringBoundary];
		}
		else {
			return nil;
		}
	}

	/*
	-(NSMutableDictionary *) parameters {
		if (!_parameters) {
			_parameters = [[NSMutableDictionary alloc] init];
		}
		return _parameters;
	}

	-(NSData *) httpBody {
		if (_httpBody) {
			return _httpBody;
		}
		else if ([[_httpMethod uppercaseString] isEqualToString:@"POST"]) {
			return [self generatePostBody];
		}
		else {
			return nil;
		}
	}

	-(NSString *) contentType {
		if (_contentType) {
			return _contentType;
		}
		else if ([_httpMethod isEqualToString:@"POST"]) {
			return [NSString stringWithFormat:@"multipart/form-data; boundary=%@", kStringBoundary];
		}
		else {
			return nil;
		}
	}*/

	-(NSString *) cacheKey {
		if (!_cacheKey) {
			_cacheKey = [[self generateCacheKey] retain];
		}
		return _cacheKey;
	}

	-(void) setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
		if (!_headers) {
			_headers = [[NSMutableDictionary alloc] init];
		}
		[_headers setObject:value forKey:field];
	}

	-(void) addFile:(NSData *)data mimeType:(NSString *)mimeType fileName:(NSString *)fileName {
		if (!_files) {
			_files = [[NSMutableArray alloc] init];
		}
		
		[_files addObject:data];
		[_files addObject:mimeType];
		[_files addObject:fileName];
	}

	-(BOOL) send {
		if (_parameters) {
			// Don't log passwords. Save now, restore after logging
			NSString *password = [_parameters objectForKey:@"password"];
			if (_filterPasswordLogging && password) {
				[_parameters setObject:@"[FILTERED]" forKey:@"password"];
			}
			
			//TTDINFO(@"SEND %@ %@", self.URL, self.parameters);
			
			if (password) {
				[_parameters setObject:password forKey:@"password"];
			}
		}
		return [[UXURLRequestQueue mainQueue] sendRequest:self];
	}


	-(BOOL) sendSynchronously {
		return [[UXURLRequestQueue mainQueue] sendSynchronousRequest:self];
	}

	-(void) cancel {
		[[UXURLRequestQueue mainQueue] cancelRequest:self];
	}

	-(NSURLRequest *) createNSURLRequest {
		return [[UXURLRequestQueue mainQueue] createNSURLRequest:self URL:nil];
	}


	#pragma mark <NSObject>

	-(NSString *) description {
		return [NSString stringWithFormat:@"<UXURLRequest %@>", _URL];
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_URL);
		UX_SAFE_RELEASE(_httpMethod);
		UX_SAFE_RELEASE(_httpBody);
		UX_SAFE_RELEASE(_headers);
		UX_SAFE_RELEASE(_parameters);
		UX_SAFE_RELEASE(_contentType);
		UX_SAFE_RELEASE(_delegates);
		UX_SAFE_RELEASE(_files);
		UX_SAFE_RELEASE(_response);
		UX_SAFE_RELEASE(_timestamp);
		UX_SAFE_RELEASE(_cacheKey);
		UX_SAFE_RELEASE(_userInfo);
		UX_SAFE_RELEASE(_credential);
		[super dealloc];
	}

@end

#pragma mark -

@implementation UXUserInfo

	@synthesize topic = _topic, strong = _strong, weak = _weak;

	+(id) topic:(NSString *)topic strong:(id)strong weak:(id)weak {
		return [[[UXUserInfo alloc] initWithTopic:topic strong:strong weak:weak] autorelease];
	}

	+(id) topic:(NSString *)topic {
		return [[[UXUserInfo alloc] initWithTopic:topic strong:nil weak:nil] autorelease];
	}

	+(id) weak:(id)weak {
		return [[[UXUserInfo alloc] initWithTopic:nil strong:nil weak:weak] autorelease];
	}


	#pragma mark NSObject

	-(id) initWithTopic:(NSString *)topic strong:(id)strong weak:(id)weak {
		if (self = [super init]) {
			self.topic = topic;
			self.strong = strong;
			self.weak = weak;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_topic);
		UX_SAFE_RELEASE(_strong);
		[super dealloc];
	}

@end
	