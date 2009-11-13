
/*!
@project	UXWebService
@header     URLModelResponse.h
@copyright  (c) 2009 Keith Lazuka
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXKit.h>

/*!
@class URLModelResponse
@superclass NSObject <UXURLResponse>
@abstract An abstract base class for HTTP response parsers that construct domain objects from the response.
Subclasses are responsible for setting the  |totalObjectsAvailableOnServer| property from
the HTTP response. This enables features like the photo browsing systems automatic 
"Load More Photos" button.
@discussion
*/
@interface URLModelResponse : NSObject <UXURLResponse> {
	NSMutableArray *objects;
	NSUInteger totalObjectsAvailableOnServer;
}

	// Intended to be read-only for clients, read-write for sub-classes
	@property (nonatomic, retain) NSMutableArray *objects;
	@property (nonatomic, readonly) NSUInteger totalObjectsAvailableOnServer;

	+(id) response;
	-(NSString *) format;

@end
