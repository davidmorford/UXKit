
#import <TableKit/TVKTableItem.h>
#import <TableKit/TVKTableViewCell.h>

@implementation TVKTableItem

	@synthesize section;
	@synthesize cell;
	@synthesize reuseIdentifier;
	@synthesize representedObject;
	@synthesize height;
	@synthesize target;
	@synthesize action;

	#pragma mark Initializer

	-(id) initWithCell:(UITableViewCell *)tableCell {
		self = [self init];
		if (self != nil) {
			self.cell = tableCell;
			self.reuseIdentifier = tableCell.reuseIdentifier;
		}
		return (self);
	}

	-(id) initWithText:(NSString *)textValue image:(UIImage *)image  {
		UITableViewCell *tableCell = nil;
		static NSString * TVKUITableViewCellStyleDefaultID = @"TVKUITableViewCellStyleDefaultID";
		tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TVKUITableViewCellStyleDefaultID];
		tableCell.textLabel.text	= textValue;
		if (image) {
			[tableCell.imageView setImage:image];
		}
		return ([self initWithCell:tableCell]);
	}

	-(id) initWithText:(NSString *)textValue labelText:(NSString *)labelTextValue image:(UIImage *)image {
		UITableViewCell *tableCell = nil;
		static NSString * TVKUITableViewCellStyleValue1ID = @"TVKUITableViewCellStyleValue1ID";
		tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TVKUITableViewCellStyleValue1ID];
		tableCell.textLabel.text		= labelTextValue;
		tableCell.detailTextLabel.text	= textValue;
		if (image) {
			[tableCell.imageView setImage:image];
		}
		return ([self initWithCell:tableCell]);
	}

	-(id) initWithText:(NSString *)textValue captionText:(NSString *)captionTextValue image:(UIImage *)image {
		UITableViewCell *tableCell = nil;
		static NSString * TVKUITableViewCellStyleValue2ID = @"TVKUITableViewCellStyleValue2ID";
		tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:TVKUITableViewCellStyleValue2ID];
		tableCell.textLabel.text		= captionTextValue;
		tableCell.detailTextLabel.text	= textValue;
		if (image) {
			[tableCell.imageView setImage:image];
		}
		return ([self initWithCell:tableCell]);
	}

	-(id) initWithText:(NSString *)textValue subtitleText:(NSString *)subtitleValue image:(UIImage *)image {
		UITableViewCell *tableCell = nil;
		static NSString * TVKUITableViewCellStyleSubtitleID = @"TVKUITableViewCellStyleSubtitleID";
		tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TVKUITableViewCellStyleSubtitleID];
		tableCell.textLabel.text		= subtitleValue;
		tableCell.detailTextLabel.text	= textValue;
		if (image) {
			[tableCell.imageView setImage:image];
		}
		return ([self initWithCell:tableCell]);
	}


	#pragma mark TableCell

	-(UITableViewCell *) cell {
		if (cell == nil) {
			static NSString * TVKTableViewCellStyleDefaultID = @"TVKTableViewCellStyleDefaultID";
			TVKTableViewCell *tableCell = [[[TVKTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TVKTableViewCellStyleDefaultID] autorelease];
			cell = [tableCell retain];
		}
		return (cell);
	}

	-(void) setCell:(UITableViewCell *)tableCell {
		if (tableCell != cell) {
			[cell release];
			cell = [tableCell retain];
		}
	}

	#pragma mark Memory

	-(void) dealloc {
		action = nil;
		target = nil;
		[representedObject release]; representedObject = nil;
		[reuseIdentifier release]; reuseIdentifier = nil;
		[section release]; section = nil;
		[cell release]; cell = nil;
		[super dealloc];
	}

@end

#pragma mark -

@interface TVKTableGroup ()
	@property (nonatomic, retain, readwrite) NSMutableArray *rows;
@end

#pragma mark -

@implementation TVKTableGroup

	@dynamic objects;

	@synthesize rows;
	@synthesize name;
	@synthesize indexTitle;

	@synthesize sectionHeaderTitle;
	@synthesize sectionFooterTitle;
	@synthesize sectionHeaderView;
	@synthesize sectionFooterView;
	
	@synthesize isExpandable = expandable;

	#pragma mark Initializers

	-(id) init {
		self = [super init];
		if (self != nil) {
			self.rows = [[NSMutableArray alloc] init];
		}
		return self;
	}

	-(id) initWithName:(NSString *)sectionName  {
		self = [self init];
		if (self != nil) {
			self.name = sectionName;
		}
		return self;
	}

	-(id) initWithName:(NSString *)sectionName expandable:(BOOL)flag {
		self = [self initWithName:sectionName];
		if (self != nil) {
			self.isExpandable = flag;
		}
		return self;
	}

	-(id) initWithName:(NSString *)sectionName headerTitle:(NSString *)titleHeader footerTitle:(NSString *)titleFooter {
		self = [self initWithName:sectionName];
		if (self != nil) {
			self.sectionHeaderTitle = titleHeader;
			self.sectionFooterTitle = titleFooter;
		}
		return self;
	}


	#pragma mark -

	-(NSArray *) objects {
		if (rows) {
			return [rows valueForKeyPath:@"representedObject"];
		}
		return nil;
	}


	#pragma mark -

	-(id <TVKTableRow>) addRow:(id <TVKTableRow>)row {
		if (rows && row) {
			row.section = self;
			[rows addObject:row];
			return row;
		}
		return nil;
	}

	-(id <TVKTableRow>) insertRow:(id <TVKTableRow>)row atIndex:(NSUInteger)rowIndex {
		if (rows && row /*&& (rowIndex < [rows count])*/) {
			row.section = self;
			[rows insertObject:row atIndex:rowIndex];
			return row;
		}
		return nil;
	}

	-(id <TVKTableRow>) rowAtIndex:(NSUInteger)rowIndex {
		if (rows && (rowIndex < [rows count])) {
			return [rows objectAtIndex:rowIndex];
		}
		return nil;
	}

	-(NSUInteger) indexForRow:(id <TVKTableRow>)row {
		NSUInteger rowIndex = NSNotFound;
		if (row && rows) {
			rowIndex = [rows indexOfObject:row];
		}
		return rowIndex;
	}

	#pragma mark -

	-(void) removeRow:(id <TVKTableRow>)row {
		if (rows && row) {
			row.section = nil;
			[rows removeObject:row];
		}
	}

	-(void) removeRowAtIndex:(NSUInteger)rowIndex {
		id <TVKTableRow> row = [self rowAtIndex:rowIndex];
		[self removeRow:row];
	}



	#pragma mark -

	-(id <TVKTableRow>) itemWithCell:(UITableViewCell *)tableCell {
		id <TVKTableRow> item = [[[TVKTableItem alloc] initWithCell:tableCell] autorelease];
		return [self addRow:item];
	}


	#pragma mark -

	-(void) dealloc {
		[sectionHeaderView release]; sectionHeaderView = nil;
		[sectionFooterView release]; sectionFooterView = nil;
		[sectionHeaderTitle release]; sectionHeaderTitle = nil;
		[sectionFooterTitle release]; sectionFooterTitle = nil;
		[indexTitle release]; indexTitle = nil;
		[name release]; name = nil;
		[rows release]; rows = nil;
		[super dealloc];
	}

@end
