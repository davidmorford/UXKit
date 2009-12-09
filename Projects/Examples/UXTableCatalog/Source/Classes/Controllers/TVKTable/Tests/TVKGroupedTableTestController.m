
#import "TVKGroupedTableTestController.h"
#import <TableKit/TVKTableController.h>
#import <TableKit/TVKTableItem.h>
#import <TableKit/TVKTableViewCell.h>

@implementation TVKGroupedTableTestController

	#pragma mark Initializer

	-(id) init {
		self = [super initWithTableViewStyle:UITableViewStyleGrouped];
		if (self) {
		}
		return self;
	}

	-(void) loadView {
		[super loadView];
		self.title = @"Grouped";
		
		UIBarButtonItem *newSectionButton			= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(addSection)];
		UIBarButtonItem *flexibleSpace				= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		UIBarButtonItem *newExpandingSectionButton	= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(insertExpandableSection)];
		UIBarButtonItem *flexibleSpace2				= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		UIBarButtonItem *newRowButton				= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addRow)];
		[self setToolbarItems:[NSArray arrayWithObjects:newSectionButton, flexibleSpace, newExpandingSectionButton, flexibleSpace2, newRowButton, nil]];
		
		[newSectionButton release];
		[flexibleSpace2 release];
		[newExpandingSectionButton release];
		[flexibleSpace release];
		[newRowButton release];
		
		self.navigationController.toolbarHidden		= FALSE;
		
		TVKTableGroup *section = nil;
		section			= [[TVKTableGroup alloc] init];
		section.name	= @"Root";
		[self.tableController addSection:section];
		[section release];
	}


	#pragma mark <TVKTableControllerDelegate>

	-(void) tableController:(TVKTableController *)controller didSelectRow:(id <TVKTableRow>)row {
		NSLog(@"didSelectRow: %@", row);
		if (row.target && row.target == self && row.action == @selector(expandSection:)) {
			[self performSelector:row.action withObject:[row section]];
		}
	}

	-(void) tableController:(TVKTableController *)controller willExpandSection:(id <TVKTableSection>)section {
		NSUInteger sectionIndex = [controller indexForSection:section];	
		NSUInteger insertCount = 4;
		
		if ([section.rows count] == 1) {
			NSMutableArray *insertIndexPaths = [NSMutableArray array];
			for (NSUInteger i = 0; i < insertCount; i++) {
				TVKTableItem *row;
				row = [[TVKTableItem alloc] initWithText:@"Default Style" image:nil];
				row.height = 44;
				[section addRow:row];
				NSUInteger rowIndex = [section indexForRow:row];
				[insertIndexPaths addObject:[NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex]];
				[row release]; row = nil;
			}
			/*[self.tableView reloadSections:[NSIndexPath indexPathWithIndex:[self.tableController indexForSection:section]] 
						  withRowAnimation:UITableViewRowAnimationBottom];*/
			
			[self.tableView beginUpdates];
			[self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationTop];
			[self.tableView endUpdates];
		}
		else {
			NSArray *sectionRows = [NSArray arrayWithArray:section.rows];
			for (id <TVKTableRow> row in sectionRows) {
				if (row == [sectionRows objectAtIndex:0]) {
					continue;
				}
				else {
					NSUInteger rowIndex = [section indexForRow:row];
					[section removeRow:row];
					[self.tableView beginUpdates];
					[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex]]  
										  withRowAnimation:UITableViewRowAnimationTop];
					[self.tableView endUpdates];
				}
			}
		}
	}



	#pragma mark -

	-(void) addRow {
		TVKTableGroup *rootSection = [self.tableController sectionWithName:@"Root"];  
		TVKTableViewContentCell *contentCell = [[TVKTableViewContentCell alloc] initWithContentViewClass:[TVKTableViewCellGradientContentView class] 
																									text:@"Super Application"
																								subtitle:@"Maximus Decimus Meridiaus is the ruler of the empire. Strength and honor you Roman hellots." 
																								   image:UXIMAGE(@"bundle://UXTableCatalog.png")];

		TVKTableItem *row = [[TVKTableItem alloc] initWithCell:contentCell];
		row.height = 88;
		[rootSection addRow:row];
		[contentCell release]; contentCell = nil;
		[row release]; row = nil;
		[self.tableView reloadData];
		
		/*for (TVKTableSection *section in [self.tableViewDataSource sections]) {
			NSLog(@"%@", section);
			NSLog(@"%@", section.rows);
		}*/
	}

	-(void) insertExpandableSection {
		TVKTableGroup *section = [[TVKTableGroup alloc] initWithName:[NSString stringWithFormat:@"Section/Expandable/%u", [self.tableController.sections count]]];
		section.sectionHeaderTitle = @"Expandable Section";
		TVKTableItem *row = [[TVKTableItem alloc] initWithText:@"Settings" image:UXIMAGE(@"bundle://Settings.png")];
		[self.tableController addSection:section expansionRow:row];
		[row release]; row = nil;
		[section release];
		[self.tableView reloadData];
	}

	#pragma mark -
	
	-(void) addSection {
		TVKTableGroup *section = nil;
		section			= [[TVKTableGroup alloc] init];
		section.name	= [NSString stringWithFormat:@"Section/%u", [self.tableController.sections count] + 1];
		section.sectionHeaderTitle = @"Header";
		section.sectionFooterTitle = @"Footer";
		[self.tableController addSection:section];
		[section release];
		
		section = [self.tableController sectionWithName:[NSString stringWithFormat:@"Section/%u", [self.tableController.sections count]]];
		
		TVKTableItem *row;

		row = [[TVKTableItem alloc] initWithText:@"Default Style" image:nil];
		row.height = 44;
		[section addRow:row];
		[row release]; row = nil;

		row = [[TVKTableItem alloc] initWithText:@"Default Style With Image" image:UXIMAGE(@"bundle://Settings.png")];
		row.height = 44;
		[section addRow:row];
		[row release]; row = nil;

		row = [[TVKTableItem alloc] initWithText:@"Value 1" labelText:@"Cell Style" image:nil];
		row.height = 44;
		[section addRow:row];
		[row release]; row = nil;

		row = [[TVKTableItem alloc] initWithText:@"Value 1" labelText:@"Cell Style" image:UXIMAGE(@"bundle://Settings.png")];
		row.height = 44;
		[section addRow:row];
		[row release]; row = nil;

		row = [[TVKTableItem alloc] initWithText:@"Value 2" captionText:@"Cell Style" image:nil];
		row.height = 44;
		[section addRow:row];
		[row release]; row = nil;

		row = [[TVKTableItem alloc] initWithText:@"Value 2" captionText:@"Cell Style" image:UXIMAGE(@"bundle://Settings.png")];
		row.height = 44;
		[section addRow:row];
		[row release]; row = nil;

		row = [[TVKTableItem alloc] initWithText:@"Subtitle" subtitleText:@"Cell Style" image:nil];
		row.height = 44;
		[section addRow:row];
		[row release]; row = nil;

		row = [[TVKTableItem alloc] initWithText:@"Subtitle" subtitleText:@"Title" image:UXIMAGE(@"bundle://Camera.png")];
		row.height = 44;
		[section addRow:row];
		[row release]; row = nil;

		row = [[TVKTableItem alloc] initWithText:@"Subtitle" subtitleText:@"Title" image:UXIMAGE(@"bundle://UXTableCatalog.png")];
		row.height = 57;
		[section addRow:row];
		[row release]; row = nil;

		row = [[TVKTableItem alloc] initWithText:@"Subtitle" subtitleText:@"Title" image:UXIMAGE(@"bundle://UXTableCatalog.png")];
		row.height = 64;
		[section addRow:row];
		[row release]; row = nil;
		
		[self.tableView reloadData];
		/*[self.tableView reloadSections:[NSIndexPath indexPathWithIndex:[self.tableController indexForSection:section]] 
					  withRowAnimation:UITableViewRowAnimationNone];*/
	}


	#pragma mark Destructor

	-(void) dealloc {
		[super dealloc];
	}

