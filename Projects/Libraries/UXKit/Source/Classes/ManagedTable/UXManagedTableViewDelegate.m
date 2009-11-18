
#import "UXManagedTableViewDelegate.h"

@interface UXManagedTableViewDelegate ()

@end

#pragma mark -

@implementation UXManagedTableViewDelegate

	#pragma mark Initializer

	-(id) init {
		self = [super init];
		if (self) {
		}
		return self;
	}


	#pragma mark <UITableViewDelegate>

	#pragma mark Display Customization

	-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

	}


	#pragma mark Variable Height

	-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
		return 0.0;
	}

	-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section  {
		return 0.0;
	}

	-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section  {
		return 0.0;
	}


	#pragma mark Section Header / Footer

	/*! 
	@abstract custom view for header. will be adjusted to default or specified header height
	Views are preferred over title should you decide to provide both
	*/
	-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section  {
		return nil;
	}

	/*! 
	@abstract custom view for footer. will be adjusted to default or specified footer height
	*/
	-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
		return nil;
	}


	#pragma mark Accessories

	-(void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath  {

	}


	#pragma mark Selection

	/*! 
	@abstract Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
	*/
	-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
		return nil;
	}

	/*! 
	@version 3.0
	*/
	-(NSIndexPath *) tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
		return nil;
	}

	/*!
	@abstract Called after the user changes the selection.
	*/
	-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	}

	/*! 
	@version 3.0
	*/
	-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {

	}


	#pragma mark Editing

	/*!
	@abstract Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, 
	all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property 
	set to YES.
	*/
	-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
		return UITableViewCellEditingStyleNone;
	}

	/*! 
	@version 3.0
	*/
	-(NSString *) tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
		return nil;
	}

	/*!
	@abstract Controls whether the background is indented while editing.  If not implemented, the default is YES.  
	This is unrelated to the indentation level below.  This method only applies to grouped style table views.
	*/
	-(BOOL) tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
		return FALSE;
	}

	/*!
	@abstract The willBegin/didEnd methods are called whenever the 'editing' property is automatically 
	changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
	*/
	-(void) tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {

	}

	-(void) tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {

	}


	#pragma mark Moving / Reordering

	/*!
	@abstract Allows customization of the target row for a particular row as it is being moved/reordered
	*/
	-(NSIndexPath *) tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
		return nil;
	}


	#pragma mark Indentation

	/*!
	@abstract Return 'depth' of row for hierarchies
	*/
	-(NSInteger) tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
		return 0;
	}


	#pragma mark Destructor

	-(void) dealloc {
		[super dealloc];
	}

@end
