
/*!
@project	UXKit
@header     UXPhotoSource.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXURLMap.h>
#import <UXKit/UXModel.h>

#define UX_NULL_PHOTO_INDEX NSIntegerMax

@protocol UXPhoto;
@class UXURLRequest;

typedef enum {
	UXPhotoVersionNone,
	UXPhotoVersionLarge,
	UXPhotoVersionMedium,
	UXPhotoVersionSmall,
	UXPhotoVersionThumbnail
} UXPhotoVersion;

#pragma mark -

/*!
@protocol UXPhotoSource <UXModel, UXURLObject>
@abstract
*/
@protocol UXPhotoSource <UXModel, UXURLObject>

	/*!
	@abstractThe title of this collection of photos.
	*/
	@property (nonatomic, copy) NSString *title;

	/*!
	@abstractThe total number of photos in the source, independent of the number that have been loaded.
	*/
	@property (nonatomic, readonly) NSInteger numberOfPhotos;

	/*!
	@abstractThe maximum index of photos that have already been loaded.
	*/
	@property (nonatomic, readonly) NSInteger maxPhotoIndex;

	-(id <UXPhoto>) photoAtIndex:(NSInteger)index;

@optional
	-(void) deletePhotoAtIndex:(NSInteger)index;

@end

#pragma mark -

/*!
@protocol UXPhoto <NSObject, UXURLObject>
@abstract
*/
@protocol UXPhoto <NSObject, UXURLObject>

	/*!
	@abstract The photo source that the photo belongs to.
	*/
	@property (nonatomic, assign) id <UXPhotoSource> photoSource;

	/*!
	@abstract The index of the photo within its photo source.
	*/
	@property (nonatomic) CGSize size;

	/*!
	@abstract The index of the photo within its photo source.
	*/
	@property (nonatomic) NSInteger index;

	/*!
	@abstract The caption of the photo.
	*/
	@property (nonatomic, copy) NSString *caption;

	/*!
	@abstract Gets the URL of one of the differently sized versions of the photo.
	*/
	-(NSString *) URLForVersion:(UXPhotoVersion)version;

@end
