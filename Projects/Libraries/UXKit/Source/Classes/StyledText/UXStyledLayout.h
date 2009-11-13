
/*!
@project	UXKit
@header		UXStyledLayout.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXGlobal.h>

@class UXStyle, UXStyledNode, UXStyledElement, UXStyledFrame, UXStyledBoxFrame, UXStyledInlineFrame;

/*!
@class UXStyledLayout 
@superclass NSObject
@abstract
@discussion 
*/
@interface UXStyledLayout : NSObject {
	CGFloat _x;
	CGFloat _width;
	CGFloat _height;
	CGFloat _lineWidth;
	CGFloat _lineHeight;
	CGFloat _minX;
	CGFloat _floatLeftWidth;
	CGFloat _floatRightWidth;
	CGFloat _floatHeight;
	UXStyledFrame *_rootFrame;
	UXStyledFrame *_lineFirstFrame;
	UXStyledInlineFrame *_inlineFrame;
	UXStyledBoxFrame *_topFrame;
	UXStyledFrame *_lastFrame;
	UIFont *_font;
	UIFont *_boldFont;
	UIFont *_italicFont;
	UXStyle *_linkStyle;
	UXStyledNode *_rootNode;
	UXStyledNode *_lastNode;
	NSMutableArray *_invalidImages;
}

	@property (nonatomic) CGFloat width;
	@property (nonatomic) CGFloat height;
	@property (nonatomic, retain) UIFont *font;
	@property (nonatomic, readonly) UXStyledFrame *rootFrame;
	@property (nonatomic, retain) NSMutableArray *invalidImages;

	-(id) initWithRootNode:(UXStyledNode *)aRootNode;
	-(id) initWithX:(CGFloat)x width:(CGFloat)aWidth height:(CGFloat)aHeight;

	-(void) layout:(UXStyledNode *)aNode;
	-(void) layout:(UXStyledNode *)aNode container:(UXStyledElement *)anElement;

@end
