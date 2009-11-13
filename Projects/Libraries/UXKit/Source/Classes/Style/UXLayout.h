
/*!
@project	UXKit
@header		UXLayout.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXGlobal.h>

/*!
@class UXLayout
@superclass NSObject
@abstract
@discussion
*/
@interface UXLayout : NSObject {

}

	-(CGSize)layoutSubviews:(NSArray *)subviews forView:(UIView *)view;

@end

#pragma mark -

/*!
@class UXFlowLayout
@superclass UXLayout
@abstract
@discussion
*/
@interface UXFlowLayout : UXLayout {
	CGFloat _padding;
	CGFloat _spacing;
}

	@property (nonatomic) CGFloat padding;
	@property (nonatomic) CGFloat spacing;

@end

#pragma mark -

/*!
@class UXGridLayout
@superclass UXLayout
@abstract
@discussion
*/
@interface UXGridLayout : UXLayout {
	NSInteger _columnCount;
	CGFloat _padding;
	CGFloat _spacing;
}

	@property (nonatomic) NSInteger columnCount;
	@property (nonatomic) CGFloat padding;
	@property (nonatomic) CGFloat spacing;

@end