@end

#pragma mark -

@implementation TVKGroupedStyledTableTestController
	
	-(id) init {
		return [self initWithTableViewStyle:UITableViewStyleGrouped];
	}


	#pragma mark UIViewController

	-(void) loadView {
		[super loadView];
		self.title = @"Grouped Styled";
//		
//		//UIBarButtonItem *newSectionButton	= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSection)];
//		UIBarButtonItem *flexibleSpace		= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//		UIBarButtonItem *newRowButton		= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addRow)];
//		
//		[self setToolbarItems:[NSArray arrayWithObjects:/*newSectionButton, */flexibleSpace, newRowButton, nil]];
//		[flexibleSpace release];
//		[newRowButton release];
		
		//self.navigationController.toolbarHidden		= FALSE;

		TVKTableGroup *section = nil;
		section = [[TVKTableGroup alloc] init];
		section.name = @"Root";
		section.sectionHeaderTitle = @"";
		section.sectionFooterTitle = @"";
		[self.tableController addSection:section];
		[section release];
	}


	#pragma mark -

	-(void) addRow {
		TVKTableGroup *rootSection = [self.tableController sectionWithName:@"Root"];
		TVKTableItem *row;
		TVKTableViewContentCell *contentCell = [[TVKTableViewContentCell alloc] initWithContentViewClass:[TVKTableViewCellGradientContentView class] 
																									text:@"Super Duper App"
																								subtitle:@"The best iPhone application ever!" 
																								   image:UXIMAGE(@"bundle://UXTableCatalog.png")];
		row = [[TVKTableItem alloc] initWithCell:contentCell];
		row.height = 72;
		[contentCell release];
		[rootSection addRow:row];
		[row release]; row = nil;
		[self.tableView reloadData];
	}


	-(id <TVKTableRow>) tableController:(TVKTableController *)controller rowForInsertionInSection:(id <TVKTableSection>)section {
		TVKTableItem *row;
		TVKTableViewContentCell *contentCell = [[TVKTableViewContentCell alloc] initWithContentViewClass:[TVKTableViewCellGradientContentView class] 
																									text:@"Super Duper App"
																								subtitle:@"The best iPhone application ever!" 
																								   image:UXIMAGE(@"bundle://UXTableCatalog.png")];
		row = [[TVKTableItem alloc] initWithCell:contentCell];
		row.height = 72;
		[contentCell release];

		id <TVKTableRow> addedRow = [section addRow:row];
		[row release]; row = nil;
		return addedRow;
	}

	#pragma mark Destructor

	-(void) dealloc {
		[super dealloc];
	}

@end

