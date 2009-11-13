
/*!
@project    UXCatalog
@header     PanelTestController.h
@copyright  (c) 2009 Semantap
*/

#import <UXKit/UXKit.h>

@class UXPanelViewController;

/*!
@class PanelTestController
@superclass UIViewController
@abstract
@discussion
*/
@interface PanelTestController : UXViewController {
	UXPanelViewController *controller;
}

	-(void) togglePanel;

@end
