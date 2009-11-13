
/*!
@project	UXKit
@header		UXSearchlightLabel.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXGlobal.h>

/*!
@class UXSearchlightLabel
@superclass UIView
@abstract
@discussion
*/
@interface UXSearchlightLabel : UIView {
	NSString *_text;
	UIFont *_font;
	UIColor *textColor;
	UIColor *_spotlightColor;
	UITextAlignment _textAlignment;
	NSTimer *_timer;
	CGFloat _spotlightPoint;
	CGContextRef _maskContext;
	void *_maskData;
}

	@property (nonatomic, copy) NSString *text;
	@property (nonatomic, retain) UIFont *font;
	@property (nonatomic, retain) UIColor *textColor;
	@property (nonatomic, retain) UIColor *spotlightColor;
	@property (nonatomic) UITextAlignment textAlignment;

	-(void) startAnimating;
	-(void) stopAnimating;

@end
