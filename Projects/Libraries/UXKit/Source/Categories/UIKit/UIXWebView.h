
/*!
@project	UXKit
@header     UIXWebView.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UIKit/UIKit.h>

/*!
@category UIWebView (UXCategory)
@abstract
@discussion
*/
@interface UIWebView (UXCategory)

	/*!
	@abstract Gets the frame of a DOM element in the page.
	@query A JavaScript expression that evaluates to a single DOM element.
	*/
	-(CGRect)frameOfElement:(NSString *)query;

@end
