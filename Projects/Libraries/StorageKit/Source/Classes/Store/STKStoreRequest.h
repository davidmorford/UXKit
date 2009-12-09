
/*!
@project    StorageKit
@header     STKStoreRequest.h
*/

#import <CoreData/CoreData.h>

/*!
@class STKStoreRequest
@superclass NSObject
@abstract
@discussion
*/
@interface STKStoreRequest : NSObject {	
	NSManagedObjectContext *managedObjectContext;
	NSString *entityName;
	NSEntityDescription *entityDescription;
	NSFetchRequest *fetchRequest;
	NSPredicate *predicate;
	NSArray *sortDescriptors;
	NSFetchedResultsController *fetchedResultsController;
	NSString *sectionNameKeyPath;
	NSString *cacheName;
}

	@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
	@property (nonatomic, retain) NSString *entityName;
	@property (nonatomic, retain) NSEntityDescription *entityDescription;
	@property (nonatomic, retain) NSPredicate *predicate;
	@property (nonatomic, retain) NSArray *sortDescriptors;
	
	@property (nonatomic, retain) NSString *sectionNameKeyPath;
	@property (nonatomic, retain) NSString *cacheName;

	@property (nonatomic, assign, readonly) NSFetchRequest *fetchRequst;
	@property (nonatomic, assign, readonly) NSFetchedResultsController *fetchedResultsController;


	#pragma mark Constructors

	+(STKStoreRequest *) storeRequest;
	+(STKStoreRequest *) storeRequestWithEntityName:(NSString *)name;


	#pragma mark Initializers

	-(id) initWithEntityName:(NSString *)name;

@end
