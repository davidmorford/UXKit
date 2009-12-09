
/*!
@project    UXTableCatalog
@header     TVKTableController.h
@copyright  (c) 2009 - Semantap
@created    11/26/09
*/

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import <ControllerKit/UXArrayController.h>
#import <TableKit/TVKTable.h>

@protocol TVKTableControllerDelegate;

#pragma mark -

typedef NSUInteger TVKTableEditingStyle;
enum {
	TVKTableEditingStyleNone,
	TVKTableEditingStyleInsertionRow,
	TVKTableEditingStyleToolbarButton
};

typedef NSUInteger TVKTableInsertRowPosition;
enum {
	TVKTableInsertRowPositionFirst,
	TVKTableInsertRowPositionLast
};

#pragma mark -

/*!
@class TVKTableController
@superclass UXArrayController <UITableViewDataSource, UITableViewDelegate>
@abstract
@discussion
*/
@interface TVKTableController : UXArrayController <UITableViewDataSource, UITableViewDelegate> {
	id <TVKTableControllerDelegate> delegate;
	Class sectionClass;
	Class rowClass;
	NSString *editingInsertLabel;
	NSString *deleteButtonTitle;
	NSInteger rowIndentationLevel;
	BOOL reorderable;
	BOOL resectionRows;
	BOOL editingIdentsRow;
	TVKTableEditingStyle editStyle;
	TVKTableInsertRowPosition insertRowPosition;
}

	@property (nonatomic, assign) id <TVKTableControllerDelegate> delegate;

	/*! 
	@abstract An array of objects that implement the TVKTableSection protocol.
	*/
	@property (nonatomic, retain, readonly) NSMutableArray *sections;

	@property (nonatomic, retain) NSString *editingInsertLabel;
	@property (nonatomic, retain) NSString *deleteButtonTitle;

	@property (nonatomic, assign) NSInteger rowIndentationLevel;
	@property (nonatomic, assign) BOOL reorderable;
	@property (nonatomic, assign) BOOL resectionRows;
	@property (nonatomic, assign) BOOL editingIdentsRow;

	@property (nonatomic, assign) TVKTableEditingStyle editStyle;
	@property (nonatomic, assign) TVKTableInsertRowPosition insertRowPosition;


	#pragma mark -	

	-(id) init;

	-(id) initWithDelegate:(id <TVKTableControllerDelegate>)controllerDelegate;


	#pragma mark Sections

	-(void) addSection:(id <TVKTableSection>)section;
	-(void) removeSection:(id <TVKTableSection>)section;

	-(id <TVKTableSection>) sectionWithName:(NSString *)name;
	-(id <TVKTableSection>) sectionAtIndex:(NSUInteger)sectionIndex;
	-(id <TVKTableSection>) sectionAtIndexPath:(NSIndexPath *)indexPath;

	-(NSUInteger) indexForSection:(id <TVKTableSection>)section;

@end

#pragma mark -

/*!
@category TVKTableController (ExpandableSections)
@abstract 
*/
@interface TVKTableController (ExpandableSections)

	-(void) addSection:(id <TVKTableSection>)section expansionRow:(id <TVKTableRow>)row;

@end

#pragma mark -

/*!
@protocol TVKTableControllerDelegate <NSObject>
@abstract
*/
@protocol TVKTableControllerDelegate <NSObject>

@optional
	-(UITableViewCell *) tableController:(TVKTableController *)controller editingInsertCellForIndexPath:(NSIndexPath *)indexPath;
	-(id <TVKTableRow>) tableController:(TVKTableController *)controller rowForInsertionInSection:(id <TVKTableSection>)section;	

	-(BOOL) tableController:(TVKTableController *)controller canInsertRowInSection:(id <TVKTableSection>)section;
	-(void) tableController:(TVKTableController *)controller didSelectRow:(id <TVKTableRow>)row;
	-(void) tableController:(TVKTableController *)controller willExpandSection:(id <TVKTableSection>)section;

	-(void) tableController:(TVKTableController *)controller accessoryButtonTappedForRow:(id <TVKTableRow>)row;

@end

#pragma mark -

/*!
@class TVKManagedTableController
@superclass TVKTableController <NSFetchedResultsControllerDelegate>
@abstract
@discussion
*/
@interface TVKManagedTableController :TVKTableController <NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	NSString *entityName;
	NSString *sortKeyName;
}

	@property (nonatomic, assign) NSManagedObjectContext *managedObjectContext;
	@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
	@property (nonatomic, retain) NSString *entityName;
	@property (nonatomic, retain) NSString *sortKeyName;

	#pragma mark Initializer

	-(id) initWithEntityName:(NSString *)anEntityName;

	#pragma mark API

	-(void) loadFetchedResults;

	-(void) insertNewObject;

@end

