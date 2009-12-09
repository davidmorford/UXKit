
/*!
@project    UXTableCatalog
@header     TVKTable.h
@copyright  (c) 2009, Semantap
@created    11/26/09
*/

#import <UIKit/UIKit.h>

@class NSArray, NSString, UITableViewCell;
@protocol TVKTableRow;

/*!
@protocol TVKTableSection <NSObject>
@abstract
*/
@protocol TVKTableSection <NSObject>

	/*! storage for rows */
	@property (nonatomic, retain, readonly) NSMutableArray *rows;

	/*! Name of the section */
	@property (nonatomic, retain) NSString *name;

	/*! Title of the section (used when displaying the index) */
	@property (nonatomic, retain) NSString *indexTitle;

	/*! array of representedObject in TVKTableRow for section. */
	@property (nonatomic, readonly) NSArray *objects;

	@property (nonatomic, retain) NSString *sectionHeaderTitle;
	@property (nonatomic, retain) NSString *sectionFooterTitle;
	@property (nonatomic, retain) UIView *sectionHeaderView;
	@property (nonatomic, retain) UIView *sectionFooterView;

	@property (nonatomic, assign) BOOL isExpandable; 

@optional

	-(id <TVKTableRow>) addRow:(id <TVKTableRow>)row;
	-(id <TVKTableRow>) insertRow:(id <TVKTableRow>)row atIndex:(NSUInteger)rowIndex;
	-(void) removeRow:(id <TVKTableRow>)row;

	-(id <TVKTableRow>) rowAtIndex:(NSUInteger)rowIndex;
	-(NSUInteger) indexForRow:(id <TVKTableRow>)row;

	-(id <TVKTableRow>) itemWithCell:(UITableViewCell *)tableCell;

@end

#pragma mark -

/*!
@protocol TVKTableRow <NSObject>
@abstract
*/
@protocol TVKTableRow <NSObject>

	@property (nonatomic, assign) id <TVKTableSection> section;
	@property (nonatomic, retain) UITableViewCell *cell;
	@property (nonatomic, assign) CGFloat height;
	@property (nonatomic, retain) NSString *reuseIdentifier;
	@property (nonatomic, retain) id representedObject;
	@property (nonatomic, assign) id target;
	@property (nonatomic, assign) SEL action;

@end

#pragma mark -

extern NSString * const TVKTableSectionNameKey;
extern NSString * const TVKTableSectionIndexTitleKey;
extern NSString * const TVKTableSectionRowsKey;
extern NSString * const TVKTableSectionObjectsKey;

extern NSString * const TVKTableRowSectionKey;
extern NSString * const TVKTableRowCellKey;
extern NSString * const TVKTableRowReuseIdentifierKey;
extern NSString * const TVKTableRowRepresentedObjectKey;
