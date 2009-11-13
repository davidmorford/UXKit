
/*!
@project	UXKit
@header     UXTableView.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXGlobal.h>

@class UXStyledTextLabel;

/*!
@class UXTableView
@superclass UITableView
@abstract UXTableView enhances UITableView to provide support for various UXKit services.
@discussion If you are using UXStyledTextLabels in your table cells, you need to use UXTableView if
you want links in your labels to be touchable.
*/
@interface UXTableView : UITableView {
	UXStyledTextLabel *_highlightedLabel;
	CGPoint _highlightStartPoint;
	CGFloat _contentOrigin;
}

	@property (nonatomic, retain) UXStyledTextLabel *highlightedLabel;
	@property (nonatomic) CGFloat contentOrigin;

@end

#pragma mark -

/*!
@protocol UXTableViewDelegate <UITableViewDelegate>
@abstract
*/
@protocol UXTableViewDelegate <UITableViewDelegate>

	-(void) tableView:(UITableView *)aTableView touchesBegan:(NSSet *)aTouchSet withEvent:(UIEvent *)anEvent;
	-(void) tableView:(UITableView *)aTableView touchesEnded:(NSSet *)aTouchSet withEvent:(UIEvent *)anEvent;

@end
