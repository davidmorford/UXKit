
/*!
@project    UXKit
@header     UXObjectStoreContext.h
@copyright  (c) 2009 - Semantap
@created    11/1/09 – david [at] semantap.com
*/

#import <UXKit/UXGlobal.h>
#import <CoreData/NSManagedObjectContext.h>

/*!
@protocol UXStoreContext <NSObject>
@abstract
*/
@protocol UXStoreContext <NSObject>

@optional
	@property (nonatomic, retain) NSString *identifier;

@end

#pragma mark -

/*!
@class UXObjectStoreContext
@superclass NSManagedObjectContext
@abstract
@discussion
*/
@interface UXObjectStoreContext : NSManagedObjectContext <UXStoreContext> {
	NSString *identifier;
}

	@property (nonatomic, retain) NSString *identifier;
	
	#pragma mark Initializer
		
	-(id) initWithIdentifier:(NSString *)anIdentifier;
	-(id) initWithIdentifier:(NSString *)aName persistentStoreCoordinator:(NSPersistentStoreCoordinator *)aCoordinator;

@end

#pragma mark -

/*!
@protocol UXManagedObjectContextDataSource <NSObject>
@abstract For managed object value editor controllers...
*/
@protocol UXManagedObjectContextDataSource <NSObject>

@required
	-(NSManagedObjectContext *) managedObjectContext;

@end
