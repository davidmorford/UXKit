
/*!
@project	UXKit
@header		UXStyle.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXGlobal.h>

@protocol UXStyleDelegate;
@class UXShape, UXStyleContext;

/*!
@class		UXStyleContext
@superclass	NSObject
@abstract
@discussion
*/
@interface UXStyleContext : NSObject {
	id <UXStyleDelegate> _delegate;
	CGRect _frame;
	CGRect _contentFrame;
	UXShape *_shape;
	UIFont *_font;
	BOOL _didDrawContent;
}

	@property (nonatomic, assign) id <UXStyleDelegate> delegate;
	@property (nonatomic) CGRect frame;
	@property (nonatomic) CGRect contentFrame;
	@property (nonatomic, retain) UXShape *shape;
	@property (nonatomic, retain) UIFont *font;
	@property (nonatomic) BOOL didDrawContent;

@end

#pragma mark -

/*!
@class		UXStyle
@superclass NSObject
@abstract
@discussion
*/
@interface UXStyle : NSObject <NSCoding, NSCopying> {
	UXStyle *_next;
}

	@property (nonatomic, retain) UXStyle *next;

	-(id) initWithNext:(UXStyle *)aStyle;

	-(UXStyle *) next:(UXStyle *)aStyle;

	-(void) draw:(UXStyleContext *)aContext;

	-(UIEdgeInsets) addToInsets:(UIEdgeInsets)insets forSize:(CGSize)aSize;
	-(CGSize) addToSize:(CGSize)aSize context:(UXStyleContext *)aContext;

	-(void) addStyle:(UXStyle *)aStyle;

	-(id) firstStyleOfClass:(Class)aClass;
	-(id) styleForPart:(NSString *)aName;

@end

#pragma mark -

/*!
@class		UXContentStyle
@superclass UXStyle
@abstract
@discussion
*/
@interface UXContentStyle : UXStyle {

}

	+(UXContentStyle *) styleWithNext:(UXStyle *)aStyle;

@end

#pragma mark -

/*!
@class		UXPartStyle
@superclass	UXStyle
@abstract
@discussion
*/
@interface UXPartStyle : UXStyle {
	NSString *_name;
	UXStyle *_style;
}

	@property (nonatomic, copy) NSString *name;
	@property (nonatomic, retain) UXStyle *style;

	+(UXPartStyle *) styleWithName:(NSString *)aName style:(UXStyle *)aStyle next:(UXStyle *)aNextStyle;

	-(void) drawPart:(UXStyleContext *)aContext;

@end

#pragma mark -

/*!
@class		UXShapeStyle
@superclass	UXStyle
@abstract	Causes all layers going forward to use a particular shape.
@discussion
*/
@interface UXShapeStyle : UXStyle {
	UXShape *_shape;
}

	@property (nonatomic, retain) UXShape *shape;

	+(UXShapeStyle *) styleWithShape:(UXShape *)aShape next:(UXStyle *)aNextStyle;

@end

#pragma mark -

/*!
@class UXInsetStyle
@superclass UXStyle
@abstract
@discussion
*/
@interface UXInsetStyle : UXStyle {
	UIEdgeInsets _inset;
}

	@property (nonatomic) UIEdgeInsets inset;

	+(UXInsetStyle *)styleWithInset:(UIEdgeInsets)anInset next:(UXStyle *)aNextStyle;

@end

#pragma mark -

/*!
@class UXBoxStyle
@superclass UXStyle
@abstract
@discussion
*/
@interface UXBoxStyle : UXStyle {
	UIEdgeInsets _margin;
	UIEdgeInsets _padding;
	CGSize _minSize;
	UXPosition _position;
}

	@property (nonatomic) UIEdgeInsets margin;
	@property (nonatomic) UIEdgeInsets padding;
	@property (nonatomic) CGSize minSize;
	@property (nonatomic) UXPosition position;

	+(UXBoxStyle *) styleWithMargin:(UIEdgeInsets)aMargin next:(UXStyle *)aStyle;
	+(UXBoxStyle *) styleWithPadding:(UIEdgeInsets)aPadding next:(UXStyle *)aStyle;
	+(UXBoxStyle *) styleWithFloats:(UXPosition)aPosition next:(UXStyle *)aStyle;
	+(UXBoxStyle *) styleWithMargin:(UIEdgeInsets)aMargin padding:(UIEdgeInsets)aPadding next:(UXStyle *)aStyle;
	+(UXBoxStyle *) styleWithMargin:(UIEdgeInsets)aMargin padding:(UIEdgeInsets)aPadding minSize:(CGSize)aMinSize position:(UXPosition)aPosition next:(UXStyle *)aStyle;

