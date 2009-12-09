
/*!
@project	StorageKit	
@header		STKManagedObjectContext.h
@copyright	(c) 2006 - 2009, Semanteme/Semantap.
@created	5/1/2007 - dpm
@updated	11/21/2009 - dpm
*/

#import <CoreData/CoreData.h>

/*!
@class STKManagedObjectContext
@superclass NSManagedObjectContext
@abstract
@discussion
*/
@interface STKManagedObjectContext : NSManagedObjectContext {
	NSString *identifier;
}

	@property (copy) NSString *identifier;
	
	#pragma mark Initializer
		
	-(id) initWithIdentifier:(NSString *)anIdentifier;
	-(id) initWithIdentifier:(NSString *)aName persistentStoreCoordinator:(NSPersistentStoreCoordinator *)aCoordinator;
	
@end
