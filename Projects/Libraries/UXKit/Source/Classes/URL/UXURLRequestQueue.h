
/*!
@project	UXKit
@header     UXURLRequestQueue.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXGlobal.h>

@protocol UXURLRequestQueueDelegate <NSObject>
@optional
	-(UIImage *) imageForURL:(NSString *)aURL;
@end

@class UXURLRequest;

/*!
@class UXURLRequestQueue
@superclass NSObject
@abstract
@discussion
*/
@interface UXURLRequestQueue : NSObject {
	id delegate;
	NSMutableDictionary *_loaders;
	NSMutableArray *_loaderQueue;
	NSTimer *_loaderQueueTimer;
	NSInteger _totalLoading;
	NSUInteger maxConcurrentLoads;
	NSUInteger _maxContentLength;
	NSString *_userAgent;
	CGFloat _imageCompressionQuality;
	BOOL _suspended;
}

	/*!
	@abstract The delegate to ask for delegate:// URLs
	*/
	@property (nonatomic, assign) id delegate;

	/*!
	@abstract Gets the flag that determines if new load requests are allowed to reach the network.
	@discussion Because network requests tend to slow down performance, this property can be used 
	to temporarily delay them.  All requests made while suspended are queued, and when suspended 
	becomes false again they are executed.
	*/
	@property (nonatomic) BOOL suspended;

	/*!
	@abstract The maximum number of concurrent loads that are allowed. Defaults to 5.
	@abstract If a request is made that exceeds the maximum number of concurrent 
	loads in progress it will be queued and wait until the load has decreased.
	*/
	@property (nonatomic) NSUInteger maxConcurrentLoads;

	/*!
	@abstract The maximum size of a download that is allowed.
	@discussion If a response reports a content length greater than the max, the download 
	will be cancelled.  This is helpful for preventing excessive memory usage.  Setting this to
	zero will allow all downloads regardless of size.  The default is a relatively large value.
	*/
	@property (nonatomic) NSUInteger maxContentLength;

	/*!
	@abstract The user-agent string that is sent with all HTTP requests.
	*/
	@property (nonatomic, copy) NSString *userAgent;

	/*!
	@abstract The compression quality used for encoding images sent with HTTP posts.
	*/
	@property (nonatomic) CGFloat imageCompressionQuality;
	

	#pragma mark -

	/*!
	@abstract Gets the shared cache singleton used across the application.
	*/
	+(UXURLRequestQueue *) mainQueue;

	/*!
	@abstract Sets the shared cache singleton used across the application.
	*/
	+(void) setMainQueue:(UXURLRequestQueue *)aQueue;
	

	#pragma mark -

	/*!
	@abstract Loads a request from the cache or the network if it is not in the cache.
	@result YES if the request was loaded synchronously from the cache.
	*/
	-(BOOL) sendRequest:(UXURLRequest *)aRequest;

	/*!
	@abstract Synchronously loads a request from the cache or the network if it is not in the cache.
	@result YES if the request was loaded from the cache.
	*/
	-(BOOL) sendSynchronousRequest:(UXURLRequest *)request;

	/*!
	@abstract Cancels a request that is in progress.
	*/
	-(void) cancelRequest:(UXURLRequest *)aRequest;

	/*!
	@abstract Cancels all active or pending requests whose delegate or response is an object.
	@discussion This is useful for when an object is about to be destroyed and you want to remove pointers
	to it from active requests to prevent crashes when those pointers are later referenced.
	*/
	-(void) cancelRequestsWithDelegate:(id)aDelegate;

	/*!
	@abstract Cancel all active or pending requests.
	*/
	-(void) cancelAllRequests;

	/*!
	@abstract Creates a Cocoa URL request from a UXKit URL request.
	*/
	-(NSURLRequest *) createNSURLRequest:(UXURLRequest *)aRequest URL:(NSURL *)aURL;

@end
