
/*!
@project    UXKit
@header     UXTextBarController.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXPopupViewController.h>
#import <UXKit/UXTextEditor.h>

@protocol UXTextBarDelegate;
@class UXButton;

/*!
@class UXTextBarController
@superclass UXPopupViewController <UXTextEditorDelegate>
@abstract
@discussion
*/
@interface UXTextBarController : UXPopupViewController <UXTextEditorDelegate> {
	id <UXTextBarDelegate> _delegate;
	id _result;
	NSString *_defaultText;
	UXView* _textBar;
	UXTextEditor *_textEditor;
	UXButton *_postButton;
	UIView *_footerBar;
	CGFloat _originTop;
	UIBarButtonItem *_previousRightBarButtonItem;
}

	@property (nonatomic, assign) id <UXTextBarDelegate> delegate;
	@property (nonatomic, readonly) UXTextEditor *textEditor;
	@property (nonatomic, readonly) UXButton *postButton;
	@property (nonatomic, retain) UIView *footerBar;

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
	-(void) dismissWithResult:(id)result animated:(BOOL)animated;

	/*!
	@abstract Notifies the user of an error and resets the editor to normal.
	*/
	-(void) failWithError:(NSError *)error;

	/*!
	@abstract The users has entered text and posted it.
	@discussion Subclasses can implement this to handle the text before it is 
	sent to the delegate. The default returns NO.
	@result YES if the controller should be dismissed immediately.
	*/
	-(BOOL) willPostText:(NSString *)text;

	-(NSString *) titleForActivity;
	-(NSString *) titleForError:(NSError *)error;

@end

#pragma mark -

/*!
@protocol UXTextBarDelegate <NSObject>
@abstract
@discussion
*/
@protocol UXTextBarDelegate <NSObject>

@optional
	-(void) textBarDidBeginEditing:(UXTextBarController *)textBar;
	-(void) textBarDidEndEditing:(UXTextBarController *)textBar;

	/*!
	@abstract The user has posted text and an animation is about to show the text return to its origin.
	@result	whether to dismiss the controller or wait for the user to call dismiss.
	*/
	-(BOOL) textBar:(UXTextBarController *)textBar willPostText:(NSString *)text;

	/*!
	@abstract The text has been posted.
	*/
	-(void) textBar:(UXTextBarController *)textBar didPostText:(NSString *)text withResult:(id)result;

	/*!
	@abstract The controller was cancelled before posting.
	*/
	-(void) textBarDidCancel:(UXTextBarController *)textBar;

@end
