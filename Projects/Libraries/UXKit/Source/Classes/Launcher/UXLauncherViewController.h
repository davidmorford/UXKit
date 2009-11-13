
/*!
@project    UXKit
@header     UXLauncherViewController.h
@copyright  (c) 2009 Rodrigo Mazzilli
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXViewController.h>
#import <UXKit/UXLauncherView.h>

/*!
@class UXLauncherViewController
@superclass UXViewController
@abstract
@discussion
*/
@interface UXLauncherViewController : UXViewController <UINavigationControllerDelegate> {
	UINavigationController *_launcherNavigationController;
	UIView *_overlayView;
	UXLauncherView *_launcherView;
}

	@property (nonatomic, retain) UINavigationController *launcherNavigationController;
	@property (nonatomic, readonly) UXLauncherView *launcherView;

@end
