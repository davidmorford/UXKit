
/*!
@project    UXKit
@header     UXManagedTableViewDataSource.h
@copyright	(c) 2009 Semantap
*/

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import <UXKit/UXGlobal.h>

/*!
@protocol UXManagedTableViewDataSource <NSObject>
@abstract 
@discussion
*/
@protocol UXManagedTableViewDataSource <NSObject>
	@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
	@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
	@property (nonatomic, retain) NSString *entityName;
@end


/*!
@class UXManagedTableViewDataSource
@superclass NSObject <UITableViewDataSource, NSFetchedResultsControllerDelegate>
@abstract
@discussion
*/
@interface UXManagedTableViewDataSource : NSObject <UITableViewDataSource, NSFetchedResultsControllerDelegate> {

}

@end
