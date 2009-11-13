
/*!
@project	UXKit
@header     UXURLResponse.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXGlobal.h>

@class UXURLRequest;

/*!
@protocol UXURLResponse <NSObject>
@abstract
*/
@protocol UXURLResponse <NSObject>

	/*!
	@abstract Processes the data from a successful request and determines if it is valid.
	If the data is not valid, return an error.  The data will not be cached if there is an error.
	*/
	-(NSError *) request:(UXURLRequest *)aRequest processResponse:(NSURLResponse *)aResponse data:(id)data;

@end

/*!
@class UXURLDataResponse
@superclass NSObject <UXURLResponse>
@abstract
@discussion
*/
@interface UXURLDataResponse : NSObject <UXURLResponse> {
	NSData *_data;
}

	@property (nonatomic, readonly) NSData *data;

@end

/*!
@class UXURLImageResponse
@superclass NSObject <UXURLResponse>
@abstract
@discussion
*/
@interface UXURLImageResponse : NSObject <UXURLResponse> {
	UIImage *_image;
}

	@property (nonatomic, readonly) UIImage *image;

@end
