
/*!
@project    StorageKit
@header     STKObjectStoreDelegate.h
@copyright  (c) 2009, Semantap
*/

#import <CoreData/CoreData.h>
#import <StorageKit/STKStore.h>

/*!
@protocol STKStoreDelegate <NSObject>
@abstract ￼
@discussion ￼
*/
@protocol STKStoreDelegate <NSObject>
	
@required
	-(void) store:(id <STKStore>)store didCreateNewManagedObjectContext:(NSManagedObjectContext *)context;
	
@optional
	-(void) store:(id <STKStore>)store willMergeManagedObjectModels:(NSArray *)models error:(NSError *)error;
	-(void) store:(id <STKStore>)store didCreatePersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator error:(NSError *)error;
	-(void) store:(id <STKStore>)store willAddPersistentStores:(NSArray *)stores error:(NSError *)error;
	-(void) store:(id <STKStore>)store willCreateManagedObjectContexts:(NSArray *)contexts error:(NSError *)error;

@optional
	-(void) store:(id <STKStore>)store coordinatorStoresDidChange:(NSPersistentStoreCoordinator *)coordinator;
	-(void) store:(id <STKStore>)store contextObjectsDidChange:(NSArray *)changedObjects;
	-(void) store:(id <STKStore>)store contextDidSave:(NSArray *)context;

@end
