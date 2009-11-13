
/*!
@project	UXCatalog
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXKit.h>

/*!
@class TabButtonBarTestController
@superclass UIViewController
@abstract
@discussion
*/
@interface TabButtonBarTestController : UXViewController <UXTabDelegate> {
	UXTabButtonBar *tabButtonBar;
}

@end

#pragma mark -

/*!
@class TabButtonBarStyleSheet
@superclass UXDefaultStyleSheet
@abstract
@discussion
*/
@interface TabButtonBarStyleSheet : UXDefaultStyleSheet {

}

@end
