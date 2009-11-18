
/*!
@project	UXKit
@header     UXView.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXStyle.h>

@class UXStyle, UXLayout;

/*!
@class UXView
@superclass UIView <UXStyleDelegate>
@abstract A decorational view that can styled using a UXStyle object.
@discussion
*/
@interface UXView : UIView <UXStyleDelegate> {
	UXStyle *_style;
	UXLayout *_layout;
}

	@property (nonatomic, retain) UXStyle *style;
	@property (nonatomic, retain) UXLayout *layout;

	-(void) drawContent:(CGRect)rect;

@end

#pragma mark -

/*!
@class UXKVOView
@superclass UXView
@abstract
@discussion
*/
@interface UXKVOView : UXView {
	BOOL observingForDisplay;
	BOOL observingForLayout;
}

	@property (nonatomic, readonly) BOOL isObservingForDisplay;
	@property (nonatomic, readonly) BOOL isObservingForLayout;

	-(NSArray *) keysAffectingDisplay;
	-(NSArray *) keysAffectingLayout;

@end