@end

#pragma mark -

/*!
@class UXTextStyle
@superclass UXStyle
@abstract
@discussion
*/
@interface UXTextStyle : UXStyle {
	UIFont *_font;
	UIColor *_color;
	UIColor *_shadowColor;
	CGSize _shadowOffset;
	CGFloat _minimumFontSize;
	NSInteger _numberOfLines;
	UITextAlignment _textAlignment;
	UIControlContentVerticalAlignment _verticalAlignment;
	UILineBreakMode _lineBreakMode;
}

	@property (nonatomic, retain) UIFont *font;
	@property (nonatomic, retain) UIColor *color;
	@property (nonatomic, retain) UIColor *shadowColor;
	@property (nonatomic) CGFloat minimumFontSize;
	@property (nonatomic) CGSize shadowOffset;
	@property (nonatomic) NSInteger numberOfLines;
	@property (nonatomic) UITextAlignment textAlignment;
	@property (nonatomic) UIControlContentVerticalAlignment verticalAlignment;
	@property (nonatomic) UILineBreakMode lineBreakMode;

	+(UXTextStyle *) styleWithColor:(UIColor *)aColor next:(UXStyle *)aStyle;

	+(UXTextStyle *) styleWithFont:(UIFont *)aFont next:(UXStyle *)aStyle;
	+(UXTextStyle *) styleWithFont:(UIFont *)aFont color:(UIColor *)aColor next:(UXStyle *)aStyle;
	+(UXTextStyle *) styleWithFont:(UIFont *)aFont color:(UIColor *)aColor textAlignment:(UITextAlignment)aTextAlignment next:(UXStyle *)aStyle;
	+(UXTextStyle *) styleWithFont:(UIFont *)aFont color:(UIColor *)aColor shadowColor:(UIColor *)aShadowColor shadowOffset:(CGSize)aShadowOffset next:(UXStyle *)aStyle;
	+(UXTextStyle *) styleWithFont:(UIFont *)aFont color:(UIColor *)aColor minimumFontSize:(CGFloat)aMinimumFontSize shadowColor:(UIColor *)aShadowColor shadowOffset:(CGSize)aShadowOffset next:(UXStyle *)aStyle;
	+(UXTextStyle *) styleWithFont:(UIFont *)aFont color:(UIColor *)aColor minimumFontSize:(CGFloat)aMinimumFontSize shadowColor:(UIColor *)aShadowColor shadowOffset:(CGSize)aShadowOffset 
					 textAlignment:(UITextAlignment)aTextAlignment  
				 verticalAlignment:(UIControlContentVerticalAlignment)aVerticalAlignment 
					 lineBreakMode:(UILineBreakMode)aLineBreakMode 
					 numberOfLines:(NSInteger)aNumberOfLines 
							  next:(UXStyle *)aStyle;

@end

#pragma mark -

/*!
@class UXImageStyle
@superclass UXStyle
@abstract
@discussion
*/
@interface UXImageStyle : UXStyle {
	NSString *_imageURL;
	UIImage *_image;
	UIImage *_defaultImage;
	UIViewContentMode _contentMode;
	CGSize _size;
}

	@property (nonatomic, copy) NSString *imageURL;
	@property (nonatomic, retain) UIImage *image;
	@property (nonatomic, retain) UIImage *defaultImage;
	@property (nonatomic) CGSize size;
	@property (nonatomic) UIViewContentMode contentMode;

	+(UXImageStyle *) styleWithImageURL:(NSString *)anImageURL next:(UXStyle *)aStyle;
	+(UXImageStyle *) styleWithImageURL:(NSString *)anImageURL defaultImage:(UIImage *)aDefaultImage next:(UXStyle *)aStyle;
	+(UXImageStyle *) styleWithImageURL:(NSString *)anImageURL defaultImage:(UIImage *)aDefaultImage contentMode:(UIViewContentMode)aContentMode size:(CGSize)aSize next:(UXStyle *)aStyle;
	
	+(UXImageStyle *) styleWithImage:(UIImage *)anImage next:(UXStyle *)aStyle;
	+(UXImageStyle *) styleWithImage:(UIImage *)anImage defaultImage:(UIImage *)aDefaultImage next:(UXStyle *)aStyle;
	+(UXImageStyle *) styleWithImage:(UIImage *)anImage defaultImage:(UIImage *)aDefaultImage contentMode:(UIViewContentMode)aContentMode size:(CGSize)aSize next:(UXStyle *)aStyle;

