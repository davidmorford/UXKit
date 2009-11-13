
/*!
@project	UXKit
@header		UXStyledTextParser.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXGlobal.h>

@class UXStyledNode, UXStyledElement;

/*!
@class UXStyledTextParser 
@superclass NSObject
@abstract
@discussion
*/
@interface UXStyledTextParser : NSObject {
	UXStyledNode *_rootNode;
	UXStyledElement *_topElement;
	UXStyledNode *_lastNode;
	NSError *_parserError;
	NSMutableString *_chars;
	NSMutableArray *_stack;
	BOOL _parseLineBreaks;
	BOOL _parseURLs;
}

	@property (nonatomic, retain) UXStyledNode *rootNode;
	@property (nonatomic) BOOL parseLineBreaks;
	@property (nonatomic) BOOL parseURLs;

	-(void) parseXHTML:(NSString *)html;
	-(void) parseText:(NSString *)string;

@end
