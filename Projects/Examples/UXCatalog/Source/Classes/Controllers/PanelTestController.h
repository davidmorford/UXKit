
/*!
@project    UXCatalog
@header     PanelTestController.h
@copyright  (c) 2009 Semantap
*/

#import <UXKit/UXKit.h>

@class UXInputPanelController;

/*!
@class PanelTestController
@superclass UIViewController
@abstract
@discussion
*/
@interface PanelTestController : UXViewController <UXInputPanelControllerDelegate> {
	UXInputPanelController *controller;
}

	-(void) togglePanel;

@end
