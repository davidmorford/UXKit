
/*!
@project	UXKit
@header     UXActionSheetController.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXPopupViewController.h>

@protocol UXActionSheetControllerDelegate;

/*!
@class UXActionSheetController
@superclass UXPopupViewController
@abstract A view controller that displays an action sheet.
@discussion ￼This class exists in order to allow action sheets to be displayed by UXNavigator, and gain
all the benefits of persistence and URL dispatch.
*/
@interface UXActionSheetController : UXPopupViewController <UIActionSheetDelegate> {
	id <UXActionSheetControllerDelegate> _delegate;
	id _userInfo;
	NSMutableArray *_URLs;
}

	@property (nonatomic, assign) id <UXActionSheetControllerDelegate> delegate;
	@property (nonatomic, readonly) UIActionSheet *actionSheet;
	@property (nonatomic, retain) id userInfo;

	#pragma mark Initialziers

	-(id) initWithTitle:(NSString *)aTitle;
	-(id) initWithTitle:(NSString *)aTitle delegate:(id)aDelegate;

	-(NSInteger) addButtonWithTitle:(NSString *)aTitle URL:(NSString *)aURL;
	-(NSInteger) addCancelButtonWithTitle:(NSString *)aTitle URL:(NSString *)aURL;
	-(NSInteger) addDestructiveButtonWithTitle:(NSString *)aTitle URL:(NSString *)aURL;

	-(NSString *) buttonURLAtIndex:(NSInteger)anIndex;

@end

#pragma mark -

/*!
@protocol UXActionSheetControllerDelegate <UIActionSheetDelegate>
@abstract
*/
@protocol UXActionSheetControllerDelegate <UIActionSheetDelegate>

	-(BOOL) actionSheetController:(UXActionSheetController *)aController 
		didDismissWithButtonIndex:(NSInteger)aButtonIndex 
							  URL:(NSString *)aURLString;

@end
