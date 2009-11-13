
/*!
@project    UXKit
@header     UXObjectStoreRequest.h
@copyright  (c) 2009 - Semantap
@created    11/1/09 – david [at] semantap.com
*/

#import <UXKit/UXGlobal.h>
#import <CoreData/CoreData.h>

@class UXObjectStoreContext;

@protocol UXStoreQuery <NSObject>

@required
	@property (nonatomic, retain, readonly) UXObjectStoreContext *context;

@optional
	@property (nonatomic, retain, readonly) NSFetchRequest *fetchRequest;

	-(NSArray *) results;

@end

#pragma mark -

/*!
@class UXObjectStoreRequest
@superclass NSFetchRequest
@abstract
@discussion
*/
@interface UXObjectStoreQuery : NSObject <UXStoreQuery> {
	NSFetchRequest *fetchRequest;
	UXObjectStoreContext *context;
}

	@property (nonatomic, retain, readonly) NSFetchRequest *fetchRequest;
	@property (nonatomic, retain, readonly) UXObjectStoreContext *context;

	#pragma mark -

	+(UXObjectStoreQuery *) queryWithFetchRequest:(NSFetchRequest *)request context:(UXObjectStoreContext *)context;
	+(UXObjectStoreQuery *) queryWithEntityName:(NSString *)entityName context:(UXObjectStoreContext *)context;

	#pragma mark -

	-(id)  initWithFetchRequest:(NSFetchRequest *)request context:(UXObjectStoreContext *)context;
	
	#pragma mark -
	
	-(void) appendPredicate:(NSPredicate *)aPredicate withCompoundType:(NSCompoundPredicateType)type;

	#pragma mark -
	
	-(NSArray *) results;

@end