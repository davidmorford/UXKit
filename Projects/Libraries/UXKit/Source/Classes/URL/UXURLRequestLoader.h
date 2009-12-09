
/*!
@project    UXKit
@header     UXURLRequestLoader.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXGlobal.h>

@class UXURLRequest;
@class UXURLRequestQueue;

extern NSInteger const UXURLRequestLoaderMaxRetries;

/*!
@class UXURLRequestLoader
@superclass NSObject
@abstract
@discussion
*/
@interface UXURLRequestLoader : NSObject {
	NSString *_URL;
	UXURLRequestQueue *_queue;
	NSString *_cacheKey;
	UXURLRequestCachePolicy _cachePolicy;
	NSTimeInterval _cacheExpirationAge;
	NSMutableArray *_requests;
	NSURLConnection *_connection;
	NSURLResponse *_response;
	NSMutableData *_responseData;
	int _retriesLeft;
	NSURLCredential *_credential;
}

	@property (nonatomic, readonly) NSArray *requests;
	@property (nonatomic, readonly) NSString *URL;
	@property (nonatomic, readonly) NSString *cacheKey;
	@property (nonatomic, readonly) UXURLRequestCachePolicy cachePolicy;
	@property (nonatomic, readonly) NSTimeInterval cacheExpirationAge;
	@property (nonatomic, readonly) BOOL isLoading;
	@property (nonatomic, readonly) NSURLCredential *credential;

	#pragma mark -

	-(id) initForRequest:(UXURLRequest *)aRequest queue:(UXURLRequestQueue *)aQueue;

	-(void) addRequest:(UXURLRequest *)aRequest;
	-(void) removeRequest:(UXURLRequest *)aRequest;

	-(void) load:(NSURL *)aURL;
	-(void) loadSynchronously:(NSURL*)aURL;
	
	-(void) cancel;
	-(BOOL) cancel:(UXURLRequest *)aRequest;

@end

#pragma mark -

/*!
@category UXURLRequestLoader (Processing)
@abstract
*/
@interface UXURLRequestLoader (Processing)

	-(NSError *) processResponse:(NSURLResponse *)aResponse data:(id)data;

	-(void) dispatchLoadedBytes:(NSInteger)bytesLoaded expected:(NSInteger)bytesExpected;
	-(void) dispatchLoaded:(NSDate *)timestamp;
	-(void) dispatchError:(NSError *)error;

@end
