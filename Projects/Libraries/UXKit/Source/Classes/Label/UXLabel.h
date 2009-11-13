
/*!
@project	UXKit
@header		UXLabel.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXView.h>

/*!
@class UXLabel
@superclass UXView
@abstract
@discussion
*/
@interface UXLabel : UXView {
	NSString *_text;
	UIFont *_font;
}

	@property (nonatomic, copy) NSString *text;
	@property (nonatomic, retain) UIFont *font;

	-(id) initWithText:(NSString *)aTextString;

@end
