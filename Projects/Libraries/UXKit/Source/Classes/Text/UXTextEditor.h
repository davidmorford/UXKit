
/*!
@project	UXKit
@header		UXTextEditor.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXView.h>

@protocol UXTextEditorDelegate;
@class UXTextView, UXTextEditorInternal;

/*!
@class UXTextEditor
@superclass UXView <UITextInputTraits>
@abstract
@discussion
*/
@interface UXTextEditor : UXView <UITextInputTraits> {
	id <UXTextEditorDelegate> _delegate;
	UXTextEditorInternal *_internal;
	UITextField *_textField;
	UXTextView *_textView;
	NSInteger _minNumberOfLines;
	NSInteger _maxNumberOfLines;
	BOOL _editing;
	BOOL _overflowed;
	BOOL _autoresizesToText;
	BOOL _showsExtraLine;
}

	@property (nonatomic, assign) id <UXTextEditorDelegate> delegate;
	@property (nonatomic, copy) NSString *text;
	@property (nonatomic, copy) NSString *placeholder;
	@property (nonatomic, retain) UIFont *font;
	@property (nonatomic, retain) UIColor *textColor;
	@property (nonatomic) NSInteger minNumberOfLines;
	@property (nonatomic) NSInteger maxNumberOfLines;
	@property (nonatomic, readonly) BOOL editing;
	@property (nonatomic) BOOL autoresizesToText;
	@property (nonatomic) BOOL showsExtraLine;

	-(void) scrollContainerToCursor:(UIScrollView *)scrollView;

@end

#pragma mark -

/*!
@protocol UXTextEditorDelegate <NSObject>
@abstract
*/
@protocol UXTextEditorDelegate <NSObject>

@optional
	-(BOOL) textEditorShouldBeginEditing:(UXTextEditor *)textEditor;
	-(BOOL) textEditorShouldEndEditing:(UXTextEditor *)textEditor;

	-(void) textEditorDidBeginEditing:(UXTextEditor *)textEditor;
	-(void) textEditorDidEndEditing:(UXTextEditor *)textEditor;

	-(BOOL) textEditor:(UXTextEditor *)textEditor shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)replacementText;
	-(void) textEditorDidChange:(UXTextEditor *)textEditor;

	-(BOOL) textEditor:(UXTextEditor *)aTextEditor shouldResizeBy:(CGFloat)aHeight;
	-(BOOL) textEditorShouldReturn:(UXTextEditor *)aTextEditor;

@end

#pragma mark -

/*!
@class UXTextView
@superclass UITextView
@abstract
@discussion
*/
@interface UXTextView : UITextView {
	BOOL _autoresizesToText;
	BOOL _overflowed;
}

	@property (nonatomic) BOOL autoresizesToText;
	@property (nonatomic) BOOL overflowed;

@end
