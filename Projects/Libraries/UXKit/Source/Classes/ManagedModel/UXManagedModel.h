
/*!
@project    UXKit
@header     UXManagedModel.h
@copyright	(c) 2009 Semantap
*/

#import <UXKit/UXGlobal.h>
#import <CoreData/NSManagedObjectModel.h>

/*!
@class UXManagedModel 
@superclass NSObject
@abstract 
@discussion 
*/
@interface UXManagedModel : NSManagedObjectModel {
	NSString *name;
	NSString *defaultConfiguration;
	NSURL *fileURL;
	BOOL hasContext;
	BOOL notificationEnabled;
}

	@property (copy) NSString *name;
	@property (copy) NSURL *fileURL;
	@property (copy) NSString *defaultConfiguration;
	
	/*!
	@abstract Has the object model has been added to an managed object context?
	*/
	@property BOOL hasContext;
	
	/*!
	@abstract
	*/
	@property BOOL notificationEnabled;
	
	#pragma mark Constructor
	
	/*!
	@abstract
	*/
	+(UXManagedModel *) managedObjectModelWithName:(NSString *)modelName;
	
	#pragma mark Initializers
	
	/*!
	@abstract
	*/
	-(id) init;

@end
