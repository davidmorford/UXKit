
#import <UXKit/UXManagedTableViewDataSource.h>

@interface UXManagedTableViewDataSource ()

@end

#pragma mark -

@implementation UXManagedTableViewDataSource

	-(id) init {
		self = [super init];
		if (self != nil) {
		}
		return self;
	}


	#pragma mark <UITableViewDataSource>

	-(NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
		return 0;
	}

	/*!
	@abstract Row display. Implementers should *always* try to reuse cells by setting each cell's 
	reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
	Cell gets various attributes set automatically based on table (separators) and data source 
	(accessory views, editing controls)
	*/
	-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
		return nil;
	}

	/*!
	@abstract Default is 1 if not implemented
	*/
	-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
		return 1;
	}

	/*!
	@abstract Fixed font style. use custom view (UILabel) if you want something different
	*/
	-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { 
		return nil;
	}
	
	-(NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
		return nil;
	}


	#pragma mark Editing

	/*!
	@abstract Individual rows can opt out of having the -editing property set for them. If not 
	implemented, all rows are assumed to be editable.
	*/
	-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
		return FALSE;
	}


	#pragma mark Moving / Reordering

	/*!
	@abstract Allows the reorder accessory view to optionally be shown for a particular row. By default, the 
	reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
	*/
	-(BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
		return FALSE;
	}


	#pragma mark Index

	/*!
	@abstract return list of section titles to display in section index view (e.g. "ABCD...Z#")
	*/
	-(NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView {
		return nil;
	}

	/*!
	@abstract tell table which section corresponds to section title/index (e.g. "B",1))
	*/
	-(NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
		return 0;
	}


	#pragma mark Data Manipulation : Insert / Delete

	/*!
	@abstract After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle 
	for the cell), the dataSource must commit the change
	*/
	-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	}


	#pragma mark Data Manipulation : Reorder / Moving

	-(void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
	
	}


	#pragma mark <NSFetchedResultsControllerDelegate>

	/*!
	@abstract Notifies the delegate that a fetched object has been changed due to an add, remove, move, or update. 
	controller - controller instance that noticed the change on its fetched objects
	anObject - changed object
	indexPath - indexPath of changed object (nil for inserts)
	type - indicates if the change was an insert, delete, move, or update
	newIndexPath - the destination path for inserted or moved objects, nil otherwise

	Changes are reported with the following heuristics:

	On Adds and Removes, only the Added/Removed object is reported. It's assumed that all objects that come after the affected object are also moved, but these moves are not reported. 
	The Move object is reported when the changed attribute on the object is one of the sort descriptors used in the fetch request.  An update of the object is assumed in this case, but no separate update message is sent to the delegate.
	The Update object is reported when an object's state changes, and the changed attributes aren't part of the sort keys. 
	*/
	-(void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {

	}

	/*!
	@abstract Notifies the delegate of added or removed sections. 

	controller - controller instance that noticed the change on its sections
	sectionInfo - changed section
	index - index of changed section
	type - indicates if the change was an insert or delete

	Changes on section info are reported before changes on fetchedObjects. 
	*/
	-(void) controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	}

	/*!
	@abstract  Notifies the delegate that section and object changes are about to be processed and notifications will be sent. 
	Clients utilizing a UITableView may prepare for a batch of updates by responding to this method with -beginUpdates
	*/
	-(void) controllerWillChangeContent:(NSFetchedResultsController *)controller {
	}

	/*!
	@abstract Notifies the delegate that all section and object changes have been sent. 
	*/
	-(void) controllerDidChangeContent:(NSFetchedResultsController *)controller {

	}

	#pragma mark -

	-(void) dealloc {
		[super dealloc];
	}

@end
