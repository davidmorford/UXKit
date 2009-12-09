
/*!
@project    UXTableCatalog
@header     TVKTableItem.h
@copyright  (c) 2009, Semantap
@created    11/26/09
*/

#import <UIKit/UIKit.h>
#import <TableKit/TVKTable.h>

/*!
@class TVKTableItem
@superclass NSObject <TVKTableRow>
@abstract
@discussion
*/
@interface TVKTableItem : NSObject <TVKTableRow> {
	id <TVKTableSection> section;
	UITableViewCell *cell;
	NSString *reuseIdentifier;
	id representedObject;
	CGFloat height;
	id target;
	SEL action;
}

	@property (nonatomic, assign) id <TVKTableSection> section;
	@property (nonatomic, retain) UITableViewCell *cell;
	@property (nonatomic, retain) NSString *reuseIdentifier;
	@property (nonatomic, retain) id representedObject;
	@property (nonatomic, assign) CGFloat height;
	@property (nonatomic, assign) id target;
	@property (nonatomic, assign) SEL action;

	#pragma mark -

	-(id) initWithCell:(UITableViewCell *)aCell;

	-(id) initWithText:(NSString *)textValue image:(UIImage *)image;
	-(id) initWithText:(NSString *)textValue labelText:(NSString *)labelTextValue image:(UIImage *)image;
	-(id) initWithText:(NSString *)textValue captionText:(NSString *)captionTextValue image:(UIImage *)image;
	-(id) initWithText:(NSString *)textValue subtitleText:(NSString *)subtitleValue image:(UIImage *)image;

@end

#pragma mark -

@interface TVKTableGroup : NSObject <TVKTableSection> {
	NSMutableArray *rows;
	NSString *name;
	NSString *indexTitle;
	NSString *sectionHeaderTitle;
	NSString *sectionFooterTitle;
	UIView *sectionHeaderView;
	UIView *sectionFooterView;
	BOOL expandable;
}

	@property (nonatomic, readonly) NSArray *objects;

	@property (nonatomic, retain, readonly) NSMutableArray *rows;
	@property (nonatomic, retain) NSString *name;
	@property (nonatomic, retain) NSString *indexTitle;

	@property (nonatomic, retain) NSString *sectionHeaderTitle;
	@property (nonatomic, retain) NSString *sectionFooterTitle;
	@property (nonatomic, retain) UIView *sectionHeaderView;
	@property (nonatomic, retain) UIView *sectionFooterView;

	@property (nonatomic, assign) BOOL isExpandable;

	#pragma mark -

	-(id) initWithName:(NSString *)sectionName;
	-(id) initWithName:(NSString *)sectionName expandable:(BOOL)flag;
	-(id) initWithName:(NSString *)sectionName headerTitle:(NSString *)titleHeader footerTitle:(NSString *)titleFooter;


	#pragma mark -
	
	-(id <TVKTableRow>) addRow:(id <TVKTableRow>)row;
	-(id <TVKTableRow>) insertRow:(id <TVKTableRow>)row atIndex:(NSUInteger)rowIndex;
	-(void) removeRow:(id <TVKTableRow>)row;
	
	-(id <TVKTableRow>) rowAtIndex:(NSUInteger)rowIndex;
	-(NSUInteger) indexForRow:(id <TVKTableRow>)row;
	
	-(id <TVKTableRow>) itemWithCell:(UITableViewCell *)tableCell;

@end