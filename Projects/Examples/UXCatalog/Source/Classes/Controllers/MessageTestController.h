
/*!
@project	UXCatalog
@header		MessageTestController.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXKit.h>
#import "UXMessageController.h"
#import "SearchTestController.h"

@class MockDataSource;

/*!
@class MessageTestController
@superclass UXViewController <UXMessageControllerDelegate, SearchTestControllerDelegate>
@abstract
@discussion
*/
@interface MessageTestController : UXViewController <UXMessageControllerDelegate, SearchTestControllerDelegate> {
	NSTimer *_sendTimer;
}

@end
