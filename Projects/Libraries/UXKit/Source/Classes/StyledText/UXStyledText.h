
/*!
@project	UXKit
@header		UXStyledText.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXURLRequest.h>

@protocol UXStyledTextDelegate;
@class UXStyledNode, UXStyledFrame, UXStyledBoxFrame;

/*!
@class UXStyledText
@superclass NSObject <UXURLRequestDelegate>
@abstract
@discussion
*/
@interface UXStyledText : NSObject <UXURLRequestDelegate> {
	id <UXStyledTextDelegate> _delegate;
	UXStyledNode *_rootNode;
	UXStyledFrame *_rootFrame;
	UIFont *_font;
	CGFloat _width;
	CGFloat _height;
	NSMutableArray *_invalidImages;
	NSMutableArray *_imageRequests;
}

	@property (nonatomic, assign) id <UXStyledTextDelegate> delegate;

	/*!
	@abstract The first in the sequence of nodes that contain the styled text.
	*/
	@property (nonatomic, retain) UXStyledNode *rootNode;

	/*!
	@abstract The first in the sequence of frames of text calculated by the layout.
	*/
	@property (nonatomic, readonly) UXStyledFrame *rootFrame;

	/*!
	@abstract The font that will be used to measure and draw all text.
	*/
	@property (nonatomic, retain) UIFont *font;

	/*!
	@abstract The width that the text should be constrained to fit within.
	*/
	@property (nonatomic) CGFloat width;

	/*!
	@abstract The height of the text.
	@discussion The height is automatically calculated based on the width 
	and the size of word-wrapped text.
	*/
	@property (nonatomic, readonly) CGFloat height;

	/*!
	@abstract Indicates if the text needs layout to recalculate its size.
	*/
	@property (nonatomic, readonly) BOOL needsLayout;

	/*!
	@abstract Images that require loading
	*/
	@property (nonatomic, readonly) NSMutableArray *invalidImages;
	
	#pragma mark -

	/*!
	@abstract Constructs styled text with XHTML tags turned into style nodes.
	@discussion Only the following XHTML tags are supported: <b>, <i>, <img>, <a>.  
	The source must be a well-formed XHTML fragment.  You do not need to enclose the 
	source in an tag -- it can be any string with XHTML tags throughout.
	*/
	+(UXStyledText *) textFromXHTML:(NSString *)source;
	+(UXStyledText *) textFromXHTML:(NSString *)source lineBreaks:(BOOL)lineBreaks URLs:(BOOL)URLs;

	/*!
	@abstract Constructs styled text with all URLs transformed into links.
	*
	* Only URLs are parsed, not HTML markup. URLs are turned into links.
	*/
	+(UXStyledText *) textWithURLs:(NSString *)source;
	+(UXStyledText *) textWithURLs:(NSString *)source lineBreaks:(BOOL)lineBreaks;

	-(id) initWithNode:(UXStyledNode *)rootNode;

	/*!
	@abstract
	*/
	-(void) layoutFrames;

	/*!
	@abstract
	*/
	-(void) layoutIfNeeded;

	/*!
	@abstract Called to indicate that the layout needs to be re-calculated.
	*/
	-(void) setNeedsLayout;

	/*!
	@abstract Draws the text at a point.
	*/
	-(void) drawAtPoint:(CGPoint)point;

	/*!
	@abstract Draws the text at a point with optional highlighting.
	@discussion If highlighted is YES, text colors will be ignored and all text will be drawn in the same color.
	*/
	-(void) drawAtPoint:(CGPoint)point highlighted:(BOOL)highlighted;

	/*!
	@abstract Determines which frame is intersected by a point.
	*/
	-(UXStyledBoxFrame *) hitTest:(CGPoint)point;

	/*!
	@abstract Finds the frame that represents the node.
	@discussion If multiple frames represent a node, such as an inline frame with line breaks, the
	first frame in the sequence will be returned.
	*/
	-(UXStyledFrame *) getFrameForNode:(UXStyledNode *)node;

	-(void) addChild:(UXStyledNode *)child;

	-(void) addText:(NSString *)text;

	-(void) insertChild:(UXStyledNode *)child atIndex:(NSInteger)index;

	-(UXStyledNode *) getElementByClassName:(NSString *)className;

@end

#pragma mark -

/*!
@protocol UXStyledTextDelegate <NSObject>
@abstract
@discussion
*/
@protocol UXStyledTextDelegate <NSObject>

@optional
	-(void) styledTextNeedsDisplay:(UXStyledText *)text;

@end
