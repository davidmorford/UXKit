
#import <TableKit/TVKTableController.h>
#import <TableKit/TVKTableItem.h>

@interface TVKTableController ()
@end

#pragma mark -

@implementation TVKTableController

	@synthesize delegate;

	@synthesize editingInsertLabel;
	@synthesize deleteButtonTitle;

	@synthesize rowIndentationLevel;
	@synthesize reorderable;
	@synthesize resectionRows;
	@synthesize editingIdentsRow;

	@synthesize editStyle;
	@synthesize insertRowPosition;


	#pragma mark Initializer

	-(id) init {
		self = [super init];
		if (self != nil) {
			self.isEditing				= FALSE;
			self.isEditable				= TRUE;
			self.editingInsertLabel		= @"Add...";
			self.deleteButtonTitle		= nil;
			self.editingIdentsRow		= TRUE;
			self.reorderable			= TRUE;
			self.resectionRows			= FALSE;
			self.rowIndentationLevel	= 0;
			sectionClass				= [TVKTableGroup class];
			rowClass					= [TVKTableItem class];
		}
		return self;
	}
	
	-(id) initWithDelegate:(id <TVKTableControllerDelegate>)controllerDelegate {
		self = [self init];
		if (self != nil) {
			self.delegate = controllerDelegate;
		}
		return self;
	}


	#pragma mark Sections

	-(NSMutableArray *) sections {
		return [self content];
	}


	#pragma mark Section

	-(void) addSection:(id <TVKTableSection>)section {
		[self.sections addObject:section];
	}

	-(void) addSection:(id <TVKTableSection>)section expansionRow:(id <TVKTableRow>)row {
		section.isExpandable = TRUE;
		[self addSection:section];
		row.target			= self;
		row.action			= @selector(expandSection:);
		[section addRow:row];
	}

	-(void) removeSection:(id <TVKTableSection>)section {
		[self.sections removeObject:section];
	}

	-(id <TVKTableSection>) sectionWithName:(NSString *)name {
		id <TVKTableSection> sectionWithName = nil;
		if (self.sections) {
			for (id <TVKTableSection> section in self.sections) {
				if ([section.name isEqualToString:name]) {
					sectionWithName = section;
				}
			}
		}
		return sectionWithName;
	}

	-(id <TVKTableSection>) sectionAtIndex:(NSUInteger)sectionIndex {
		id <TVKTableSection> section = nil;
		if ([self.sections count] > 0) {
			section = [self.sections objectAtIndex:sectionIndex];
		}
		return section;
	}

	-(id <TVKTableSection>) sectionAtIndexPath:(NSIndexPath *)indexPath {
		id <TVKTableSection> section = nil;
		if ([self.sections count] > 0) {
			section = [self.sections objectAtIndex:indexPath.section];
		}
		return (section);
	}
	
	-(NSUInteger) indexForSection:(id <TVKTableSection>)section {
		NSUInteger sectionIndex = 0;
		if (self.sections) {
			sectionIndex = [self.sections indexOfObject:section];
		}
		return sectionIndex;
	}

	-(void) expandSection:(id <TVKTableSection>)section {
		if (self.delegate && [self.delegate respondsToSelector:@selector(tableController:willExpandSection:)]) {
			[self.delegate tableController:self willExpandSection:section];
		}
	}


	#pragma mark
	#pragma mark <UITableViewDataSource>
	#pragma mark

	-(NSInteger) numberOfSectionsInTableView:(UITableView *)table {
		NSUInteger sectionCount = MAX([self.sections count], 1);
		return sectionCount;
	}

	-(NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)sectionIndex {
		NSUInteger rowCount;
		if (sectionIndex >= [self.sections count]) {
			return 0;
		}
		id <TVKTableSection> section = [self sectionAtIndex:sectionIndex];
		rowCount = [section.rows count];
		if (self.isEditing) {
			rowCount++;
		}
		return rowCount;
	}

	-(UITableViewCell *) tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
		UITableViewCell *cell;
		id <TVKTableSection> section = [self sectionAtIndex:indexPath.section];
		if (section && section.rows && (indexPath.row < [section.rows count])) {
			id <TVKTableRow> row = [section rowAtIndex:indexPath.row];
			/*
			cell = (UITableViewCell *)[table dequeueReusableCellWithIdentifier:row.reuseIdentifier];
			if (cell == nil) {
			}
			*/
			cell = row.cell;
			if (cell == nil) {
			
			}
		}
		else {
			if ([self.delegate respondsToSelector:@selector(tableController:editingInsertCellForIndexPath:)] == TRUE) {
				cell = [self.delegate tableController:self editingInsertCellForIndexPath:indexPath];
			}
			else {
				static NSString * TVKTableControllerInsertionCellIdentifier = @"TVKTableControllerInsertionCellID";
				cell = (UITableViewCell *)[table dequeueReusableCellWithIdentifier:TVKTableControllerInsertionCellIdentifier];
				if (cell == nil) {
					cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TVKTableControllerInsertionCellIdentifier] autorelease];
				}
				cell.textLabel.text = self.editingInsertLabel;
			}
		}
		return cell;
	}


	#pragma mark Table Header/Footer

	-(NSString *) tableView:(UITableView *)table titleForHeaderInSection:(NSInteger)sectionIndex {
		if (sectionIndex >= [self.sections count]) {
			return nil;
		}
		id <TVKTableSection> section = [self.sections objectAtIndex:sectionIndex];
		return section.sectionHeaderTitle;
	}

	-(NSString *) tableView:(UITableView *)table titleForFooterInSection:(NSInteger)sectionIndex {
		if (sectionIndex >= [self.sections count]) {
			return nil;
		}
		id <TVKTableSection> section = [self.sections objectAtIndex:sectionIndex];
		return section.sectionFooterTitle;
	}


	#pragma mark Editing

	-(BOOL) tableView:(UITableView *)table canEditRowAtIndexPath:(NSIndexPath *)indexPath {
		id <TVKTableSection> section = [self sectionAtIndex:indexPath.section];
		if (self.isEditable && (indexPath.row <= [section.rows count])) {
			return TRUE;
		} 
		return FALSE;
	}


	#pragma mark Editing : Insert / Delete

	-(void) tableView:(UITableView *)table commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
		if (editingStyle == UITableViewCellEditingStyleDelete) {
			id <TVKTableSection> section = [self sectionAtIndex:indexPath.section];
			id <TVKTableRow> row = [section rowAtIndex:indexPath.row];
			[section removeRow:row];
			[table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
							 withRowAnimation:UITableViewRowAnimationFade];
		}
		else if (editingStyle == UITableViewCellEditingStyleInsert) {
			id <TVKTableSection> section = [self sectionAtIndex:indexPath.section];
			if ([self.delegate respondsToSelector:@selector(tableController:rowForInsertionInSection:)] == TRUE) {
				id <TVKTableRow> newRow = [self.delegate tableController:self rowForInsertionInSection:section];
				if (newRow) {
					[table insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
					if ([self.sections count] <= 1) {
						[table scrollToRowAtIndexPath:indexPath 
									 atScrollPosition:UITableViewScrollPositionTop 
											 animated:TRUE];
					}
				}
			}
			else {
			}
		}
	}


	#pragma mark Editing : Moving / Reordering

	-(BOOL) tableView:(UITableView *)table canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
		NSUInteger numberOfRowsInSection = [[self sectionAtIndex:indexPath.section].rows count];
		if (self.reorderable && (indexPath.row < numberOfRowsInSection)) {
			return TRUE;
		}
		return FALSE;
	}

	-(void) tableView:(UITableView *)table moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
		if (self.reorderable) {
			id <TVKTableSection> sourceSection = [self sectionAtIndex:sourceIndexPath.section];
			id <TVKTableSection> targetSection = [self sectionAtIndex:destinationIndexPath.section];
			
			id <TVKTableRow> sourceRow = [[sourceSection rowAtIndex:sourceIndexPath.row] retain];
			[sourceSection removeRow:sourceRow];
			[targetSection insertRow:sourceRow atIndex:destinationIndexPath.row];
			[sourceRow release];
		}
	}


	#pragma mark Index

	-(NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView {
		return nil;
	}

	-(NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)sectionIndex {
		return 0;
	}


	#pragma mark
	#pragma mark <UITableViewDelegate>
	#pragma mark

	-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	}


	#pragma mark Variable Height

	-(CGFloat) tableView:(UITableView *)table heightForRowAtIndexPath:(NSIndexPath *)indexPath {
		CGFloat rowHeight = 44.0;
		id <TVKTableSection> section = [self sectionAtIndex:indexPath.section];
		id <TVKTableRow> row = [section rowAtIndex:indexPath.row];
		if (section && row) {
			if (row.height <= 0.0) {
				row.height = row.cell.frame.size.height;
			}
			rowHeight = row.height;
		}
		return rowHeight;
	}

	-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex {
		CGFloat headerHeight = 24.0;
		id <TVKTableSection> section = [self sectionAtIndex:sectionIndex];
		if (section && section.sectionHeaderView) {
			headerHeight = section.sectionHeaderView.frame.size.height;
		}
		return headerHeight;
	}

	-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)sectionIndex {
		CGFloat footerHeight = 24.0;
		id <TVKTableSection> section = [self sectionAtIndex:sectionIndex];
		if (section  && section.sectionFooterView) {
			footerHeight = section.sectionFooterView.frame.size.height;
		}
		return footerHeight;
	}


	#pragma mark Section Header / Footer

	/*! 
	@abstract custom view for header. will be adjusted to default or specified header height
	Views are preferred over title should you decide to provide both
	*/
	-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex {
		id <TVKTableSection> section = [self sectionAtIndex:sectionIndex];
		if (section && section.sectionHeaderView) {
			return section.sectionHeaderView;
		}
		return nil;
	}

	/*! 
	@abstract custom view for footer. will be adjusted to default or specified footer height
	*/
	-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)sectionIndex {
		id <TVKTableSection> section = [self sectionAtIndex:sectionIndex];
		if (section && section.sectionFooterView) {
			return section.sectionFooterView;
		}
		return nil;
	}


	#pragma mark Accessories

	-(void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath  {
		if (self.delegate && [self.delegate respondsToSelector:@selector(tableController:accessoryButtonTappedForRow:)]) {
			id <TVKTableRow> row = [[self sectionAtIndex:indexPath.section] rowAtIndex:indexPath.row];
			[self.delegate tableController:self accessoryButtonTappedForRow:row];
		}
	}


	#pragma mark Selection

	/*! 
	@abstract Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
	*/
	-(NSIndexPath *) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
		id <TVKTableSection> section = [self sectionAtIndex:indexPath.section];
		id <TVKTableRow> row = [section rowAtIndex:indexPath.row];
		if (section && row) {
			return indexPath;
		}
		return nil;
	}

	/*!
	@abstract Called after the user changes the selection.
	*/
	-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
		/*
		if (editMenuVisible) {
			return;
		}
		*/
		/*if (self.target) {
			id <TVKTableSection> section	= [self.sections objectAtIndex:indexPath.section];
			id <TVKTableRow> row			= [section.rows objectAtIndex:indexPath.row];
			if (row.selectionAction && [self.target respondsToSelector:row.selectionAction]) {
				[self.target performSelector:row.selectionAction withObject:row];
			}
		}*/
		if (self.delegate && [self.delegate respondsToSelector:@selector(tableController:didSelectRow:)]) {
			id <TVKTableRow> row = [[self sectionAtIndex:indexPath.section] rowAtIndex:indexPath.row];
			[self.delegate tableController:self 
							  didSelectRow:row];
			if (row.section.isExpandable) {
				[self expandSection:row.section];
			}
		}

		[tableView deselectRowAtIndexPath:indexPath animated:TRUE];
	}

	/*! 
	@version 3.0
	*/
	-(NSIndexPath *) tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
		id <TVKTableSection> section = [self sectionAtIndex:indexPath.section];
		id <TVKTableRow> row = [section rowAtIndex:indexPath.row];
		if (section && row) {
			return indexPath;
		}
		return nil;
	}

	/*! 
	@version 3.0
	*/
	-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
		
	}


	#pragma mark Editing

	/*!
	@abstract Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, 
	all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property 
	set to YES.
	*/
	-(UITableViewCellEditingStyle) tableView:(UITableView *)table editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
		// No editing style if not editing or the index path is nil.
		/*if ((self.isEditing == FALSE) || !indexPath) {
			return UITableViewCellEditingStyleNone;
		}*/
		
		id <TVKTableSection> section = [self sectionAtIndex:indexPath.section];
		if (section) {
			if (indexPath.row >= [section.rows count]) {
				return UITableViewCellEditingStyleInsert;
			}
			else {
				return UITableViewCellEditingStyleDelete;
				//return ([section rowWithIndexPath:indexPath].editingStyle);
			}
		}
		return UITableViewCellEditingStyleNone;
	}

	/*! 
	@version 3.0
	*/
	-(NSString *) tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
		if (self.deleteButtonTitle != nil) {
			return self.deleteButtonTitle;
		}
		return NSLocalizedString(@"Remove", @"Title for Table View Delete Confirmation Button.");
	}

	/*!
	@abstract Controls whether the background is indented while editing.  If not implemented, the default is YES.  
	This is unrelated to the indentation level below.  This method only applies to grouped style table views.
	*/
	-(BOOL) tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
		if (tableView.style == UITableViewStyleGrouped && self.editingIdentsRow) {
			return TRUE;
		}
		return FALSE;
	}

	/*!
	@abstract The willBegin/didEnd methods are called whenever the 'editing' property is automatically 
	changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
	*/
	-(void) tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	
	}

	-(void) tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	
	}


	#pragma mark Moving / Reordering

	/*!
	@abstract Allows customization of the target row for a particular row as it is being moved/reordered
	*/
	-(NSIndexPath *) tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath 
																			 toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {

		NSUInteger rowCount = [[self sectionAtIndex:proposedDestinationIndexPath.section].rows count];
		
		/*NSLog(@"Row Count = %u", rowCount);
		NSLog(@"Move From : %u", sourceIndexPath.row);
		NSLog(@"To : %u", proposedDestinationIndexPath.row);*/
		
		if (self.reorderable) {
			if (proposedDestinationIndexPath.row < rowCount) {
				if (sourceIndexPath.section == proposedDestinationIndexPath.section) {
					return proposedDestinationIndexPath;
				}
			}
		}
		return sourceIndexPath;
	}


	#pragma mark Indentation

	/*!
	@abstract Return 'depth' of row for hierarchies
	*/
	-(NSInteger) tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
		return self.rowIndentationLevel;
	}


	#pragma mark Destructor

	-(void) dealloc {
		delegate = nil;
		[deleteButtonTitle release]; deleteButtonTitle = nil;
		[editingInsertLabel release]; editingInsertLabel = nil;
		[super dealloc];
	}

