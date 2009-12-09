
/*!
@project	UXTableCatalog
@header		UXTableCatalogApplicationCoordinator.h
@copyright	(c) 2009, Semantap
@created    11/16/09
*/

#import <UXKit/UXKit.h>
#import <StorageKit/STKObjectStore.h>

/*!
@class UXTableCatalogApplicationCoordinator
@abstract
@discussion
*/
@interface UXTableCatalogApplicationCoordinator : NSObject  <STKStoreDelegate> {
	STKObjectStore *objectStore;
}

	@property (retain, nonatomic) STKObjectStore *objectStore;

	+(UXTableCatalogApplicationCoordinator *) sharedCoordinator;

@end
