
/*!
@project	UXKit
@header     UXThumbsViewController.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXTableViewController.h>
#import <UXKit/UXThumbsTableViewCell.h>
#import <UXKit/UXPhotoSource.h>

@protocol UXThumbsViewControllerDelegate;
@protocol UXPhotoSource;
@class UXPhotoViewController;

/*!
@class UXThumbsViewController
@superclass UXTableViewController <UXThumbsTableViewCellDelegate>
@abstract
@discussion
*/
@interface UXThumbsViewController : UXTableViewController <UXThumbsTableViewCellDelegate> {
	id <UXThumbsViewControllerDelegate> _delegate;
	id <UXPhotoSource> _photoSource;
}

	@property (nonatomic, assign) id <UXThumbsViewControllerDelegate> delegate;
	@property (nonatomic, retain) id <UXPhotoSource> photoSource;

	-(id) initWithDelegate:(id <UXThumbsViewControllerDelegate>)aDelegate;
	-(id) initWithQuery:(NSDictionary *)aQuery;

	-(UXPhotoViewController *) createPhotoViewController;
	-(id <UXTableViewDataSource>) createDataSource;

@end

#pragma mark -

/*!
@class UXThumbsDataSource
@superclass UXTableViewDataSource
@abstract
@discussion
*/
@interface UXThumbsDataSource : UXTableViewDataSource {
	id <UXThumbsTableViewCellDelegate> _delegate;
	id <UXPhotoSource> _photoSource;
}

	@property (nonatomic, assign) id <UXThumbsTableViewCellDelegate> delegate;
	@property (nonatomic, retain) id <UXPhotoSource> photoSource;

	-(id) initWithPhotoSource:(id <UXPhotoSource>)aPhotoSource delegate:(id <UXThumbsTableViewCellDelegate>)aDelegate;

@end

#pragma mark -

/*!
@protocol UXThumbsViewControllerDelegate <NSObject>
@abstract 
*/
@protocol UXThumbsViewControllerDelegate <NSObject>

	-(void) thumbsViewController:(UXThumbsViewController *)aController didSelectPhoto:(id <UXPhoto>)aPhoto;

@optional
	-(BOOL) thumbsViewController:(UXThumbsViewController *)aController shouldNavigateToPhoto:(id <UXPhoto>)aPhoto;

@end
