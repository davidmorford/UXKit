
/*!
@project    UXKit
@header     UXManagedTableViewController.h
@copyright	(c) 2009 Semantap
*/

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

/*!
@class UXManagedTableViewController
@superclass UXManagedModelViewController
@abstract
@discussion
*/
@interface UXManagedTableViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	NSString *entityName;
}

	@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
	@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
	
	-(id) initWithEntityName:(NSString *)anEntityName;
	
	//-(id) initWithManagedObjectURI:(NSString *)objectURI;

@end
