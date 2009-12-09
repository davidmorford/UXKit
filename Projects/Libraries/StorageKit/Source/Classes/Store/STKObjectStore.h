
/*!
@project    StorageKit
@header     STKObjectStore.h
@copyright  (c) 2009, Semantap
*/

#import <CoreData/CoreData.h>
#import <StorageKit/STKStore.h>
#import <StorageKit/STKStoreDelegate.h>

/*!
@class STKObjectStore
@superclass NSObject
@abstract
@discussion
*/
@interface STKObjectStore : NSObject <STKStore> {
	id <STKStoreDelegate> delegate;
	NSURL *modelURL;
	NSURL *persistentStoreURL;
	NSString *storeType;
	NSDictionary *storeOptions;
	NSString *storeIdentifier;
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
	NSManagedObjectModel *managedObjectModel;
	NSManagedObjectContext *managedObjectContext;
}

	@property (readwrite, assign) id <STKStoreDelegate> delegate;

	@property (readonly, retain) NSURL *modelURL;
	@property (readonly, retain) NSURL *persistentStoreURL;
	@property (readonly, retain) NSString *storeType;
	@property (readonly, retain) NSDictionary *storeOptions;
	@property (readonly, retain) NSString *storeIdentifier;

	@property (readonly, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;
	@property (readonly, retain) NSManagedObjectModel *managedObjectModel;
	@property (readonly, retain) NSManagedObjectContext *managedObjectContext;

	@property (readonly) NSArray *persistentStores;


	#pragma mark Model and Persistent Store URL

	+(NSURL *) modelURLForName:(NSString *)modelName;
	+(NSURL *) persistentStoreURLForName:(NSString *)name storeType:(NSString *)type forceReplace:(BOOL)forceReplace;


	#pragma mark Initializers

	-(id) initWithModelURL:(NSURL *)aModelURL persistentStoreURL:(NSURL *)aStoreURL storeType:(NSString *)type storeOptions:(NSDictionary *)options;
	-(id) initWithModelURL:(NSURL *)aModelURL persistentStoreName:(NSString *)aName forceReplace:(BOOL)forceReplace storeType:(NSString *)type storeOptions:(NSDictionary *)options;
	-(id) initWithModelName:(NSString *)modelName persistentStoreName:(NSString *)storeName forceReplace:(BOOL)forceReplace storeType:(NSString *)type storeOptions:(NSDictionary *)options;
	-(id) initWithName:(NSString *)name forceReplace:(BOOL)forceReplace storeType:(NSString *)type storeOptions:(NSDictionary *)options;

	#pragma mark -

	-(void) save;
	-(BOOL) save:(NSError **)error;
	-(BOOL) migrate:(NSError **)error;
	-(void) presentError:(NSError *)error;

	#pragma mark -

	-(NSArray *) persistentStores;
	-(NSPersistentStore *) persistentStoreForConfigurationName:(NSString *)configurationName;
	-(NSPersistentStore *) persistentStoreWithIdentifer:(NSString *)identifer;
	-(NSPersistentStore *) addStoreWithIdentifier:(NSString *)storeName storeType:(NSString *)type forModelConfiguration:(NSString *)modelConfiguration;

	#pragma mark -

	-(NSManagedObjectContext *) newManagedObjectContext;

	#pragma mark -

	-(NSEntityDescription *) entityForObjectID:(NSManagedObjectID *)objectID;
	-(NSManagedObjectID *) managedObjectIDForURI:(NSURL *)objectURI;
	-(NSPersistentStore *) persistentStoreForObjectID:(NSManagedObjectID *)objectID;

@end

#pragma mark -

@interface STKObjectStore (Sorting)

	-(NSArray *) sortDescriptorArrayWithDescriptorWithKey:(NSString *)key;

@end

#pragma mark -

@interface STKObjectStore (Fetching)

	-(NSArray *) fetchAllEntitiesForName:(NSString *)entityName;
	-(NSArray *) fetchAllEntitiesForName:(NSString *)entityName sortDescriptors:(NSArray *)sortDescriptors;
	-(NSArray *) fetchAllEntitiesForName:(NSString *)entityName sortDescriptors:(NSArray *)sortDescriptors batchSize:(NSUInteger)batchSize;

@end

#pragma mark -

@interface STKObjectStore (Query)

	-(NSManagedObject *) managedObjectOfType:(NSString *)type withPredicate:(NSPredicate *)predicate;

@end
