
/*!
@project	UXKit
@header     UIXView.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UIKit/UIKit.h>

/*!
@category UIView (UIXView)
@abstract
@discussion
*/
@interface UIView (UIXView)

	@property (nonatomic) CGFloat left;
	@property (nonatomic) CGFloat top;
	@property (nonatomic) CGFloat right;
	@property (nonatomic) CGFloat bottom;

	@property (nonatomic) CGFloat width;
	@property (nonatomic) CGFloat height;

	@property (nonatomic) CGFloat centerX;
	@property (nonatomic) CGFloat centerY;

	@property (nonatomic, readonly) CGFloat screenX;
	@property (nonatomic, readonly) CGFloat screenY;
	@property (nonatomic, readonly) CGFloat screenViewX;
	@property (nonatomic, readonly) CGFloat screenViewY;
	@property (nonatomic, readonly) CGRect screenFrame;

	@property (nonatomic) CGPoint origin;
	@property (nonatomic) CGSize size;

	@property (nonatomic, readonly) CGFloat orientationWidth;
	@property (nonatomic, readonly) CGFloat orientationHeight;

	#pragma mark -

	/*!
	@abstract Finds the first descendant view (including this view) that is a member of a particular class.
	*/
	-(UIView *) descendantOrSelfWithClass:(Class)aClass;

	/*!
	@abstract Finds the first ancestor view (including this view) that is a member of a particular class.
	*/
	-(UIView *) ancestorOrSelfWithClass:(Class)aClass;

	/*!
	@abstract Removes all subviews.
	*/
	-(void) removeAllSubviews;

	/*!
	@abstract Calculates the offset of this view from another view in screen coordinates.
	*/
	-(CGPoint) offsetFromView:(UIView *)otherView;

	/*!
	@abstract Calculates the frame of this view with parts that intersect with the keyboard subtracted.
	@discussion If the keyboard is not showing, this will simply return the normal frame.
	*/
	-(CGRect) frameWithKeyboardSubtracted:(CGFloat)plusHeight;

	/*!
	@abstract Shows the view in a window at the bottom of the screen.
	@discussion This will send a notification pretending that a keyboard is about to appear so that
	observers who adjust their layout for the keyboard will also adjust for this view.
	*/
	-(void) presentAsKeyboardInView:(UIView *)aContainingView;

	/*!
	@abstract Hides a view that was showing in a window at the bottom of the screen (via presentAsKeyboard).
	@discussion This will send a notification pretending that a keyboard is about to disappear so that
	observers who adjust their layout for the keyboard will also adjust for this view.
	*/
	-(void) dismissAsKeyboard:(BOOL)animated;

	/*!
	@abstract The view controller whose view contains this view.
	*/
	-(UIViewController *) viewController;

@end

#pragma mark -

/*!
@category UIView (UIXViewDrawing)
@abstract
@discussion
*/
@interface UIView (UIXViewDrawing)

	+(void) drawLinearGradientInRect:(CGRect)rect colors:(CGFloat[])colors;
	+(void) drawLineInRect:(CGRect)rect colors:(CGFloat[])colors;

@end
