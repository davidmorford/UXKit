
/*!
@project	UXKit
@header     UXStyledNode.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXGlobal.h>

/*!
@class UXStyledNode 
@superclass NSObject
@abstract
@discussion
*/
@interface UXStyledNode : NSObject {
	UXStyledNode *_nextSibling;
	UXStyledNode *_parentNode;
}

	@property (nonatomic, retain) UXStyledNode *nextSibling;
	@property (nonatomic, assign) UXStyledNode *parentNode;
	@property (nonatomic, readonly) NSString *outerText;
	@property (nonatomic, readonly) NSString *outerHTML;

	-(id) initWithNextSibling:(UXStyledNode *)aNextSibling;

	-(id) ancestorOrSelfWithClass:(Class)aClass;

	-(void) performDefaultAction;

@end

#pragma mark -

/*!
@class UXStyledTextNode
@superclass UXStyledNode
@abstract
@discussion
*/
@interface UXStyledTextNode : UXStyledNode {
	NSString *_text;
}

	@property (nonatomic, retain) NSString *text;

	-(id) initWithText:(NSString *)aText;
	-(id) initWithText:(NSString *)aText next:(UXStyledNode *)aNextSibling;

@end

#pragma mark -

/*!
@class UXStyledElement
@superclass UXStyledNode
@abstract
@discussion
*/
@interface UXStyledElement : UXStyledNode {
	UXStyledNode *_firstChild;
	UXStyledNode *_lastChild;
	NSString *_className;
}

	@property (nonatomic, readonly) UXStyledNode *firstChild;
	@property (nonatomic, readonly) UXStyledNode *lastChild;
	@property (nonatomic, retain) NSString *className;

	-(id) initWithText:(NSString *)aText;
	-(id) initWithText:(NSString *)aText next:(UXStyledNode *)aNextSibling;

	-(void) addChild:(UXStyledNode *)child;
	-(void) addText:(NSString *)aText;
	-(void) replaceChild:(UXStyledNode *)oldChild withChild:(UXStyledNode *)newChild;

	-(UXStyledNode *) getElementByClassName:(NSString *)aClassName;

@end

#pragma mark -

@interface UXStyledBlock : UXStyledElement
@end

#pragma mark -

@interface UXStyledInline : UXStyledElement
@end

#pragma mark -

@interface UXStyledInlineBlock : UXStyledElement
@end

#pragma mark -

@interface UXStyledBoldNode : UXStyledInline
@end

#pragma mark -

@interface UXStyledItalicNode : UXStyledInline
@end

#pragma mark -

@interface UXStyledLinkNode : UXStyledInline {
	NSString *_URL;
	BOOL _highlighted;
}

	@property (nonatomic) BOOL highlighted;
	@property (nonatomic, retain) NSString *URL;

	-(id) initWithURL:(NSString *)aURL;
	-(id) initWithURL:(NSString *)aURL next:(UXStyledNode *)nextSibling;
	-(id) initWithText:(NSString *)aText URL:(NSString *)aURL next:(UXStyledNode *)nextSibling;

@end

#pragma mark -

@interface UXStyledButtonNode : UXStyledInlineBlock {
	NSString *_URL;
	BOOL _highlighted;
}

	@property (nonatomic) BOOL highlighted;
	@property (nonatomic, retain) NSString *URL;

	-(id) initWithURL:(NSString *)aURL;
	-(id) initWithURL:(NSString *)aURL next:(UXStyledNode *)aNextSibling;
	-(id) initWithText:(NSString *)aText URL:(NSString *)aURL next:(UXStyledNode *)aNextSibling;

@end

#pragma mark -

@interface UXStyledImageNode : UXStyledElement {
	NSString *_URL;
	UIImage *_image;
	UIImage *_defaultImage;
	CGFloat _width;
	CGFloat _height;
}

	@property (nonatomic, retain) NSString *URL;
	@property (nonatomic, retain) UIImage *image;
	@property (nonatomic, retain) UIImage *defaultImage;
	@property (nonatomic) CGFloat width;
	@property (nonatomic) CGFloat height;

	-(id) initWithURL:(NSString *)aURL;

@end

#pragma mark -

@interface UXStyledLineBreakNode : UXStyledBlock
@end
