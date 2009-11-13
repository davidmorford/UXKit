
/*!
@project	UXKit
@header     UIXTableView.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UIKit/UIKit.h>

/*!
@class UITableView (UIXTableView)
@abstract
@discussion
*/
@interface UITableView (UIXTableView)

	/*!
	@abstract The view that contains the "index" along the right side of the table.
	*/
	@property (nonatomic, readonly) UIView *indexView;

	/*!
	@abstract Returns the margin used to inset table cells.
	@discussion Grouped tables have a margin but plain tables don't.  This is useful 
	in table cell layout calculations where you don't want to hard-code the table style.
	*/
	@property (nonatomic, readonly) CGFloat tableCellMargin;


	#pragma mark Scrolling

	-(void) scrollToTop:(BOOL)animated;

	-(void) scrollToBottom:(BOOL)animated;

	-(void) scrollToFirstRow:(BOOL)animated;

	-(void) scrollToLastRow:(BOOL)animated;

	-(void) scrollFirstResponderIntoView;

	-(void) touchRowAtIndexPath:(NSIndexPath *)anIndexPath animated:(BOOL)animated;

@end
