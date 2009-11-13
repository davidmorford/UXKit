
/*!
@project	UXKit
@header		UXPickerTextField.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXSearchTextField.h>

@class UXPickerViewCell;

/*!
@class UXPickerTextField
@superclass UXSearchTextField
@abstract
@discussion
*/
@interface UXPickerTextField : UXSearchTextField {
	NSMutableArray *_cellViews;
	UXPickerViewCell *_selectedCell;
	int _lineCount;
	CGPoint _cursorOrigin;
}

	@property (nonatomic, readonly) NSArray *cellViews;
	@property (nonatomic, readonly) NSArray *cells;
	@property (nonatomic, assign) UXPickerViewCell *selectedCell;
	@property (nonatomic, readonly) int lineCount;

	-(void) addCellWithObject:(id)object;
	-(void) removeCellWithObject:(id)object;

	-(void) removeAllCells;
	-(void) removeSelectedCell;

	-(void) scrollToVisibleLine:(BOOL)animated;
	-(void) scrollToEditingLine:(BOOL)animated;

@end

#pragma mark -

/*!
@protocol UXPickerTextFieldDelegate <UXSearchTextFieldDelegate>
@abstract
@discussion
*/
@protocol UXPickerTextFieldDelegate <UXSearchTextFieldDelegate>

	-(void) textField:(UXPickerTextField *)textField didAddCellAtIndex:(NSInteger)index;
	-(void) textField:(UXPickerTextField *)textField didRemoveCellAtIndex:(NSInteger)index;
	-(void) textFieldDidResize:(UXPickerTextField *)textField;

@end