@end

#pragma mark -

/*!
@class UXMaskStyle
@superclass UXStyle
@abstract
@discussion
*/
@interface UXMaskStyle : UXStyle {
	UIImage *_mask;
}

	@property (nonatomic, retain) UIImage *mask;

	+(UXMaskStyle *) styleWithMask:(UIImage *)anImageMask next:(UXStyle *)aStyle;

@end

#pragma mark -

/*!
@class      UXBlendStyle 
@superclass	UXStyle
@abstract	
@discussion	
*/
@interface UXBlendStyle : UXStyle {
	CGBlendMode _blendMode;
}

	@property (nonatomic) CGBlendMode blendMode;

	+(UXBlendStyle *) styleWithBlend:(CGBlendMode)aBlendMode next:(UXStyle *)next;

@end

#pragma mark -

/*!
@class UXSolidFillStyle
@superclass UXStyle
@abstract
@discussion
*/
@interface UXSolidFillStyle : UXStyle {
	UIColor *_color;
}

	@property (nonatomic, retain) UIColor *color;

	+(UXSolidFillStyle *) styleWithColor:(UIColor *)aColor next:(UXStyle *)aStyle;

@end

#pragma mark -

/*!
@class UXLinearGradientFillStyle
@superclass UXStyle
@abstract
@discussion
*/
@interface UXLinearGradientFillStyle : UXStyle {
	UIColor *_color1;
	UIColor *_color2;
}

	@property (nonatomic, retain) UIColor *color1;
	@property (nonatomic, retain) UIColor *color2;

	+(UXLinearGradientFillStyle *) styleWithColor1:(UIColor *)firstColor color2:(UIColor *)secondColor next:(UXStyle *)aStyle;

@end

#pragma mark -

/*!
@class UXReflectiveFillStyle
@superclass UXStyle
@abstract
@discussion
*/
@interface UXReflectiveFillStyle : UXStyle {
	UIColor *_color;
}

	@property (nonatomic, retain) UIColor *color;

	+(UXReflectiveFillStyle *) styleWithColor:(UIColor *)aColor next:(UXStyle *)aStyle;

@end

#pragma mark -

/*!
@class UXShadowStyle
@superclass UXStyle
@abstract
@discussion
*/
@interface UXShadowStyle : UXStyle {
	UIColor *_color;
	CGFloat _blur;
	CGSize _offset;
}

	@property (nonatomic, retain) UIColor *color;
	@property (nonatomic) CGFloat blur;
	@property (nonatomic) CGSize offset;

	+(UXShadowStyle *) styleWithColor:(UIColor *)aColor blur:(CGFloat)ablur offset:(CGSize)anOffset next:(UXStyle *)aStyle;

@end

#pragma mark -

/*!
@class UXInnerShadowStyle
@superclass UXShadowStyle
@abstract
@discussion
*/
@interface UXInnerShadowStyle : UXShadowStyle {

}

@end

#pragma mark -

/*!
@class UXSolidBorderStyle
@superclass UXStyle
@abstract
@discussion
*/
@interface UXSolidBorderStyle : UXStyle {
	UIColor *_color;
	CGFloat _width;
}

	@property (nonatomic, retain) UIColor *color;
	@property (nonatomic) CGFloat width;

	+(UXSolidBorderStyle *) styleWithColor:(UIColor *)aColor width:(CGFloat)aWidth next:(UXStyle *)aStyle;

@end

#pragma mark -

/*!
@class UXFourBorderStyle
@superclass UXStyle
@abstract
@discussion
*/
@interface UXFourBorderStyle : UXStyle {
	UIColor *_top;
	UIColor *_right;
	UIColor *_bottom;
	UIColor *_left;
	CGFloat _width;
}

	@property (nonatomic, retain) UIColor *top;
	@property (nonatomic, retain) UIColor *right;
	@property (nonatomic, retain) UIColor *bottom;
	@property (nonatomic, retain) UIColor *left;
	@property (nonatomic) CGFloat width;

	+(UXFourBorderStyle *) styleWithTop:(UIColor *)aTopColor right:(UIColor *)aRightColor bottom:(UIColor *)aBottomColor left:(UIColor *)aLeftColor width:(CGFloat)aWidth next:(UXStyle *)aStyle;
	+(UXFourBorderStyle *) styleWithTop:(UIColor *)aTopColor width:(CGFloat)aWidth next:(UXStyle *)aStyle;
	+(UXFourBorderStyle *) styleWithRight:(UIColor *)aRightColor width:(CGFloat)aWidth next:(UXStyle *)aStyle;
	+(UXFourBorderStyle *) styleWithBottom:(UIColor *)aBottomColor width:(CGFloat)aWidth next:(UXStyle *)aStyle;
	+(UXFourBorderStyle *) styleWithLeft:(UIColor *)aLeftColor width:(CGFloat)aWidth next:(UXStyle *)aStyle;

