
/*!
@project	UXKit
@header     UXAlertViewController.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXPopupViewController.h>

@protocol UXAlertViewControllerDelegate;

/*!
@class UXAlertViewController
@superclass UXPopupViewController
@abstract A view controller that displays an alert view.
@discussion This class exists in order to allow alert views to be displayed 
by UXNavigator, and gain all the benefits of persistence and URL dispatch.
*/
@interface UXAlertViewController : UXPopupViewController <UIAlertViewDelegate> {
	id <UXAlertViewControllerDelegate> _delegate;
	id _userInfo;
	NSMutableArray *_URLs;
}

	@property (nonatomic, assign) id <UXAlertViewControllerDelegate> delegate;
	@property (nonatomic, readonly) UIAlertView *alertView;
	@property (nonatomic, retain) id userInfo;

	#pragma mark Initializer
	
	-(id) initWithTitle:(NSString *)aTitle message:(NSString *)aMessage;
	-(id) initWithTitle:(NSString *)aTitle message:(NSString *)aMessage delegate:(id)aDelegate;

	-(NSInteger) addButtonWithTitle:(NSString *)aTitle URL:(NSString *)aURL;
	-(NSInteger) addCancelButtonWithTitle:(NSString *)aTitle URL:(NSString *)aURL;

	-(NSString * ) buttonURLAtIndex:(NSInteger)anIndex;

@end

#pragma mark -

/*!
@protocol UXAlertViewControllerDelegate <UIAlertViewDelegate>
@abstract
*/
@protocol UXAlertViewControllerDelegate <UIAlertViewDelegate>

	-(BOOL) alertViewController:(UXAlertViewController *)controller 
	  didDismissWithButtonIndex:(NSInteger)buttonIndex 
							URL:(NSString *)urlString;

@end