@end

#pragma mark -

@implementation TVKManagedTableController

	@synthesize managedObjectContext;
	@synthesize fetchedResultsController;
	@synthesize entityName;
	@synthesize sortKeyName;

	#pragma mark Initializer

	-(id) initWithEntityName:(NSString *)name {
		self = [super init];
		if (self != nil) {
			self.entityName = name;
		}
		return self;
	}


	#pragma mark Sections

	-(NSArray *) managedSections {
		return [self.fetchedResultsController sections];
	}

	-(NSUInteger) countInSection:(NSUInteger)section {
		NSUInteger count = 0;
		NSArray *sections = [self.fetchedResultsController sections];
		if ([sections count]) {
			id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
			count = [sectionInfo numberOfObjects];
		}
		return count;
	}

	-(BOOL) isNewCellAtIndexPath:(NSIndexPath *)indexPath {
		if (self.isEditing) {
			if (self.editStyle == TVKTableEditingStyleInsertionRow) {
				if (self.insertRowPosition == TVKTableInsertRowPositionFirst) {
					if (indexPath.row == 0) {
						return YES;
					}
				}
				else {
					int count = [self countInSection:indexPath.section];
					if (indexPath.row == count) {
						return YES;
					}
				}
			}
		}
		return NO;
	}

	-(NSIndexPath *) arrangedIndexPathFor:(NSIndexPath *)indexPath {
		if (self.isEditing) {
			if (self.editStyle == TVKTableEditingStyleInsertionRow) {
				if (self.insertRowPosition == TVKTableInsertRowPositionFirst) {
					if (indexPath.row != 0) {
						indexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
					}
				}
			}
		}
		return indexPath;
	}

