
/*!
@project	UXKit
@header     UXImageView.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXView.h>
#import <UXKit/UXURLRequest.h>

@protocol UXImageViewDelegate;

/*!
@class UXImageView
@superclass UXView <UXURLRequestDelegate>
@abstract
@discussion
*/
@interface UXImageView : UXView <UXURLRequestDelegate> {
	id <UXImageViewDelegate> _delegate;
	UXURLRequest *_request;
	NSString *_URL;
	UIImage *_image;
	UIImage *_defaultImage;
	BOOL _autoresizesToImage;
}

	@property (nonatomic, assign) id <UXImageViewDelegate> delegate;
	@property (nonatomic, copy) NSString *URL;
	@property (nonatomic, retain) UIImage *image;
	@property (nonatomic, retain) UIImage *defaultImage;
	@property (nonatomic) BOOL autoresizesToImage;
	@property (nonatomic, readonly) BOOL isLoading;
	@property (nonatomic, readonly) BOOL isLoaded;

	-(void) reload;
	-(void) stopLoading;

	-(void) imageViewDidStartLoad;
	-(void) imageViewDidLoadImage:(UIImage *)image;
	-(void) imageViewDidFailLoadWithError:(NSError *)error;

@end

#pragma mark -

/*!
@protocol UXImageViewDelegate <NSObject>
@abstract
*/
@protocol UXImageViewDelegate <NSObject>

@optional
	-(void) imageView:(UXImageView *)imageView didLoadImage:(UIImage *)image;
	-(void) imageViewDidStartLoad:(UXImageView *)imageView;
	-(void) imageView:(UXImageView *)imageView didFailLoadWithError:(NSError *)error;

@end
