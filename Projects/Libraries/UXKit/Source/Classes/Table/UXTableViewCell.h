
/*!
@project	UXKit
@header     UXTableViewCell.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXGlobal.h>

/*!
@class UXTableViewCell
@superclass UITableViewCell
@abstract The base class for table cells which are single-object based. Subclasses should 
implement the object getter and setter. The base implementations do nothing, allowing you 
to store the object yourself using the appropriate type.
@discussion UXTableViewDataSource initializes each cell that it creates by assigning it the object
that the data source returned for the row. The responsibility for initializing the table cell
is then shifted from the table data source to the setObject method on the cell itself, which
this developer feels is a more appropriate delegation.  The same goes for the cell height
measurement, whose responsibility is transferred from the data source to the cell.
*/
@interface UXTableViewCell : UITableViewCell

	@property (nonatomic, retain) id object;

	/*!
	@abstract Measure the height of the row with the object that will be assigned to the cell.
	*/
	+(CGFloat) tableView:(UITableView *)aTableView rowHeightForObject:(id)anObject;

@end
