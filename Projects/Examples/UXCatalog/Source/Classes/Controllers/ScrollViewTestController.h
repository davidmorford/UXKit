
/*!
@project	UXCatalog
@header     ScrollViewTestController.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXKit.h>

/*!
@class ScrollViewTestController
@superclass UXViewController <UXScrollViewDataSource>
@abstract
@discussion
*/
@interface ScrollViewTestController : UXViewController <UXScrollViewDataSource> {
	UXScrollView *_scrollView;
	NSArray *_colors;
}

@end
