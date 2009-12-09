
/*!
@project    UXTableCatalog
@header     UXArrayController.h
@copyright  (c) 2009 - Semantap
@created    11/26/09 – 5:53 AM
*/

#import <Foundation/Foundation.h>
#import <ControllerKit/UXObjectController.h>

/*!
@class UXArrayController
@superclass UXObjectController
@abstract
@discussion
*/
@interface UXArrayController : UXObjectController {
    NSArray *arrangedObjects;
	NSArray *sortDescriptors;
	NSPredicate *filterPredicate;
	BOOL clearsFilterPredicateOnInsertion;
}

	/*!
	@abstract array of all displayed objects (after sorting and potentially filtering)
	*/
	@property (retain, readonly) id arrangedObjects;

	@property (retain) NSArray *sortDescriptors;

	@property (retain) NSPredicate *filterPredicate;

	/*!
	@abstract Indicates whether the controller should nil out its filter predicate before 
	inserting (or adding) new objects. When set to yes, this eliminates the problem 
	of inserting a new object into the array that would otherwise immediately be 
	filtered out of the array of arranged objects.
	default: YES
	*/
	@property (assign) BOOL clearsFilterPredicateOnInsertion;
	

	#pragma mark -

	/*!
	@abstract can be used in bindings controlling the enabling of buttons, for example
	*/
	-(BOOL) canInsert;

	/*!
	@abstract overridden to add to the content objects and to the arranged objects if all 
	filters currently applied are matched
	*/
	-(void) addObject:(id)object;
	-(void) addObjects:(NSArray *)objects;

	/*!
	@abstract inserts into the content objects and the arranged objects (as specified 
	by index in the arranged objects) - will raise an exception if the object 
	does not match all filters currently applied
	*/
	-(void) insertObject:(id)object atArrangedObjectIndex:(NSUInteger)index;
	-(void) insertObjects:(NSArray *)objects atArrangedObjectIndexes:(NSIndexSet *)indexes;

	/*!
	@abstract removes from the content objects and the arranged objects (as specified by 
	index in the arranged objects)
	*/
	-(void) removeObjectAtArrangedObjectIndex:(NSUInteger)index;
	-(void) removeObjectsAtArrangedObjectIndexes:(NSIndexSet *)indexes;

	/*!
	@abstract removes from the content objects and the arranged objects (if currently contained)
	*/
	-(void) removeObject:(id)object;
	-(void) removeObjects:(NSArray *)objects;

@end
