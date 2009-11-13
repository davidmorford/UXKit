
/*!
@project	UXKit
@header		UXPostController.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXPopupViewController.h>

@protocol UXPostControllerDelegate;
@class UXActivityLabel, UXView;

/*!
@class UXPostController
@superclass UXPopupViewController <UXTextEditorDelegate>
@abstract
@discussion
*/
@interface UXPostController : UXPopupViewController <UITextViewDelegate> {
	id <UXPostControllerDelegate> _delegate;
	id _result;
	NSString *_defaultText;
	CGRect _originRect;
	UIView *_originView;
	UIView *_innerView;
	UINavigationBar* _navigationBar;
	UXView *_screenView;
	UITextView *_textView;
	UXActivityLabel *_activityView;
	BOOL _originalStatusBarHidden;
	UIStatusBarStyle _originalStatusBarStyle;
}

	@property (nonatomic, assign) id <UXPostControllerDelegate> delegate;
	@property (nonatomic, retain) id result;
	@property (nonatomic, readonly) UITextView *textView;
	@property (nonatomic, readonly) UINavigationBar* navigatorBar;
	@property (nonatomic, retain) UIView *originView;

	#pragma mark -

	/*!
	@abstract Posts the text to delegates, who have to actually do something with it.
	*/
	-(void) post;

	/*!
	@abstract Cancels the controller, but confirms with the user if they have entered text.
	*/
	-(void) cancel;

	/*!
	@abstract Dismisses the controller with a resulting that is sent to the delegate.
	*/
	-(void) dismissWithResult:(id)aResult animated:(BOOL)animated;

	/*!
	@abstract Notifies the user of an error and resets the editor to normal.
	*/
	-(void) failWithError:(NSError *)anError;

	/*!
	@abstract The users has entered text and posted it.
	@discussion Subclasses can implement this to handle the text before it is 
	sent to the delegate. The default returns NO.
	@result YES if the controller should be dismissed immediately.
	*/
	-(BOOL) willPostText:(NSString *)aTextString;

	-(NSString *) titleForActivity;
	-(NSString *) titleForError:(NSError *)anError;

@end

#pragma mark -

/*!
@protocol UXPostControllerDelegate <NSObject>
@abstract
*/
@protocol UXPostControllerDelegate <NSObject>

@optional
	/*!
	@abstract The user has posted text and an animation is about to show the text return to its origin.
	@return whether to dismiss the controller or wait for the user to call dismiss.
	*/
	-(BOOL) postController:(UXPostController *)aPostController willPostText:(NSString *)aTextString;

	/*!
	@abstract The text will animate towards a rectangle.
	@result the rect in screen coordinates where the text should animate towards.
	*/
	-(CGRect) postController:(UXPostController *)aPostController willAnimateTowards:(CGRect)aRect;

	/*!
	@abstract The text has been posted.
	*/
	-(void) postController:(UXPostController *)aPostController didPostText:(NSString *)aTextString withResult:(id)aResult;

	/*!
	@abstract The controller was cancelled before posting.
	*/
	-(void) postControllerDidCancel:(UXPostController *)aPostController;

@end
