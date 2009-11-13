
/*!
@project	UXKit
@header     UIXColor.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UIKit/UIKit.h>
#import <UXKit/UIXColor.h>

/*!
@category UIColor (UIXColor)
@abstract
@discussion
*/
@interface UIColor (UIXColor)

	#pragma mark Constructors

	/*!
	@abstract 
	*/
	+(UIColor *) colorWithHue:(CGFloat)h saturation:(CGFloat)s value:(CGFloat)v alpha:(CGFloat)a;

	
	#pragma mark HSV

	-(CGFloat) hue;
	-(CGFloat) saturation;
	-(CGFloat) value;

	/*!
	@abstract
	*/
	-(UIColor *) multiplyHue:(CGFloat)hd saturation:(CGFloat)sd value:(CGFloat)vd;

	/*!
	@abstract 
	*/
	-(UIColor *) addHue:(CGFloat)hd saturation:(CGFloat)sd value:(CGFloat)vd;


	#pragma mark Copying

	/*!
	@abstract 
	@param newAlpha ￼
	*/
	-(UIColor *) copyWithAlpha:(CGFloat)newAlpha;


	#pragma mark Color Saturations

	/*!
	@abstract Uses multiplyHue to create a lighter version of the color.
	*/
	-(UIColor *) highlight;

	/*!
	@abstract Uses multiplyHue to create a darker version of the color.
	*/
	-(UIColor *) shadow;

@end
