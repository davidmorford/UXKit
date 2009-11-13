
/*!
@project    UXKit
@header     UXStore.h
@copyright  (c) 2009 - Semantap
@author     david [at] semantap.com
@created    11/13/09 – 12:57 PM
*/

#import <CoreData/CoreData.h>
#import <UXKit/UXStoreContext.h>

/*!
@protocol UXStore <NSObject>
@abstract 
*/
@protocol UXStore <NSObject>

@end

#pragma mark -

/*!
@class STKObjectFileStore
@superclass NSObject <UXStore>
@abstract
@discussion
*/
@interface UXStore : NSObject <UXStore> {
	id delegate;
	NSURL *storeURL;
	NSString *storeIdentifier;
	NSManagedObjectModel *managedObjectModel;
	NSMutableSet *managedObjectContexts;
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
	NSNotificationCenter *notificationCenter;
	NSOperationQueue *fetchOperationQueue;
}

	@property (nonatomic, assign) id delegate;
	@property (nonatomic, retain) NSString *storeIdentifier;
	@property (nonatomic, retain) NSURL *storeURL;
	@property (nonatomic, retain) NSManagedObjectModel *managedObjectModel;

	@property (nonatomic, assign) NSPersistentStoreCoordinator *persistentStoreCoordinator;
	@property (nonatomic, retain, readonly) NSArray *persistentStores;
	@property (nonatomic, retain, readonly) NSSet *managedObjectContexts;
	@property (nonatomic, retain) NSOperationQueue *fetchOperationQueue;

	#pragma mark Initializers

	/*!
	@abstract Designated initializer for subclasses.
	*/
	-(id) init;

	/*!
	@abstract Creates a store with the model and store directory.
	@discussion If the setup flag is TRUE, the setup routines are perfomed, creating 
	and adding persistent in memory store if storeDirectoryURL is nil and a SQLite
	store if the URL is valid. A single context named "Default" is added to to
	*/
	-(id) initWithManagedObjectModel:(NSManagedObjectModel *)model storeDirectoryURL:(NSURL *)aURL setup:(BOOL)flag;

	#pragma mark Setup

	-(void) storeCanMergeManagedObjectModels;
	-(void) storeWillCreatePersistentStoreCoordinator;
	-(void) storeCanAddPersistentStores;
	-(void) storeCanCreateManagedObjectContexts;	

	#pragma mark Models

	-(void) addModels:(NSArray *)aModelArray;
	-(void) addModel:(NSManagedObjectModel *)anObjectModel;

	#pragma mark Fetch Requests Template

	-(NSArray *) fetchRequestTemplateNames;
	-(NSFetchRequest *) fetchRequestTemplateForName:(NSString *)name;
	-(NSFetchRequest *) fetchRequestFromTemplateWithName:(NSString *)aName substitutionVariables:(NSDictionary *)variables;

	#pragma mark Stores

	-(NSPersistentStore *) persistentStoreForConfigurationName:(NSString *)aConfigurationName;
	-(NSPersistentStore *) persistentStoreWithIdentifer:(NSString *)anIdentifer;
	-(NSPersistentStore *) addStoreWithIdentifier:(NSString *)aStoreName storeType:(NSString *)aStoreType forModelConfiguration:(NSString *)aModelConfiguration;

	#pragma mark Contexts

	-(id <UXStoreContext>) newManagedObjectContextWithIdentifier:(NSString *)anIdentifier;
	-(id <UXStoreContext>) managedObjectContextWithIdentifier:(NSString *)anIdentifier;

	-(void) addManagedObjectContext:(NSManagedObjectContext *)aManagedObjectContext;
	-(void) removeManagedObjectObject:(NSManagedObjectContext *)aManagedObjectContext;

	-(BOOL) saveContexts;
	-(BOOL) saveContextWithIdentifier:(NSString *)aName;

	#pragma mark Managed Objects
	
	-(NSEntityDescription *) entityForObjectID:(NSManagedObjectID *)anObjectID;
	-(NSManagedObjectID *) managedObjectIDForURI:(NSURL *)anObjectURI;
	-(NSManagedObject *) managedObjectForURI:(NSURL *)anObjectURI;
	-(NSPersistentStore *) persistentStoreForObjectID:(NSManagedObjectID *)anObjectID;

	#pragma mark Fetch Requests

	-(NSArray *) executeFetchRequest:(NSFetchRequest *)request withManagedObjectContext:(NSManagedObjectContext *)context;
	-(NSArray *) executeFetchRequestWithName:(NSString *)aName withManagedObjectContext:(NSManagedObjectContext *)context;

	#pragma mark Entity Fetch Requests

	-(NSArray *) objectsWithEntityName:(NSString *)anEntityName inManagedObjectContext:(NSManagedObjectContext *)aContext;
	-(NSArray *) objectsWithEntityName:(NSString *)anEntityName inManagedObjectContext:(NSManagedObjectContext *)aContext matchingPredicate:(NSPredicate *)aPredicate;
	-(NSArray *) objectsWithEntityName:(NSString *)anEntityName inManagedObjectContext:(NSManagedObjectContext *)aContext matchingPredicate:(NSPredicate *)aPredicate sortedBy:(NSSortDescriptor *)aSortDescriptor;

	#pragma mark Object ID Fetch Requests

	-(NSArray *) objectIDsWithEntityName:(NSString *)anEntityName inManagedObjectContext:(NSManagedObjectContext *)aContext matchingPredicate:(NSPredicate *)aPredicate;

	#pragma mark Notifications

	-(void) coordinatorStoresDidChangeNotification:(NSNotification *)aNotification;
	-(void) contextObjectsDidChangeNotification:(NSNotification *)aNotification;
	-(void) contextDidSaveNotification:(NSNotification *)aNotification;

