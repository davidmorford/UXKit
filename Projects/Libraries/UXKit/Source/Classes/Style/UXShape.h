
/*!
@project	UXKit
@header		UXShape.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXGlobal.h>

/*!
@class UXShape
@superclass NSObject <NSCoding, NSCopying>
@abstract
@discussion
*/
@interface UXShape : NSObject <NSCoding, NSCopying> {

}

	-(void) openPath:(CGRect)rect;
	-(void) closePath:(CGRect)rect;

	-(void) addTopEdgeToPath:(CGRect)rect lightSource:(NSInteger)lightSource;
	-(void) addBottomEdgeToPath:(CGRect)rect lightSource:(NSInteger)lightSource;
	-(void) addRightEdgeToPath:(CGRect)rect lightSource:(NSInteger)lightSource;
	-(void) addLeftEdgeToPath:(CGRect)rect lightSource:(NSInteger)lightSource;

	/*!
	@abstract Opens the path, adds all edges, and closes the path.
	*/
	-(void) addToPath:(CGRect)rect;

	-(void) addInverseToPath:(CGRect)rect;

	-(UIEdgeInsets) insetsForSize:(CGSize)size;

@end

#pragma mark -

/*!
@class UXRectangleShape
@superclass UXShape
@abstract
@discussion
*/
@interface UXRectangleShape : UXShape {

}

	+(UXRectangleShape *) shape;

@end

#pragma mark -

/*!
@class UXRoundedRectangleShape
@superclass UXShape
@abstract
@discussion
*/
@interface UXRoundedRectangleShape : UXShape {
	CGFloat _topLeftRadius;
	CGFloat _topRightRadius;
	CGFloat _bottomRightRadius;
	CGFloat _bottomLeftRadius;
}

	@property (nonatomic) CGFloat topLeftRadius;
	@property (nonatomic) CGFloat topRightRadius;
	@property (nonatomic) CGFloat bottomRightRadius;
	@property (nonatomic) CGFloat bottomLeftRadius;

	+(UXRoundedRectangleShape *) shapeWithRadius:(CGFloat)aRadius;
	+(UXRoundedRectangleShape *) shapeWithTopLeft:(CGFloat)topLeft 
										 topRight:(CGFloat)topRight 
									  bottomRight:(CGFloat)bottomRight 
									   bottomLeft:(CGFloat)bottomLeft;

@end

#pragma mark -

/*!
@class UXRoundedRightArrowShape
@superclass UXShape
@abstract
@discussion
*/
@interface UXRoundedRightArrowShape : UXShape {
	CGFloat _radius;
}

	@property (nonatomic) CGFloat radius;

	+(UXRoundedRightArrowShape *) shapeWithRadius:(CGFloat)aRadius;

@end

#pragma mark -

/*!
@class UXRoundedLeftArrowShape
@superclass  UXShape
@abstract
@discussion
*/
@interface UXRoundedLeftArrowShape : UXShape {
	CGFloat _radius;
}

	@property (nonatomic) CGFloat radius;

	+(UXRoundedLeftArrowShape *) shapeWithRadius:(CGFloat)aRadius;

@end

#pragma mark -

/*!
@class UXSpeechBubbleShape
@superclass  UXShape
@abstract
@discussion
*/
@interface UXSpeechBubbleShape : UXShape {
	CGFloat _radius;
	CGFloat _pointLocation;
	CGFloat _pointAngle;
	CGSize _pointSize;
}

	@property (nonatomic) CGFloat radius;
	@property (nonatomic) CGFloat pointLocation;
	@property (nonatomic) CGFloat pointAngle;
	@property (nonatomic) CGSize pointSize;

	+(UXSpeechBubbleShape *) shapeWithRadius:(CGFloat)aRadius 
							   pointLocation:(CGFloat)aLocation 
								  pointAngle:(CGFloat)anAngle 
								   pointSize:(CGSize)aSize;

@end
