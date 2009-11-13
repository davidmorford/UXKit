
/*!
@project    UXKit
@header     UXObjectStore.h
@copyright  (c) 2007 - 2009, Semantap
@created    06/15/2007 - dpm
@updated    10/31/2009 - dpm
*/

#import <UXKit/UXGlobal.h>
#import <CoreData/CoreData.h>

@class UXObjectStoreContext;

/*!
@class UXObjectStore
@superclass NSObject <UXStore>
@abstract
@discussion
*/
@interface UXObjectStore : UXStore {
	NSPersistentStore *memoryStore;
	UXObjectStoreContext *memoryStoreContext;
	NSPersistentStore *fileStore;
	UXObjectStoreContext *fileStoreContext;
}

	@property (nonatomic, retain) NSPersistentStore *memoryStore;
	@property (nonatomic, retain) UXObjectStoreContext *memoryStoreContext;

	@property (nonatomic, retain) NSPersistentStore *fileStore;
	@property (nonatomic, retain) UXObjectStoreContext *fileStoreContext;

	+(UXObjectStore *) sharedObjectStore;

@end
