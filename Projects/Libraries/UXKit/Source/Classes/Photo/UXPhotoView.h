
/*!
@project	UXKit 
@header		UXPhotoView.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXImageView.h>
#import <UXKit/UXPhotoSource.h>

@protocol UXPhoto;
@class UXActivityLabel, UXLabel;

/*!
@class UXPhotoView
@superclass UXImageView <UXImageViewDelegate>
@abstract
@discussion
*/
@interface UXPhotoView : UXImageView <UXImageViewDelegate> {
	id <UXPhoto> _photo;
	UIActivityIndicatorView *_statusSpinner;
	UXLabel *_statusLabel;
	UXLabel *_captionLabel;
	UXStyle *_captionStyle;
	UXPhotoVersion _photoVersion;
	BOOL _hidesExtras;
	BOOL _hidesCaption;
}

	@property (nonatomic, retain) id <UXPhoto> photo;
	@property (nonatomic, retain) UXStyle *captionStyle;
	@property (nonatomic) BOOL hidesExtras;
	@property (nonatomic) BOOL hidesCaption;
	
	-(BOOL) loadPreview:(BOOL)fromNetwork;
	-(void) loadImage;

	-(void) showProgress:(CGFloat)progress;
	-(void) showStatus:(NSString *)text;

@end
