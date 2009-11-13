
/*!
@project    UXKit
@header     UXPageControl.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UIKit/UIKit.h>
#import <UXKit/UXGlobal.h>

@class UXStyle;

/*!
@class UXPageControl
@superclass UIView
@abstract A version of UIPageControl which allows you to style the dots.
@discussion
*/
@interface UXPageControl : UIControl {
	NSInteger _numberOfPages;
	NSInteger _currentPage;
	NSString *_dotStyle;
	UXStyle *_normalDotStyle;
	UXStyle *_currentDotStyle;
	BOOL _hidesForSinglePage;
}

	@property (nonatomic) NSInteger numberOfPages;
	@property (nonatomic) NSInteger currentPage;
	@property (nonatomic, copy) NSString *dotStyle;
	@property (nonatomic) BOOL hidesForSinglePage;

@end
