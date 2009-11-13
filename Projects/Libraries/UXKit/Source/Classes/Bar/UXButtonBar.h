
/*!
@project	UXKit
@header		UXButtonBar.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXView.h>

/*!
@class UXButtonBar
@superclass UXView
@abstract A box containing buttons with a consistent style.
@discussion
*/
@interface UXButtonBar : UXView {
	NSMutableArray *_buttons;
	NSString *_buttonStyle;
}

	@property (nonatomic, retain) NSArray *buttons;
	@property (nonatomic, copy) NSString *buttonStyle;

	-(void) addButton:(NSString *)aTitle target:(id)aTarget action:(SEL)aSelector;
	-(void) removeButtons;

@end
