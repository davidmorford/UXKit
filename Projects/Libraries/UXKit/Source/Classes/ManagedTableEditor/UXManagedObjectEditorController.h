
/*!
@project    UXKit
@header     UXManagedObjectEditorController.h
@copyright  (c) 2009 - Semantap
*/

#import <UXKit/UXKit.h>
#import <CoreData/CoreData.h>

/*!
@class UXManagedObjectEditorController
@superclass UXViewController <UITableViewDataSource, UITableViewDelegate>
@abstract
@discussion
*/
@interface UXManagedObjectEditorController : UXViewController <UITableViewDataSource, UITableViewDelegate> {
	NSManagedObject *object;
	NSString *keyPath;
}

	@property (nonatomic, retain) NSManagedObject *object;
	@property (nonatomic, retain) NSString *keyPath;

	#pragma mark Actions

	-(void) save;
	-(void) cancel;

@end