@end

#pragma mark -

/*!
@class UXBevelBorderStyle
@superclass UXStyle
@abstract
@discussion
*/
@interface UXBevelBorderStyle : UXStyle {
	UIColor *_highlight;
	UIColor *_shadow;
	CGFloat _width;
	NSInteger _lightSource;
}

	@property (nonatomic, retain) UIColor *highlight;
	@property (nonatomic, retain) UIColor *shadow;
	@property (nonatomic) CGFloat width;
	@property (nonatomic) NSInteger lightSource;

	+(UXBevelBorderStyle *) styleWithColor:(UIColor *)aColor width:(CGFloat)aWidth next:(UXStyle *)aStyle;
	
	+(UXBevelBorderStyle *) styleWithHighlight:(UIColor *)aHighlightColor 
										shadow:(UIColor *)aShadowColor 
										 width:(CGFloat)aWidth 
								   lightSource:(NSInteger)aLightSource  
										  next:(UXStyle *)aNextStyle;

@end

#pragma mark -

/*!
@class UXLinearGradientBorderStyle
@superclass UXStyle
@abstract
@discussion
*/
@interface UXLinearGradientBorderStyle : UXStyle {
	UIColor *_color1;
	UIColor *_color2;
	CGFloat _location1;
	CGFloat _location2;
	CGFloat _width;
}

	@property (nonatomic, retain) UIColor *color1;
	@property (nonatomic, retain) UIColor *color2;
	@property (nonatomic) CGFloat location1;
	@property (nonatomic) CGFloat location2;
	@property (nonatomic) CGFloat width;

	+(UXLinearGradientBorderStyle *) styleWithColor1:(UIColor *)firstColor color2:(UIColor *)secondColor width:(CGFloat)aWidth next:(UXStyle *)aStyle;
	+(UXLinearGradientBorderStyle *) styleWithColor1:(UIColor *)color1 location1:(CGFloat)location1 color2:(UIColor *)color2 location2:(CGFloat)location2 width:(CGFloat)width next:(UXStyle *)next;

@end

#pragma mark -

/*!
@class UXRadialGradientFillStyle
@superclass UXStyle
@abstract
@discussion
*/
@interface UXRadialGradientFillStyle : UXStyle {
	UIColor *firstColor;
	UIColor *secondColor;
}

	@property (nonatomic, retain) UIColor *firstColor;
	@property (nonatomic, retain) UIColor *secondColor;
	
	+(UXRadialGradientFillStyle *) styleWithFirstColor:(UIColor *)aFirstColor secondColor:(UIColor *)aSecondColor next:(UXStyle *)aStyle;

@end

#pragma mark -

/*!
@class UXRadialShine
@superclass UXStyle
@abstract
@discussion
*/
@interface UXRadialShine : UXStyle {
	UIColor *color;
	CGFloat ovalScaleX;
	CGFloat ovalScaleY;
}

	@property (nonatomic, retain) UIColor *color;
	@property (nonatomic, readwrite) CGFloat ovalScaleX;
	@property (nonatomic, readwrite) CGFloat ovalScaleY;

	+(UXRadialShine *) radialShineWithNext:(UXStyle *)next;
	+(UXRadialShine *) radialShineWithColor:(UIColor *)aColor next:(UXStyle *)next;
	+(UXRadialShine *) radialShineWithColor:(UIColor *)aColor ovalScaleX:(CGFloat)anOvalScaleX ovalScaleY:(CGFloat)anOvalScaleY next:(UXStyle *)next;

@end


#pragma mark -

/*!
@protocol UXStyleDelegate <NSObject>
@abstract
*/
@protocol UXStyleDelegate <NSObject>

@optional
	-(NSString *) textForLayerWithStyle:(UXStyle *)aStyle;
	-(UIImage *) imageForLayerWithStyle:(UXStyle *)aStyle;
	-(void) drawLayer:(UXStyleContext *)aContext withStyle:(UXStyle *)aStyle;

@end
