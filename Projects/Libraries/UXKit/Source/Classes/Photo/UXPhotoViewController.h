
/*!
@project	UXKit
@header		UXPhotoViewController.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXModelViewController.h>
#import <UXKit/UXPhotoSource.h>
#import <UXKit/UXScrollView.h>
#import <UXKit/UXThumbsViewController.h>

@class UXScrollView, UXPhotoView, UXStyle;

/*!
@class UXPhotoViewController
@superclass UXModelViewController <UXScrollViewDelegate, UXScrollViewDataSource, UXThumbsViewControllerDelegate>
@abstract
@discussion
*/
@interface UXPhotoViewController : UXModelViewController <UXScrollViewDelegate, UXScrollViewDataSource, UXThumbsViewControllerDelegate, UIActionSheetDelegate> {
	id <UXPhotoSource> _photoSource;
	id <UXPhoto> _centerPhoto;
	NSInteger _centerPhotoIndex;
	UIView *_innerView;
	UXScrollView *_scrollView;
	UXPhotoView *_photoStatusView;
	UIToolbar *_toolbar;
	UIBarButtonItem *_nextButton;
	UIBarButtonItem *_previousButton;
	UIBarButtonItem *_deleteButton;
	UXStyle *_captionStyle;
	UIImage *_defaultImage;
	NSString *_statusText;
	UXThumbsViewController *_thumbsController;
	NSTimer *_slideshowTimer;
	NSTimer *_loadTimer;
	BOOL _delayLoad;
}

	/*!
	@abstract The source of a sequential photo collection that will be displayed.
	*/
	@property (nonatomic, retain) id <UXPhotoSource> photoSource;

	/*!
	@abstract The photo that is currently visible and centered.
	@discussion You can assign this directly to change the photoSource to the 
	one that contains the photo.
	*/
	@property (nonatomic, retain) id <UXPhoto> centerPhoto;

	/*!
	@abstract The index of the currently visible photo.
	@discussion Because centerPhoto can be nil while waiting for the source 
	to load the photo, this property must be maintained even though centerPhoto 
	has its own index property.
	*/
	@property (nonatomic, readonly) NSInteger centerPhotoIndex;

	/*!
	@abstract The default image to show before a photo has been loaded.
	*/
	@property (nonatomic, retain) UIImage *defaultImage;

	/*!
	@abstract The style to use for the caption label.
	*/
	@property (nonatomic, retain) UXStyle *captionStyle;


	#pragma mark Initializers

	-(id) initWithPhoto:(id <UXPhoto>)aPhoto;
	-(id) initWithPhotoSource:(id <UXPhotoSource>)aPhotoSource;
	

	#pragma mark -
	
	/*!
	@abstract Creates a photo view for a new page.
	@discussion Do not call this directly. It is meant to be overriden by subclasses.
	*/
	-(UXPhotoView *) createPhotoView;

	/*!
	@abstract Creates the thumbnail controller used by the "See All" button.
	@discussion Do not call this directly. It is meant to be overriden by subclasses.
	*/
	-(UXThumbsViewController *) createThumbsViewController;

	/*!
	@abstract Sent to the controller after it moves from one photo to another.
	*/
	-(void) didMoveToPhoto:(id <UXPhoto>)aPhoto fromPhoto:(id <UXPhoto>)fromPhoto;

	/*!
	@abstract Shows or hides an activity label on top of the photo.
	*/
	-(void) showActivity:(NSString *)aTitle;

@end
