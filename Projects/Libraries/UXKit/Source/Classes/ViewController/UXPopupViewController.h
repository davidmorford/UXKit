
/*!
@project	UXKit
@header     UXPopupViewController.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXModelViewController.h>

/*!
@class UXPopupViewController
@superclass UXViewController
@abstract A view controller which, when displayed modally, inserts its view over the parent controller.
The best way to use this class is to bind. This class is meant to be subclassed, not used directly.
@discussion￼ Normally, displaying a modal view controller will completely hide the underlying view
controller, and even remove its view from the view hierarchy.  Popup view controllers allow
you to present a "modal" view which overlaps the parent view controller but does not
necessarily hide it.
*/
@interface UXPopupViewController : UXModelViewController {

}

	-(void) showInView:(UIView *)aView animated:(BOOL)animated;
	-(void) dismissPopupViewControllerAnimated:(BOOL)animated;

@end
