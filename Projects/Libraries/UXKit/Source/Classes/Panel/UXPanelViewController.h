
/*!
@project    UXKit
@header     UXPanelViewController.h
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXKit.h>

@class UXPanelView;
//@protocol UXPanelViewControllerDelegate;

/*!
@class UXPanelViewController
@superclass UIViewController
@abstract
@discussion
*/
@interface UXPanelViewController : UXPopupViewController {
	UXPanelView *panelView;
	/*id <UXPanelViewControllerDelegate> delegate;*/
	UXView *contentView;
}

	@property (retain, nonatomic) UXPanelView *panelView;
	/*@property (nonatomic, assign) id <UXPanelViewControllerDelegate> delegate;*/

	@property (retain, nonatomic) UXView *contentView;

@end

#pragma mark -

@protocol UXPanelViewControllerDelegate <NSObject>

@optional

	/*!
	@abstract The result
	*/
	-(BOOL) panelController:(UXPanelViewController *)controller shouldCompleteWithResult:(id)result;

	/*!
	@abstract The result
	*/
	-(void) panelController:(UXPanelViewController *)controller didCompleteWithResult:(id)result;

	/*!
	@abstract The controller was cancelled before completion
	*/
	-(void) panelControllerDidCancel:(UXPanelViewController *)controller;

@end