@end

#pragma mark -

/*!
@category NSObject (UXStoreSetupDelegate)
@abstract To be utilized by delegates when the store object is used as a property or ivar within a larger composite class.
*/
@interface NSObject (UXStoreSetupDelegate)
	-(void) storeCanMergeManagedObjectModels:(id <UXStore>)store;
	-(void) storeWillCreatePersistentStoreCoordinator:(id <UXStore>)store;
	-(void) storeCanAddPersistentStores:(id <UXStore>)store;
	-(void) storeCanCreateManagedObjectContexts:(id <UXStore>)store;
@end

#pragma mark -

/*!
@category NSObject(UXStoreNotificationDelegate)
@abstract
*/
@interface NSObject (UXStoreNotificationDelegate)

	-(void) store:(id <UXStore>)aStore coordinatorStoresDidChange:(NSNotification *)aNotification;
	-(void) store:(id <UXStore>)aStore contextObjectsDidChange:(NSNotification *)aNotification;
	-(void) store:(id <UXStore>)aStore contextDidSave:(NSNotification *)aNotification;	
	
@end

#pragma mark -

/*!
@category NSString(UXStoreModelNameConversions)
@abstract
*/
@interface NSString (UXStoreModelNameConversions)
	+(NSString *) externalNameForInternalName:(NSString *)aName separatorString:(NSString *)aSeparatorString useAllCaps:(BOOL)useAllCaps;
	+(NSString *) nameForExternalName:(NSString *)aName separatorString:(NSString *)aSeparatorString initialCaps:(BOOL)initialCaps;
@end


#pragma mark -

/*!
@protocol UXStoreDelegate <NSObject>
@abstract ￼
@discussion ￼
*/
@protocol UXStoreDelegate <NSObject>

@optional
	-(void) store:(id <UXStore>)store willMergeManagedObjectModels:(NSArray *)models error:(NSError *)error;
	-(void) store:(id <UXStore>)store didCreatePersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator error:(NSError *)error;
	-(void) store:(id <UXStore>)store willAddPersistentStores:(NSArray *)stores error:(NSError *)error;
	-(void) store:(id <UXStore>)store willCreateManagedObjectContexts:(NSArray *)contexts error:(NSError *)error;

@optional
	-(void) store:(id <UXStore>)store coordinatorStoresDidChange:(NSPersistentStoreCoordinator *)coordinator;
	-(void) store:(id <UXStore>)store contextObjectsDidChange:(NSArray *)changedObjects;
	-(void) store:(id <UXStore>)store contextDidSave:(NSArray *)context;

@end
