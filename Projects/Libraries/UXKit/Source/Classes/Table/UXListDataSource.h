
/*!
@project	UXKit
@header     UXTableHeaderView.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXTableViewDataSource.h>

/*!
@class UXListDataSource
@superclass UXTableViewDataSource
@abstract
@discussion
*/
@interface UXListDataSource : UXTableViewDataSource {
	NSMutableArray *_items;
}

	@property (nonatomic, retain) NSMutableArray *items;

	+(UXListDataSource *) dataSourceWithObjects:(id)firstObject, ...;
	+(UXListDataSource *) dataSourceWithItems:(NSMutableArray *)anItemList;

	-(id) initWithItems:(NSArray *)anItemList;
	
	-(NSIndexPath *) indexPathOfItemWithUserInfo:(id)userInfo;

@end

#pragma mark -

/*!
@class UXSectionedDataSource
@superclass UXTableViewDataSource
@abstract
@discussion
*/
@interface UXSectionedDataSource : UXTableViewDataSource {
	NSMutableArray *_sections;
	NSMutableArray *_items;
}

	@property (nonatomic, retain) NSMutableArray *items;
	@property (nonatomic, retain) NSMutableArray *sections;

	/*!
	@abstract Objects should be in this format:
	@"section title", item, item, @"section title", item, item, ...
	*/
	+(UXSectionedDataSource *) dataSourceWithObjects:(id)object, ...;

	/*!
	@abstract Objects should be in this format:
	@"section title", arrayOfItems, @"section title", arrayOfItems, ...
	*/
	+(UXSectionedDataSource *) dataSourceWithArrays:(id)object, ...;

	+(UXSectionedDataSource *) dataSourceWithItems:(NSArray *)items sections:(NSArray *)sections;

	-(id) initWithItems:(NSArray *)items sections:(NSArray *)sections;

	-(NSIndexPath *) indexPathOfItemWithUserInfo:(id)userInfo;

	-(void) removeItemAtIndexPath:(NSIndexPath *)anIndexPath;
	-(BOOL) removeItemAtIndexPath:(NSIndexPath *)anIndexPath andSectionIfEmpty:(BOOL)flag;

@end
