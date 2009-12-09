
/*!
@project	UXKit
@header     UXURLRequest.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXGlobal.h>

@protocol UXURLRequestDelegate, UXURLResponse;

/*!
@class UXURLRequest
@superclass NSObject
@abstract
@discussion
*/
@interface UXURLRequest : NSObject {
	NSString *_URL;
	NSString *_httpMethod;
	NSData *_httpBody;
	NSMutableDictionary *_parameters;
	NSMutableDictionary *_headers;
	NSString *_contentType;
	NSMutableArray *_delegates;
	NSMutableArray *_files;
	id <UXURLResponse> _response;
	UXURLRequestCachePolicy _cachePolicy;
	NSTimeInterval _cacheExpirationAge;
	NSString *_cacheKey;
	NSDate *_timestamp;
	NSInteger _totalBytesLoaded;
	NSInteger _totalBytesExpected;
	NSInteger _bodySize;
	id _userInfo;
	BOOL _isLoading;
	BOOL _shouldHandleCookies;
	BOOL _respondedFromCache;
//	BOOL postShouldSendMultipartFormData;
	NSURLCredential *_credential;
	BOOL _filterPasswordLogging;
}

	/*!
	@abstract An object that receives messages about the progress of the request.
	*/
	@property (nonatomic, readonly) NSMutableArray *delegates;

	/*!
	@abstract An object that handles the response data and may parse and validate it.
	*/
	@property (nonatomic, retain) id <UXURLResponse> response;

	/*!
	@abstract The URL to be loaded by the request.
	*/
	@property (nonatomic, copy) NSString *URL;

	/*!
	@abstract The HTTP method to send with the request.
	*/
	@property (nonatomic, copy) NSString *httpMethod;

	/*!
	@abstract The HTTP body to send with the request.
	*/
	@property (nonatomic, retain) NSData *httpBody;

	/*!
	@abstract The content type of the data in the request.
	*/
	@property (nonatomic, copy) NSString *contentType;

	/*!
	@abstract Parameters to use for an HTTP post.
	*/
	@property (nonatomic, readonly) NSMutableDictionary *parameters;

	/*!
	@abstract Custom HTTP headers.
	*/
	@property (nonatomic, readonly) NSMutableDictionary *headers;

	/*!
	@abstract Defaults to "any".
	*/
	@property (nonatomic) UXURLRequestCachePolicy cachePolicy;

	/*!
	@abstract The maximum age of cached data that can be used as a response.
	*/
	@property (nonatomic) NSTimeInterval cacheExpirationAge;

	@property (nonatomic, retain) NSString *cacheKey;

	@property (nonatomic, retain) id userInfo;

	@property (nonatomic, retain) NSDate *timestamp;

	@property (nonatomic) BOOL isLoading;

	@property (nonatomic) BOOL shouldHandleCookies;

	@property (nonatomic) NSInteger totalBytesLoaded;

	@property (nonatomic) NSInteger totalBytesExpected;

	@property (nonatomic) BOOL respondedFromCache;

	/*!
	@abstract Whether parameters named "password" should be suppressed in log messages.
	*/
	@property (nonatomic, assign) BOOL filterPasswordLogging;


	/*!
	@abstract The credential to use for an authentication challenge
	*/
	@property (nonatomic, retain) NSURLCredential *credential;

	@property (nonatomic, readonly) NSInteger bodySize;



	#pragma mark Constructors

	+(UXURLRequest *) request;

	+(UXURLRequest *) requestWithURL:(NSString *)aURLString delegate:(id <UXURLRequestDelegate>)aDelegate;
	
	
	#pragma mark Initializers

	/*!
	@abstract
	@param URL ￼￼
	@param delegate ￼￼
	*/
	-(id) initWithURL:(NSString *)aURLString delegate:(id <UXURLRequestDelegate>)aDelegate;

	/*!
	@abstract
	@param value ￼
	@param field ￼
	*/
	-(void) setValue:(NSString *)aValue forHTTPHeaderField:(NSString *)aField;

	/*!
	@abstract Adds a file whose data will be posted.
	*/
	-(void) addFile:(NSData *)data mimeType:(NSString *)aMimeType fileName:(NSString *)aFileName;

	/*!
	@abstract Attempts to send a request.
	@discussion	If the request can be resolved by the cache, it will happen synchronously.  Otherwise,
				the request will respond to its delegate asynchronously.
	@result YES if the request was loaded synchronously from the cache.
	*/
	-(BOOL) send;

	/*!
	@abstract Attempts to send a Synchronous request.
	@discussion	The request will happen Synchronously, regardless of whether the data is being grabbed from
	the network or from the cache.
	@result YES if the request was loaded from the cache.
	*/
	-(BOOL) sendSynchronously;

	/*!
	@abstract Cancels the request. If there are multiple requests going to the same URL as this request, 
	the others will not be cancelled.
	*/
	-(void) cancel;


	#pragma mark -

	-(NSURLRequest *) createNSURLRequest;

@end

#pragma mark -

/*!
@protocol UXURLRequestDelegate <NSObject>
@abstract
*/
@protocol UXURLRequestDelegate <NSObject>

@optional
	/*!
	@abstract The request has begun loading.
	*/
	-(void) requestDidStartLoad:(UXURLRequest *)aRequest;

	/*!
	@abstract The request has loaded some more data.
	@discussion Check the totalBytesLoaded and totalBytesExpected properties for details.
	*/
	-(void) requestDidUploadData:(UXURLRequest *)aRequest;

	/*!
	@abstract The request has loaded data has loaded and been processed into a response.
	@discussion If the request is served from the cache, this is the only delegate method that will be called.
	*/
	-(void) requestDidFinishLoad:(UXURLRequest *)aRequest;

	-(void) request:(UXURLRequest *)aRequest didFailLoadWithError:(NSError *)anError;

	-(void) requestDidCancelLoad:(UXURLRequest *)arRequest;

	-(NSMutableDictionary *) headers;

@end

#pragma mark -

/*!
@class UXUserInfo
@superclass NSObject
@abstract A helper class for storing user info to help identify a request.
@discussion This class lets you store both a strong reference and a weak reference for the duration of
the request.  The weak reference is special because UXURLRequestQueue will examine it when
you call cancelRequestsWithDelegate to see if the weak object is the delegate in question.
For this reason, this object is a safe way to store an object that may be destroyed before
the request completes if you call cancelRequestsWithDelegate in the object's destructor.
*/
@interface UXUserInfo : NSObject {
	NSString *_topic;
	id _strong;
	id _weak;
}

	@property (nonatomic, retain) NSString *topic;
	@property (nonatomic, retain) id strong;
	@property (nonatomic, assign) id weak;

	+(id) topic:(NSString *)aTopic strong:(id)aStrongObject weak:(id)aWeakObject;
	+(id) topic:(NSString *)aTopic;
	+(id) weak:(id)aWeakObject;

	-(id) initWithTopic:(NSString *)aTopic strong:(id)aStrongObject weak:(id)aWeakObject;

@end
