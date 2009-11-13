
/*!
@project	UXKit
@header     UIXImage.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXGlobal.h>

/*!
@category UIImage (UXTransform)
@abstract
*/
@interface UIImage (UXTransform)

	-(CGRect) convertRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode;

	/*!
	@abstract Resizes and/or rotates an image.
	*/
	-(UIImage *) transformWidth:(CGFloat)width height:(CGFloat)height rotate:(BOOL)rotate;

	-(UIImage *) rescaleImageToSize:(CGSize)size;
	-(UIImage *) cropImageToRect:(CGRect)cropRect;
	-(UIImage *) cropCenterAndScaleImageToSize:(CGSize)cropSize;

	-(CGSize) calculateNewSizeForCroppingBox:(CGSize)croppingBox;

@end

#pragma mark -

/*!
@category UIImage (UXDrawing)
@abstract
*/
@interface UIImage (UXDrawing)

	/*!
	@abstract Draws the image using content mode rules.
	*/
	-(void) drawInRect:(CGRect)rect contentMode:(UIViewContentMode)contentMode;

	/*!
	@abstract Draws the image as a rounded rectangle.
	*/
	-(void) drawInRect:(CGRect)rect radius:(CGFloat)radius;
	-(void) drawInRect:(CGRect)rect radius:(CGFloat)radius contentMode:(UIViewContentMode)contentMode;

	-(void) drawInRect:(CGRect)rect asAlphaMaskForColor:(CGFloat[])color;
	-(void) drawInRect:(CGRect)rect asAlphaMaskForGradient:(CGFloat[])colors;

@end

#pragma mark -

/*!
@category UIImage (UXReflection)
@abstract
*/
@interface UIImage (UXReflection)

	-(UIImage *) addImageReflection:(CGFloat)reflectionFraction;

@end
