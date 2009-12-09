
/*!
@project    UXTableCatalog
@header     UXObjectController.h
@copyright  (c) 2009 - Semantap
@created    11/26/09
*/

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <ControllerKit/UXController.h>

/*!
@class UXObjectController
@superclass NSObject <UXController>
@abstract
@discussion
*/
@interface UXObjectController : NSObject <UXController> {
	BOOL editing;
	BOOL editable;
	BOOL hasLoadedData;
	Class objectClass;
    id content;
}

	@property (retain) id content;

	/*!
	@abstract sets the object class used when creating new objects. Default is NSMutableDictionary
	*/
	@property (assign) Class objectClass;
	@property (assign) BOOL isEditing;
	@property (assign) BOOL isEditable;


	#pragma mark -

	/*!
	@abstract The designated initializer.
	*/
	-(id) initWithContent:(id)contentObject;

	/*! 
	@abstract Create a new object when adding/inserting objects (default implementation
	assumes the object class has a standard init method without arguments) - the returned object should not be autoreleased
	*/
	-(id) newObject;

@end

#pragma mark -

/*!
@class UXManagedObjectController
@superclass UXObjectController
@abstract
@discussion
*/
@interface UXManagedObjectController : UXObjectController {
	NSManagedObjectContext *managedObjectContext;
	NSString *entityName;
	NSPredicate *fetchPredicate;
	NSFetchRequest *defaultFetchRequest;
}

	@property (assign) NSManagedObjectContext *managedObjectContext;
	@property (retain) NSString *entityName;
	@property (retain) NSFetchRequest *defaultFetchRequest;
	@property (retain) NSPredicate *fetchPredicate;

	#pragma mark -

	/*!
	@abstract subclasses can override this method to customize the fetch request, for example to specify 
	fetch limits (passing nil for the fetch request will result in the default fetch request to be used; 
	this method will never be invoked with a nil fetch request from within the standard Cocoa frameworks) - 
	the merge flag determines whether the controller replaces the entire content with the fetch result or 
	merges the existing content with the fetch result
	*/
	-(BOOL) fetchWithRequest:(NSFetchRequest *)fetchRequest merge:(BOOL)merge error:(NSError **)error;

	-(void) fetch;

@end
