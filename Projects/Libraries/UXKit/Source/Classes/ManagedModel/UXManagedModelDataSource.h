
/*!
@project    UXKit
@header     UXManagedModelDataSource.h
@copyright  (c) Jonathan Wight
@changes	(c) Semantap
*/

#import <UXKit/UXGlobal.h>
#import <CoreData/CoreData.h>

/*!
@protocol UXManagedModelDataSource <NSObject>
@abstract
@discussion
*/
@protocol UXManagedModelDataSource <NSObject>

	@property (nonatomic, retain, readwrite) NSManagedObjectContext *managedObjectContext;
	@property (nonatomic, retain, readwrite) NSEntityDescription *entityDescription;
	@property (nonatomic, retain, readwrite) NSArray *sortDescriptors;
	@property (nonatomic, retain, readwrite) NSPredicate *predicate;
	@property (nonatomic, retain, readonly)  NSArray *items;

	-(BOOL) fetch:(NSError **)error;

@end

#pragma mark -

/*!
@class UXManagedModelDataSource
@abstract
@discussion
*/
@interface UXManagedModelDataSource : NSObject <UXManagedModelDataSource> {
	NSManagedObjectContext *managedObjectContext;
	NSEntityDescription *entityDescription;
	NSArray *sortDescriptors;
	NSPredicate *predicate;
	NSArray *items;
}

	@property (readwrite, nonatomic, retain) NSManagedObjectContext *managedObjectContext;
	@property (readwrite, nonatomic, retain) NSEntityDescription *entityDescription;
	@property (readwrite, nonatomic, retain) NSPredicate *predicate;
	@property (readonly, nonatomic, retain) NSArray *items;

	-(id) initWithManagedObjectContext:(NSManagedObjectContext *)aContext entityDescription:(NSEntityDescription *)aDescription;
	-(id) initWithManagedObjectContext:(NSManagedObjectContext *)aContext entityName:(NSString *)anEntityName;

	-(BOOL) fetch:(NSError **)error;

@end