//	#pragma mark Section
//
//	-(void) addSection:(id <TVKTableSection>)section {
//		[self.sections addObject:section];
//	}
//
//	-(void) removeSection:(id <TVKTableSection>)section {
//		[self.sections removeObject:section];
//	}
//
//	-(id <TVKTableSection>) sectionWithName:(NSString *)name {
//		id <TVKTableSection> sectionWithName = nil;
//		if (self.sections) {
//			for (id <TVKTableSection> section in self.sections) {
//				if ([section.name isEqualToString:name]) {
//					sectionWithName = section;
//				}
//			}
//		}
//		return sectionWithName;
//	}
//
//	-(id <TVKTableSection>) sectionAtIndex:(NSUInteger)sectionIndex {
//		id <TVKTableSection> section = nil;
//		if ([self.sections count] > 0) {
//			section = [self.sections objectAtIndex:sectionIndex];
//		}
//		return section;
//	}
//	
//	-(NSUInteger) indexForSection:(id <TVKTableSection>)section {
//		NSUInteger sectionIndex = 0;
//		if (self.sections) {
//			sectionIndex = [self.sections indexOfObject:section];
//		}
//		return sectionIndex;
//	}


	#pragma mark API

	-(void) loadFetchedResults {
		NSError *error = nil;
		if (![[self fetchedResultsController] performFetch:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}
	
	-(void) insertNewObject {
		NSManagedObjectContext *context		= [fetchedResultsController managedObjectContext];
		NSEntityDescription *entity			= [[fetchedResultsController fetchRequest] entity];
		[NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
		NSError *error = nil;
		if (![context save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}


	#pragma mark <UITableViewDataSource>

	-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
		NSUInteger count = [[self.fetchedResultsController sections] count];
		if (count == 0) {
			count = 1;
		}
		return count;
	}

	-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
		NSUInteger count = 0;
		/*
		If the requesting table view is the search display controller's table view, return the 
		count of the filtered list, otherwise return the count of the main list.
		*/
		NSArray *sections = [self.fetchedResultsController sections];
		if ([sections count]) {
			id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
			count = [sectionInfo numberOfObjects];
		}
		return count;
	}

	-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
		static NSString *TVKManagedTableViewDataSourceCellID = @"TVKManagedTableViewDataSourceCellID";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TVKManagedTableViewDataSourceCellID];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TVKManagedTableViewDataSourceCellID] autorelease];
		}
		NSManagedObject *mo = nil;
		mo	= [self.fetchedResultsController objectAtIndexPath:indexPath];
		cell.textLabel.text			= [mo valueForKey:@"name"];
		cell.detailTextLabel.text	= [mo valueForKey:@"secretIdentity"];
		return cell;
	}



	#pragma mark NSFetchedResultsController

	-(NSFetchedResultsController *) fetchedResultsController {
		if (fetchedResultsController != nil) {
			return fetchedResultsController;
		}

		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Hero" inManagedObjectContext:self.managedObjectContext];
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		[fetchRequest setEntity:entity];
		[fetchRequest setFetchBatchSize:20];
		NSSortDescriptor *sortDescriptor	= [[NSSortDescriptor alloc] initWithKey:self.sortKeyName ascending:NO];
		NSArray *descriptors			= [[NSArray alloc] initWithObjects:sortDescriptor, nil];
		[sortDescriptor release];
		[fetchRequest setSortDescriptors:descriptors];
		[descriptors release];

		NSString *sectionKey = nil;
		NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
																			  managedObjectContext:managedObjectContext 
																				sectionNameKeyPath:sectionKey 
																						 cacheName:@"Hero"];
		frc.delegate = self;
		fetchedResultsController = frc;
		[fetchRequest release];
		return fetchedResultsController;
	}

	-(void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
		//UXLOG(@"%@", controller);
		/*if (!self.tableView.editing) {
			[self.tableView reloadData];
		}*/
	}


	#pragma mark Destructor

	-(void) dealloc {
		managedObjectContext = nil;
		[fetchedResultsController release]; fetchedResultsController = nil;
		[entityName  release]; entityName = nil;
		[sortKeyName release]; sortKeyName = nil;
		[super dealloc];
	}

@end

