
/*!
@project    UXKit
@header     UIXBarButtonItem.h
@copyright  (c) 2009 - Semantap
@created    11/16/09
*/

#import <UIKit/UIKit.h>

/*!
@category UIBarButtonItem (UIXBarButtonItem)
@abstract Because you have typed or copy/pasted this method far too many times...
@discussion
*/
@interface UIBarButtonItem (UIXBarButtonItem)

	+(UIBarButtonItem *) plainBarButtonItemWithImage:(UIImage *)anImage target:(id)aTarget action:(SEL)anAction;
	+(UIBarButtonItem *) plainBarButtonItemWithTitle:(NSString *)aTitle target:(id)aTarget action:(SEL)anAction;
	
	+(UIBarButtonItem *) borderedBarButtonItemWithImage:(UIImage *)anImage target:(id)aTarget action:(SEL)anAction;
	+(UIBarButtonItem *) borderedBarButtonItemWithTitle:(NSString *)aTitle target:(id)aTarget action:(SEL)anAction;
	
	+(UIBarButtonItem *) doneBarButtonItemWithTitle:(NSString *)aTitle target:(id)aTarget action:(SEL)anAction;
	
	+(UIBarButtonItem *) systemBarButtonItemWithType:(UIBarButtonSystemItem)systemItem target:(id)aTarget action:(SEL)anAction;
	
	+(UIBarButtonItem *) customBarButtonItemWithView:(UIView *)aView target:(id)aTarget action:(SEL)anAction;

	+(UIBarButtonItem *) flexibleSpaceBarItem;
	+(UIBarButtonItem *) fixedSpaceBarItemWithWidth:(CGFloat)spaceWidth;

@end
