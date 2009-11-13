
/*!
@project    UXKit
@header     UXLauncherButton.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXButton.h>
#import <UXKit/UXURLRequest.h>

@class UXLauncherItem, UXLabel;

/*!
@class UXLauncherButton
@superclass UXButton <UXURLRequestDelegate>
@abstract
@discussion
*/
@interface UXLauncherButton : UXButton {
	UXLauncherItem *_item;
	UXLabel *_badge;
	UXButton *_closeButton;
	BOOL _dragging;
	BOOL _editing;
}

	@property (nonatomic, readonly) UXLauncherItem *item;
	@property (nonatomic, readonly) UXButton *closeButton;
	@property (nonatomic) BOOL dragging;
	@property (nonatomic) BOOL editing;

	-(id) initWithItem:(UXLauncherItem *)launchItem;

@end
