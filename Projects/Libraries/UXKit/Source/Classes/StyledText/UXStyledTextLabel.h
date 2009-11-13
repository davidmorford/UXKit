
/*!
@project	UXKit
@header		UXStyledTextLabel.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXStyledText.h>

@class UXStyledElement, UXStyledBoxFrame, UXStyle;

/*!
@class UXStyledTextLabel
@superclass UIView <UXStyledTextDelegate>
@abstract A view that can display styled text.
@discussion
*/
@interface UXStyledTextLabel : UIView <UXStyledTextDelegate> {
	UXStyledText *_text;
	UIFont *_font;
	UIColor *_textColor;
	UIColor *_highlightedTextColor;
	UITextAlignment _textAlignment;
	UIEdgeInsets _contentInset;
	BOOL _highlighted;
	UXStyledElement *_highlightedNode;
	UXStyledBoxFrame *_highlightedFrame;
	NSMutableArray* _accessibilityElements;
}

	/*!
	@abstract The styled text displayed by the label.
	*/
	@property (nonatomic, retain) UXStyledText *text;

	/*!
	@abstract A shortcut for setting the text property to an HTML string.
	*/
	@property (nonatomic, copy) NSString *html;

	/*!
	@abstract The font of the text.
	*/
	@property (nonatomic, retain) UIFont *font;

	/*!
	@abstract The color of the text.
	*/
	@property (nonatomic, retain) UIColor *textColor;

	/*!
	@abstract The highlight color applied to the text.
	*/
	@property (nonatomic, retain) UIColor *highlightedTextColor;

	/*!
	@abstract The alignment of the text. (NOT YET IMPLEMENTED)
	*/
	@property (nonatomic) UITextAlignment textAlignment;

	/*!
	@abstract The inset of the edges around the text.
	@discussion This will increase the size of the label when sizeToFit is called.
	*/
	@property (nonatomic) UIEdgeInsets contentInset;

	/*!
	@abstract A Boolean value indicating whether the receiver should be drawn with a highlight.
	*/
	@property (nonatomic) BOOL highlighted;

	/*!
	@abstract The link node which is being touched and highlighted by the user.
	*/
	@property (nonatomic, retain) UXStyledElement *highlightedNode;

@end

