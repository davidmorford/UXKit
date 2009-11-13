
/*!
@project    UXKit
@header     UXNavigationController.h
@changes	(c) 2009 Semantap*/

#import <UXKit/UXViewController.h>
#import <UXKit/UXNavigator.h>
#import <UXKit/UXAlertViewController.h>
#import <UXKit/UXActionSheetController.h>

@class UXView, UXActivityLabel;

extern CGFloat const UXNavigationShowTransitionDuration;
extern CGFloat const UXNavigationHideTransitionDuration;

/*!
@class UXNavigationController
@superclass UIViewController
@abstract
@discussion
*/
@interface UXNavigationController : UXViewController <UINavigationControllerDelegate, UXNavigatorDelegate, UXAlertViewControllerDelegate, UXActionSheetControllerDelegate> {
	UINavigationController *contentNavigationController;
	UIView *contentOverlayView;
	UXView *containerView;
	UXActivityLabel *activityLabel;
}

	@property (nonatomic, retain) UINavigationController *contentNavigationController;
	@property (nonatomic, retain) UXActivityLabel *activityLabel;

@end