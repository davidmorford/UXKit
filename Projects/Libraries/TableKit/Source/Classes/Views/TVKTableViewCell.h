
/*!
@project    UXTableCatalog
@header     TVKTableViewCell.h
@copyright  (c) 2009 , Semantap
@created    11/26/09
*/

#import <UIKit/UIKit.h>

@class TVKTableItem;

/*!
@class TVKTableViewCell
@superclass UITableViewCell
@abstract
*/
@interface TVKTableViewCell : UITableViewCell {

}

@end

#pragma mark -

typedef NSUInteger TVKTableViewCellStyle;
enum {
    TVKTableViewCellStyleDefault		= UITableViewCellStyleDefault,
    TVKTableViewCellStyleValue1			= UITableViewCellStyleValue1,
    TVKTableViewCellStyleValue2			= UITableViewCellStyleValue2,
    TVKTableViewCellStyleSubtitle		= UITableViewCellStyleSubtitle, 
	TVKTableViewCellEditingStyleDefault = 10000, 
	TVKTableViewCellEditingStyleValue1, 
	TVKTableViewCellEditingStyleValue2, 
	TVKTableViewCellEditingStyleSubtitle
};

/*!
@class TVKEditingTableViewCell
@superclass UITableViewCell
@abstract
*/
@interface TVKEditingTableViewCell : TVKTableViewCell <UITextFieldDelegate> {
    TVKTableViewCellStyle style;
    UITextField *textField;
    UITextField *detailTextField;
    UIColor *textColor;
    UIColor *highlightedTextColor;
    BOOL doneSetFontSize;
}

	@property (nonatomic, readonly, retain) UITextField *textField;
	@property (nonatomic, readonly, retain) UITextField *detailTextField;

	/*!
	@abstract text field textColor
	@discussion Changes the textField or detailTextField's textColor
	*/
	@property (nonatomic, retain) UIColor *textColor;

	/*!
	@abstract highlightedTextColor
	@discussion If changes textField or detailTextField highlightedTextColor
	*/
	@property (nonatomic, retain) UIColor *highlightedTextColor;

	#pragma mark Initializer

	-(id) initWithStyle:(TVKTableViewCellStyle)cellStyle reuseIdentifier:(NSString *)identifier;

@end

#pragma mark -

@interface TVKTableViewContentCell : TVKTableViewCell {
    UIView *cellContentView;
	BOOL clearSelectedLabel;
}

	-(id) initWithContentViewClass:(Class)contentViewClass;
	-(id) initWithContentViewClass:(Class)contentViewClass text:(NSString *)textString subtitle:(NSString *)subtitleString image:(UIImage *)image;

@end

#pragma mark -

@interface TVKTableViewCellContentView : UIView {
	TVKTableViewContentCell *cell;
	BOOL highlighted;
}

	-(id) initWithFrame:(CGRect)frame cell:(TVKTableViewContentCell *)tableViewCell;

@end

#pragma mark -

@interface TVKTableViewCellGradientContentView : TVKTableViewCellContentView {

}

@end
