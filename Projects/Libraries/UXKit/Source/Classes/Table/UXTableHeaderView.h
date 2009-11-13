
/*!
@project	UXKit
@header		UXTableHeaderView.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXView.h>

/*!
@class UXTableHeaderView
@superclass UXView
@abstract
@discussion
*/
@interface UXTableHeaderView : UXView {
	UILabel *_label;
}

	-(id) initWithTitle:(NSString *)aTitle;

@end

#pragma mark -

/*!
@class UXTableGroupedHeaderView
@superclass UXTableHeaderView
@abstract
@discussion
*/
@interface UXTableGroupedHeaderView : UXTableHeaderView {

}
 
@end