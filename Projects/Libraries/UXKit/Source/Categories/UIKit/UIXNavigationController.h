
/*!
@project	UXKit
@header     UIXNavigationController.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

/*!
@category UINavigationController (UIXNavigationController)
@abstract
@discussion
*/
@interface UINavigationController (UIXNavigationController)

	/*!
	@abstract Pushes a view controller with a transition other than the standard sliding animation.
	*/
	-(void) pushViewController:(UIViewController *)controller animatedWithTransition:(UIViewAnimationTransition)transition;

	/*!
	@abstract Pops a view controller with a transition other than the standard sliding animation.
	*/
	-(UIViewController *) popViewControllerAnimatedWithTransition:(UIViewAnimationTransition)transition;

	#pragma mark -

	-(void) resetWithRootController:(UIViewController *)aViewController;

@end
