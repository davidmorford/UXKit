
/*!
@project    UXTableCatalog
@header     TVKPlainTableTestController.h
@copyright  (c) 2009, Semantap
@created    11/28/09
*/

#import <UIKit/UIKit.h>
#import <UXKit/UXKit.h>
#import <TableKit/TVKTableViewController.h>

/*!
@class TVKPlainTableTestController
@abstract
@discussion
*/
@interface TVKPlainTableTestController : TVKTableViewController {

}

@end

#pragma mark -

/*!
@class TVKPlainStyledTableTestController 
@superclass  TVKTableViewController
@abstract
@discussion
*/
@interface TVKPlainStyledTableTestController : TVKTableViewController {

}

	-(void) addRow;

@end

#pragma mark -

/*!
@class PlainManagedTableTestController
@superclass TVKTableViewController
@abstract
@discussion
*/
@interface TVKPlainManagedTableTestController : TVKTableViewController {

}

	-(void) fetchResults;
	-(void) add;
	-(void) save;

@end
