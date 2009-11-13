
/*!
@project    UXKit
@header     UXManagedObject.h
@copyright  (c) 2006 - 2009, Semantap
@updated	11/1/09 - Updates from Mac OS X to iPhone OS
*/

#import <UXKit/UXGlobal.h>
#import <CoreData/CoreData.h>

/*!
@class UXManagedObject
@superclass NSManagedObject
@abstract 
@discussion 
*/
@interface UXManagedObject : NSManagedObject

	+(NSString *) entityPrefix;
	+(NSString *) entityName;

	#pragma mark -

	+(NSEntityDescription *) entityDescriptionInManagedObjectContext:(NSManagedObjectContext *)aContext;

	#pragma mark -
	
	/*!
	@abstract
	*/
	-(id) initAndInsertIntoManagedObjectContext:(NSManagedObjectContext *)aContext;

@end

#pragma mark

/*!
@category UXManagedObject (Copying)
@abstract
*/
@interface UXManagedObject (Copying)
	
	/*!
	@method copyToContext:andStore:
	@abstract Returns a copy of this object (including attributes and relationships)
	*/
	-(UXManagedObject *) copyToContext:(NSManagedObjectContext *)context andStore:(NSPersistentStore *)store;

@end