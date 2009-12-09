
/*!
@project	UXKit
@header		UXModel.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXURLRequest.h>

// This protocol is about state, seemingly network based...

/*!
@protocol UXModel <NSObject>
@abstract Describes the state of an object that can be loaded from a remote source.
@discussion By implementing this protocol, you can communicate to the user the state 
of network activity in an object.
*/
@protocol UXModel <NSObject>

	/*!
	@abstract An array of objects that conform to the UXModelDelegate protocol.
	*/
	-(NSMutableArray *) delegates;

	/*!
	@abstract Indicates that the data has been loaded.
	*/
	-(BOOL) isLoaded;

	/*!
	@abstract Indicates that the data is in the process of loading.
	*/
	-(BOOL) isLoading;

	/*!
	@abstract Indicates that the data is in the process of loading additional data.
	*/
	-(BOOL) isLoadingMore;

	/*!
	@abstract Indicates that the model is of date and should be reloaded as soon as possible.
	*/
	-(BOOL) isOutdated;

	/*!
	@abstract Loads the model.
	*/
	-(void) load:(UXURLRequestCachePolicy)cachePolicy more:(BOOL)more;

	/*!
	@abstract Cancels a load that is in progress.
	*/
	-(void) cancel;

	/*!
	@abstract Invalidates data stored in the cache or optionally erases it.
	*/
	-(void) invalidate:(BOOL)erase;

@end

#pragma mark -

/*!
@protocol UXModelDelegate <NSObject>
@abstract
*/
@protocol UXModelDelegate <NSObject>

@optional
	-(void) modelDidStartLoad:(id <UXModel>)aModel;
	-(void) modelDidFinishLoad:(id <UXModel>)aModel;
	-(void) modelDidCancelLoad:(id <UXModel>)aModel;

	-(void) model:(id <UXModel>)aModel didFailLoadWithError:(NSError *)error;

	/*!
	@abstract Informs the delegate that the model has changed in some fundamental way.
	@discussion The change is not described specifically, so the delegate must assume that the entire
	contents of the model may have changed, and react almost as if it was given a new model.
	*/
	-(void) modelDidChange:(id <UXModel>)aModel;

	-(void) model:(id <UXModel>)aModel didUpdateObject:(id)anObject atIndexPath:(NSIndexPath *)anIndexPath;
	-(void) model:(id <UXModel>)aModel didInsertObject:(id)anObject atIndexPath:(NSIndexPath *)anIndexPath;
	-(void) model:(id <UXModel>)aModel didDeleteObject:(id)anObject atIndexPath:(NSIndexPath *)anIndexPath;

	/*!
	@abstract Informs the delegate that the model is about to begin a multi-stage update.
	@discussion Models should use this method to condense multiple updates into a single visible update.
	This avoids having the view update multiple times for each change.  Instead, the user will
	only see the end result of all of your changes when you call modelDidEndUpdates.
	*/
	-(void) modelDidBeginUpdates:(id <UXModel>)aModel;

	/*!
	@abstract Informs the delegate that the model has completed a multi-stage update.
	@discussion The exact nature of the change is not specified, so the receiver should 
	investigate the new state of the model by examining its properties.
	*/
	-(void) modelDidEndUpdates:(id <UXModel>)aModel;

@end

#pragma mark -

/*!
@class UXModel
@superclass NSObject <UXModel>
@abstract A default implementation of UXModel does nothing other than appear to be loaded.
@discussion
*/
@interface UXModel : NSObject <UXModel> {
	NSMutableArray *_delegates;
}

	/*!
	@abstract Notifies delegates that the model started to load.
	*/
	-(void) didStartLoad;

	/*!
	@abstract Notifies delegates that the model finished loading
	*/
	-(void) didFinishLoad;

	/*!
	@abstract Notifies delegates that the model failed to load.
	*/
	-(void) didFailLoadWithError:(NSError *)error;

	/*!
	@abstract Notifies delegates that the model canceled its load.
	*/
	-(void) didCancelLoad;

	/*!
	@abstract Notifies delegates that the model has begun making multiple updates.
	*/
	-(void) beginUpdates;

	/*!
	@abstract Notifies delegates that the model has completed its updates.
	*/
	-(void) endUpdates;

	/*!
	@abstract Notifies delegates that an object was updated.
	*/
	-(void) didUpdateObject:(id)object atIndexPath:(NSIndexPath *)indexPath;

	/*!
	@abstract Notifies delegates that an object was inserted.
	*/
	-(void) didInsertObject:(id)object atIndexPath:(NSIndexPath *)indexPath;

	/*!
	@abstract Notifies delegates that an object was deleted.
	*/
	-(void) didDeleteObject:(id)object atIndexPath:(NSIndexPath *)indexPath;

	/*!
	@abstract Notifies delegates that the model changed in some fundamental way.
	*/
	-(void) didChange;

@end

#pragma mark -

/*!
@class UXURLRequestModel
@superclass UXModel <UXURLRequestDelegate>
@abstract An implementation of UXModel which is built to work with UXURLRequests.
@discussion If you use a UXURLRequestModel as the delegate of your UXURLRequests, 
it will automatically manage many of the UXModel properties based on the state of 
your requests.
*/
@interface UXURLRequestModel : UXModel <UXURLRequestDelegate> {
	UXURLRequest *_loadingRequest;
	NSDate *_loadedTime;
	NSString *_cacheKey;
	BOOL _isLoadingMore;
	BOOL _hasNoMore;
}

	@property (nonatomic, retain) NSDate *loadedTime;
	@property (nonatomic, copy) NSString *cacheKey;
	@property (nonatomic) BOOL hasNoMore;

	/*!
	@abstract Resets the model to its original state before any data was loaded.
	*/
	-(void) reset;

@end
