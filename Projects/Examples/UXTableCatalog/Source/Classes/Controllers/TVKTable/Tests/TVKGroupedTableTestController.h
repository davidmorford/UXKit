
/*!
@project    UXTableCatalog
@header     TVKGroupedTableTestController.h
@copyright  (c) 2009 - Semantap
@created    11/28/09
*/

#import <UIKit/UIKit.h>
#import <UXKit/UXKit.h>
#import <TableKit/TVKTableViewController.h>

/*!
@class TVKGroupedTableTestController
@abstract
@discussion
*/
@interface TVKGroupedTableTestController : TVKTableViewController {

}

	-(void) addSection;
	-(void) addRow;
	-(void) insertExpandableSection;

@end

#pragma mark -

/*!
@class TVKGroupedStyledTableTestController
@superclass TVKTableViewController
@abstract
@discussion
*/
@interface TVKGroupedStyledTableTestController : TVKTableViewController {

}

	-(void) addRow;

@end
