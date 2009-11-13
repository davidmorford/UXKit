
/*!
@project	UXKit
@header		UXModelViewController.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXViewController.h>
#import <UXKit/UXModel.h>

/*!
@class UXModelViewController
@superclass UXViewController <UXModelDelegate>
@abstract A view controller that manages a model in addition to a view.
@discussion
*/
@interface UXModelViewController : UXViewController <UXModelDelegate> {
	id <UXModel> _model;
	NSError *_modelError;
	struct {
		unsigned int isModelDidRefreshInvalid : 1;
		unsigned int isModelWillLoadInvalid : 1;
		unsigned int isModelDidLoadInvalid : 1;
		unsigned int isModelDidLoadFirstTimeInvalid : 1;
		unsigned int isModelDidShowFirstTimeInvalid : 1;
		unsigned int isViewInvalid : 1;
		unsigned int isViewSuspended : 1;
		unsigned int isUpdatingView : 1;
		unsigned int isShowingEmpty : 1;
		unsigned int isShowingLoading : 1;
		unsigned int isShowingModel : 1;
		unsigned int isShowingError : 1;
	} _flags;
	
}

	@property (nonatomic, retain) id <UXModel> model;

	/*!
	@abstract An error that occurred while trying to load content.
	*/
	@property (nonatomic, retain) NSError *modelError;
	

	#pragma mark API

	/*!
	@abstract Creates the model that the controller manages.
	*/
	-(void) createModel;

	/*!
	@abstract Releases the current model and forces the creation of a new model.
	*/
	-(void) invalidateModel;

	/*!
	@abstract Indicates whether the model has been created.
	*/
	-(BOOL) isModelCreated;

	/*!
	@abstract Indicates that data should be loaded from the model.
	@discussion Do not call this directly.  Subclasses should implement this method.
	*/
	-(BOOL) shouldLoad;

	/*!
	@abstract Indicates that data should be reloaded from the model.
	@discussion Do not call this directly.  Subclasses should implement this method.
	*/
	-(BOOL) shouldReload;

	/*!
	@abstract Indicates that more data should be loaded from the model.
	@discussion Do not call this directly.  Subclasses should implement this method.
	*/
	-(BOOL) shouldLoadMore;

	/*!
	@abstract Tests if it is possible to show the model.
	@discussion After a model has loaded, this method is called to test whether or not to set the model
	has content that can be shown.  If you return NO, showEmpty: will be called, and if you
	return YES, showModel: will be called.
	*/
	-(BOOL) canShowModel;

	/*!
	@abstract Reloads data from the model.
	*/
	-(void) reload;

	/*!
	@abstract Reloads data from the model if it has become out of date.
	*/
	-(void) reloadIfNeeded;

	/*!
	@abstract Refreshes the model state and loads new data if necessary.
	*/
	-(void) refresh;

	/*!
	@abstract Begins a multi-stage update.
	@discussion You can call this method to make complicated updates more efficient, and to condense
	multiple changes to your model into a single visual change.  Call endUpdate when you are done
	to update the view with all of your changes.
	*/
	-(void) beginUpdates;

	/*!
	@abstract Ends a multi-stage model update and updates the view to reflect the model.
	@discussion You can call this method to make complicated updates more efficient, and to condense
	multiple changes to your model into a single visual change.
	*/
	-(void) endUpdates;

	/*!
	@abstract Indicates that the model has changed and schedules the view to be updated to reflect it.
	*/
	-(void) invalidateView;

	/*!
	@abstract Immediately creates, loads, and displays the model (if it was not already).
	*/
	-(void) updateView;

	/*!
	@abstract Called when the model is refreshed.
	@discussion  Subclasses should override this function update parts of the view that may need 
	to changed when there is a new model, or something about the existing model changes.
	*/
	-(void) didRefreshModel;

	/*!
	@abstract Called before the model is asked to load itself. This is not called until after the view has loaded.  
	If your model starts loading before the view is loaded, this will still be called, but not until after the view 
	is loaded.
	@discussion The default implementation of this method does nothing. Subclasses may override this method
	to take an appropriate action.
	*/
	-(void) willLoadModel;

	/*!
	@abstract Called after the model has loaded, just before it is to be displayed.
	@discussion This is not called until after the view has loaded.  If your model finishes loading before
	the view is loaded, this will still be called, but not until after the view is loaded.
	If you refresh a model which is already loaded, this will be called, but the firstTime
	argument will be false.
	The default implementation of this method does nothing.Subclasses may override this method
	to take an appropriate action.
	*/
	-(void) didLoadModel:(BOOL)firstTime;

	/*!
	@abstract Called just after a model has been loaded and displayed.
	@discussion The default implementation of this method does nothing. Subclasses may override this method
	to take an appropriate action.
	*/
	-(void) didShowModel:(BOOL)firstTime;

	/*!
	@abstract Shows views to represent the loaded model's content.
	@discussion The default implementation of this method does nothing. Subclasses may override this method
	to take an appropriate action.
	*/
	-(void) showModel:(BOOL)show;

	/*!
	@abstract Shows views to represent the model loading.
	@discussion The default implementation of this method does nothing. Subclasses may override this method
	to take an appropriate action.
	*/
	-(void) showLoading:(BOOL)show;

	/*!
	@abstract Shows views to represent an empty model.
	@discussion The default implementation of this method does nothing. Subclasses may override this method
	to take an appropriate action.
	*/
	-(void) showEmpty:(BOOL)show;

	/*!
	@abstract Shows views to represent an error that occurred while loading the model.
	*/
	-(void) showError:(BOOL)show;

@end
