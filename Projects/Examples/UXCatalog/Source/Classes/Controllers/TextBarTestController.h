
/*!
@project    UXCatalog
@header     TextBarTestController.h
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXKit.h>

/*!
@class TextBarTestController
@superclass UIViewController
@abstract
@discussion
*/
@interface TextBarTestController : UXViewController <UXTextBarDelegate> {
	UXTextBarController *textBarController;
	NSMutableArray *chatMessages;
	UIScrollView *scrollView;
}

	@property (retain, nonatomic) UXTextBarController *textBarController;
	@property (retain, nonatomic) NSMutableArray *chatMessages;

	-(void) insertMessageWithText:(NSString *)chatText;

@end
