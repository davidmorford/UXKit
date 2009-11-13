
/*!
@project    UXKit
@header     UXManagedObjectEditorController.h
@copyright  (c) 2009 - Semantap
*/

#import <UXKit/UXKit.h>
#import <CoreData/CoreData.h>

/*!
@class UXManagedObjectEditorController
@superclass UITableViewController
@abstract
@discussion
*/
@interface UXManagedObjectEditorController : UITableViewController {
	NSManagedObject *object;
	NSString *keyPath;
	NSString *label;
}

	@property (nonatomic, retain) NSManagedObject *object;
	@property (nonatomic, retain) NSString *keyPath;
	@property (nonatomic, retain) NSString *label;

	#pragma mark Actions

	-(void) save;
	-(void) cancel;

@end
