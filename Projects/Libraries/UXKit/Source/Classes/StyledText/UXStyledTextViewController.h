
/*!
@project    UXKit
@header     UXStyledTextViewController.h
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXViewController.h>

@class UXStyledText, UXStyledTextLabel;

/*!
@class UXStyledTextViewController
@superclass UIViewController
@abstract
@discussion
*/
@interface UXStyledTextViewController : UXViewController {
	UIScrollView *scrollView;
	NSString *text;
	UXStyledText *styledText;
	UXStyledTextLabel *styledTextLabel;
}

	@property (nonatomic, retain) UIScrollView *scrollView;
	@property (nonatomic, retain) NSString *text;
	@property (nonatomic, retain) UXStyledText *styledText;
	@property (nonatomic, retain) UXStyledTextLabel *styledTextLabel;

	-(id) initWithText:(NSString *)textString;
	-(id) initWithFile:(NSString *)fileName;

@end
