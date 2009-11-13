
/*!
@project	UXKit
@header		UXPickerViewCell.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXView.h>

/*!
@class UXPickerViewCell
@superclass UXView
@abstract
@discussion
*/
@interface UXPickerViewCell : UXView {
	id _object;
	UILabel *_labelView;
	BOOL _selected;
}

	@property (nonatomic, retain) id object;
	@property (nonatomic, copy) NSString *label;
	@property (nonatomic, retain) UIFont *font;
	@property (nonatomic) BOOL selected;

@end
