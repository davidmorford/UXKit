
/*!
@project	UXKit
@header     UXMessageController.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXViewController.h>
#import <UXKit/UXTextEditor.h>

@protocol UXTableViewDataSource, UXMessageControllerDelegate;
@class UXPickerTextField, UXActivityLabel;

/*!
@class UXMessageController
@superclass UXViewController <UITextFieldDelegate, UXTextEditorDelegate>
@abstract
@discussion
*/
@interface UXMessageController : UXViewController <UITextFieldDelegate, UXTextEditorDelegate> {
	id <UXMessageControllerDelegate> _delegate;
	id <UXTableViewDataSource> _dataSource;
	NSArray *_fields;
	NSMutableArray *_fieldViews;
	UIScrollView *_scrollView;
	UXTextEditor *_textEditor;
	UXActivityLabel *_activityView;
	NSArray *_initialRecipients;
	BOOL _showsRecipientPicker;
	BOOL _isModified;
}

	@property (nonatomic, assign) id <UXMessageControllerDelegate> delegate;
	@property (nonatomic, retain) id <UXTableViewDataSource> dataSource;
	@property (nonatomic, retain) NSArray *fields;
	@property (nonatomic, retain) NSString *subject;
	@property (nonatomic, retain) NSString *body;
	@property (nonatomic) BOOL showsRecipientPicker;
	@property (nonatomic, readonly) BOOL isModified;

	-(id) initWithRecipients:(NSArray *)recipients;

	-(void) addRecipient:(id)recipient forFieldAtIndex:(NSUInteger)fieldIndex;

	-(NSString *) textForFieldAtIndex:(NSUInteger)fieldIndex;
	-(void) setText:(NSString *)text forFieldAtIndex:(NSUInteger)fieldIndex;

	-(BOOL) fieldHasValueAtIndex:(NSUInteger)fieldIndex;
	-(UIView *) viewForFieldAtIndex:(NSUInteger)fieldIndex;

	-(void) showActivityView:(BOOL)show;

	-(NSString *) titleForSending;

	/*!
	@abstract Tells the delegate to send the message.
	*/
	-(void) send;

	/*!
	@abstract Cancel the message, but confirm first with the user if necessary.
	*/
	-(void) cancel:(BOOL)confirmIfNecessary;

	/*!
	@abstract Confirms with the user that it is ok to cancel.
	*/
	-(void) confirmCancellation;

	-(void) messageWillSend:(NSArray *)fields;

	/*!
	@abstract The user touched the recipient picker button.
	*/
	-(void) messageWillShowRecipientPicker;
	-(void) messageDidSend;

	/*!
	@abstract Determines if the message should cancel without confirming with the user.
	*/
	-(BOOL) messageShouldCancel;

@end

#pragma mark -

/*!
@protocol UXMessageControllerDelegate <NSObject>
@abstract
*/
@protocol UXMessageControllerDelegate <NSObject>

@optional
	-(void) composeController:(UXMessageController *)controller didSendFields:(NSArray *)fields;
	-(void) composeControllerWillCancel:(UXMessageController *)controller;
	-(void) composeControllerShowRecipientPicker:(UXMessageController *)controller;

@end

#pragma mark -

@interface UXMessageField : NSObject {
	NSString *_title;
	BOOL _required;
}

	@property (nonatomic, copy) NSString *title;
	@property (nonatomic) BOOL required;

	-(id) initWithTitle:(NSString *)title required:(BOOL)required;

@end

#pragma mark -

@interface UXMessageRecipientField : UXMessageField {
	NSArray *_recipients;
}

	@property (nonatomic, retain) NSArray *recipients;

@end

@interface UXMessageTextField : UXMessageField {
	NSString *_text;
}

	@property (nonatomic, copy) NSString *text;

@end

@interface UXMessageSubjectField : UXMessageTextField
@end
