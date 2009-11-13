
/*!
@project	UXKit
@header     UIXToolbar.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UIKit/UIKit.h>

/*!
@category UIToolbar (UIXToolbar)
@abstract
@discussion
*/
@interface UIToolbar (UIXToolbar)

	-(UIBarButtonItem *) itemWithTag:(NSInteger)aTag;

	-(void) replaceItemWithTag:(NSInteger)tag withItem:(UIBarButtonItem *)anItem;

@end
