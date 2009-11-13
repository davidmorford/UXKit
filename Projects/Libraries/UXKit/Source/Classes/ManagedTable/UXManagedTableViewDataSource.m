
#import <UXKit/UXManagedTableViewDataSource.h>

@interface UXManagedTableViewDataSource ()

@end

#pragma mark -

@implementation UXManagedTableViewDataSource

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

@end
