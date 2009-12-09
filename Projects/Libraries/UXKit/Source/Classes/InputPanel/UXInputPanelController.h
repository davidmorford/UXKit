
/*!
@project    UXKit
@header     UXInputPanelController.h
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXKit.h>

@class UXInputPanel;
@protocol UXInputPanelControllerDelegate;

/*!
@class UXInputPanelController
@superclass UIViewController
@abstract
@discussion
*/
@interface UXInputPanelController : UXPopupViewController {
	UXInputPanel *panelView;
	id <UXInputPanelControllerDelegate> delegate;
	UXView *contentView;
}

	@property (retain, nonatomic) UXInputPanel *panelView;
	@property (nonatomic, assign) id <UXInputPanelControllerDelegate> delegate;

	@property (retain, nonatomic) UXView *contentView;

@end

#pragma mark -

@protocol UXInputPanelControllerDelegate <NSObject>

@optional

	/*!
	@abstract The result
	*/
	-(BOOL) panelController:(UXInputPanelController *)controller shouldCompleteWithResult:(id)result;

	/*!
	@abstract The result
	*/
	-(void) panelController:(UXInputPanelController *)controller didCompleteWithResult:(id)result;

	/*!
	@abstract The controller was cancelled before completion
	*/
	-(void) panelControllerDidCancel:(UXInputPanelController *)controller;

@end
