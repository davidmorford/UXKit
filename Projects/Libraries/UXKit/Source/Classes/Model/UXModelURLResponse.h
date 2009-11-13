
/*!
@project	UXKit
@header		UXModelURLResponse.h
@copyright  (c) 2009 Keith Lazuka
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXKit.h>

extern NSString* const UXModelURLResponseJSONFormat;
extern NSString* const UXModelURLResponseSOAPFormat;
extern NSString* const UXModelURLResponseRSSFormat;
extern NSString* const UXModelURLResponseATOMFormat;

/*!
@class UXModelURLResponse 
@superclass NSObject <UXURLResponse>
@abstract Abstract base class for HTTP response parsers that create 
domain objects from the response. 
@discussion Subclasses are responsible for setting the  |remoteObjectCount| 
property from the HTTP response.  This enables features like the photo browsing systems 
automatic "Load More Photos" button.
*/
@interface UXModelURLResponse : NSObject <UXURLResponse> {
	NSMutableArray *objects;
	NSUInteger remoteObjectCount;
}

	/*!
	@abstract Read-only for users, read-write for subclasses
	*/
	@property (nonatomic, retain) NSMutableArray *objects;
	@property (nonatomic, readonly) NSString *responseFormatType;
	@property (nonatomic, readonly) NSUInteger remoteObjectCount;

	+(id) response;

@end
