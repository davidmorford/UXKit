
/*!
@project	UXKit
@header		UXButton.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXStyle.h>

/*!
@class UXButton
@superclass UIControl <UXStyleDelegate>
@abstract
@discussion
*/
@interface UXButton : UIControl <UXStyleDelegate> {
	NSMutableDictionary *_content;
	UIFont *_font;
	BOOL _isVertical;
}

	@property (nonatomic, retain) UIFont *font;
	@property (nonatomic) BOOL isVertical;

	#pragma mark Constructor

	+(UXButton *) buttonWithStyle:(NSString *)aSelector;
	+(UXButton *) buttonWithStyle:(NSString *)aSelector title:(NSString *)aTitle;

	-(NSString *) titleForState:(UIControlState)State;
	-(void) setTitle:(NSString *)aTitle forState:(UIControlState)aState;

	-(NSString *) imageForState:(UIControlState)aState;
	-(void) setImage:(NSString *)aTitle forState:(UIControlState)aState;

	-(UXStyle *) styleForState:(UIControlState)aState;
	-(void) setStyle:(UXStyle *)aStyle forState:(UIControlState)aState;

	/*!
	@abstract Sets the styles for all control states using a single style selector.
	The method for the selector must accept a single argument for the control state.  It will
	be called to return a style for each of the different control states.
	*/
	-(void) setStylesWithSelector:(NSString *)selectorString;

	-(void) suspendLoadingImages:(BOOL)suspended;
	
	-(CGRect) rectForImage;

@end
