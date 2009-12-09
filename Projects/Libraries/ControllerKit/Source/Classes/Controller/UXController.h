
/*!
@project    UXTableCatalog
@header     UXController.h
@copyright  (c) 2009 - Semantap
@author     david [at] semantap.com
@created    11/26/09 – 5:54 AM
*/

#import <Foundation/Foundation.h>

/*!
@protocol  UXController
@abstract 
*/
@protocol UXController <NSObject>
	
@required
	@property (assign) BOOL isEditing;
	@property (assign) BOOL isEditable;

@optional
	-(void) objectDidBeginEditing:(id)editor;
	-(void) objectDidEndEditing:(id)editor;

@end
