
/*!
@project	UXKit
@header		UXStyledFrame.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXStyle.h>

@class UXStyledElement, UXStyledTextNode, UXStyledImageNode, UXStyledBoxFrame;

/*!
@class UXStyledFrame
@superclass NSObject
@abstract
@discussion
*/
@interface UXStyledFrame : NSObject {
	UXStyledElement *_element;
	UXStyledFrame *_nextFrame;
	CGRect _bounds;
}

	/*!
	@abstract The element that contains the frame.
	*/
	@property (nonatomic, readonly) UXStyledElement *element;

	/*!
	@abstract The next in the linked list of frames.
	*/
	@property (nonatomic, retain) UXStyledFrame *nextFrame;

	/*!
	@abstract The bounds of the content that is displayed by this frame.
	*/
	@property (nonatomic) CGRect bounds;

	@property (nonatomic) CGFloat x;
	@property (nonatomic) CGFloat y;
	@property (nonatomic) CGFloat width;
	@property (nonatomic) CGFloat height;

	-(UIFont *) font;

	-(id) initWithElement:(UXStyledElement *)element;

	/*!
	@abstract Draws the frame.
	*/
	-(void) drawInRect:(CGRect)rect;

	-(UXStyledBoxFrame *)hitTest:(CGPoint)point;

@end

#pragma mark -

/*!
@class UXStyledBoxFrame 
@superclass UXStyledFrame <UXStyleDelegate>
@abstract 
@discussion 
*/
@interface UXStyledBoxFrame : UXStyledFrame <UXStyleDelegate> {
	UXStyledBoxFrame *_parentFrame;
	UXStyledFrame *_firstChildFrame;
	UXStyle *_style;
}

	@property (nonatomic, assign) UXStyledBoxFrame *parentFrame;
	@property (nonatomic, retain) UXStyledFrame *firstChildFrame;

	/*!
	@abstract The style used to render the frame;
	*/
	@property (nonatomic, retain) UXStyle *style;

@end

#pragma mark -

/*!
@class UXStyledInlineFrame 
@superclass UXStyledBoxFrame
@abstract
@discussion
*/
@interface UXStyledInlineFrame : UXStyledBoxFrame {
	UXStyledInlineFrame *_inlinePreviousFrame;
	UXStyledInlineFrame *_inlineNextFrame;
}

	@property (nonatomic, readonly) UXStyledInlineFrame *inlineParentFrame;
	@property (nonatomic, assign) UXStyledInlineFrame *inlinePreviousFrame;
	@property (nonatomic, assign) UXStyledInlineFrame *inlineNextFrame;

@end

#pragma mark -

/*!
@class UXStyledTextFrame 
@superclass UXStyledFrame
@abstract 
@discussion
*/
@interface UXStyledTextFrame : UXStyledFrame {
	UXStyledTextNode *_node;
	NSString *_text;
	UIFont *_font;
}

	/*!
	@abstract The node represented by the frame.
	*/
	@property (nonatomic, readonly) UXStyledTextNode *node;

	/*!
	@abstract The text that is displayed by this frame.
	*/
	@property (nonatomic, readonly) NSString *text;

	/*!
	@abstract The font that is used to measure and display the text of this frame.
	*/
	@property (nonatomic, retain) UIFont *font;

	-(id) initWithText:(NSString *)text element:(UXStyledElement *)element node:(UXStyledTextNode *)node;

@end

#pragma mark -

/*!
@class UXStyledImageFrame
@superclass UXStyledFrame <UXStyleDelegate>
@abstract 
@discussion 
*/
@interface UXStyledImageFrame : UXStyledFrame <UXStyleDelegate> {
	UXStyledImageNode *_imageNode;
	UXStyle *_style;
}

	/*!
	@abstract The node represented by the frame.
	*/
	@property (nonatomic, readonly) UXStyledImageNode *imageNode;

	/*!
	@abstract The style used to render the frame;
	*/
	@property (nonatomic, retain) UXStyle *style;

	-(id) initWithElement:(UXStyledElement *)element node:(UXStyledImageNode *)node;

@end
