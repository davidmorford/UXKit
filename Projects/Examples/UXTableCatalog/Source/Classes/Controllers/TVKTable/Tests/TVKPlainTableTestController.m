
#import "TVKPlainTableTestController.h"
#import <TableKit/TVKTableController.h>
#import <TableKit/TVKTableItem.h>
#import <TableKit/TVKTableViewCell.h>
#import "UXTableCatalogApplicationCoordinator.h"

@implementation TVKPlainTableTestController

	#pragma mark Initializer

	-(id) init {
		self = [super initWithTableViewStyle:UITableViewStylePlain];
		if (self) {
		}
		return self;
	}
	
	-(void) loadView {
		[super loadView];
		[self setToolbarItems:[NSArray arrayWithObjects:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createSection)] autorelease], nil]];
		self.title								= @"Plain";
		self.navigationController.toolbarHidden = FALSE;
		TVKTableGroup *section					= [[TVKTableGroup alloc] init];
		[self.tableController addSection:section];
		[section release];
	}


	#pragma mark -
	
	-(void) createSection {
		TVKTableGroup *rootSection = [self.tableController sectionAtIndex:0];
		TVKTableItem *row;

		row = [[TVKTableItem alloc] initWithText:@"Default Style" image:nil];
		row.height = 44;
		[rootSection addRow:row];
		[row release]; row = nil;

		row = [[TVKTableItem alloc] initWithText:@"Default Style With Image" image:UXIMAGE(@"bundle://Settings.png")];
		row.height = 44;
		[rootSection addRow:row];
		[row release]; row = nil;

		row = [[TVKTableItem alloc] initWithText:@"Value 1" labelText:@"Cell Style" image:nil];
		row.height = 44;
		[rootSection addRow:row];
		[row release]; row = nil;

		row = [[TVKTableItem alloc] initWithText:@"Value 2" captionText:@"Cell Style" image:nil];
		row.height = 44;
		[rootSection addRow:row];
		[row release]; row = nil;

		row = [[TVKTableItem alloc] initWithText:@"Subtitle" subtitleText:@"Cell Style" image:nil];
		row.height = 44;
		[rootSection addRow:row];
		[row release]; row = nil;

		row = [[TVKTableItem alloc] initWithText:@"Subtitle" subtitleText:@"Title" image:UXIMAGE(@"bundle://Camera.png")];
		row.height = 44;
		[rootSection addRow:row];
		[row release]; row = nil;

		row = [[TVKTableItem alloc] initWithText:@"Subtitle" subtitleText:@"Title" image:UXIMAGE(@"bundle://UXTableCatalog.png")];
		row.height = 64;
		[rootSection addRow:row];
		[row release]; row = nil;

		[self.tableView reloadData];
	}


	#pragma mark Destructor

	-(void) dealloc {
		[super dealloc];
	}

@end

#pragma mark -

@implementation TVKPlainStyledTableTestController
	
	-(id) init {
		return [self initWithTableViewStyle:UITableViewStylePlain];
	}


	#pragma mark UIViewController

	-(void) loadView {
		[super loadView];
		self.title			= @"Plain Styled";
		//self.view.backgroundColor = [UIColor clearColor];
		//[self setToolbarItems:[NSArray arrayWithObjects:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
//																									   target:self 
//																									   action:@selector(addRow)] autorelease], nil]];
//		self.navigationController.toolbarHidden		= FALSE;
//		self.tableViewDataSource.allowEditing		= TRUE;
//		self.tableViewDataSource.canReorder			= TRUE;
//		self.tableViewDataSource.editingInsertLabel	= @"Add New Row...";
		//self.tableViewDelegate.identWhileEditing	= TRUE;
		/*
		UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,64)];
		headerView.backgroundColor = [UIColor lightGrayColor];
		self.tableHeaderView = headerView;
		[headerView release];
		
		UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,32)];
		footerView.backgroundColor = [UIColor lightGrayColor];
		self.tableFooterView = footerView;
		[footerView release];
		*/

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

#pragma mark -

@interface TVKPlainManagedTableController : TVKManagedTableController {

}

	-(void) addHero;
	
@end

@implementation TVKPlainManagedTableController

	-(id) init {
		self = [super initWithEntityName:@"Hero"];
		if (self != nil) {
			self.managedObjectContext	= [UXTableCatalogApplicationCoordinator sharedCoordinator].objectStore.managedObjectContext;
			self.sortKeyName			= @"name";
			self.isEditable				= TRUE;
			self.isEditing				= TRUE;
			self.reorderable			= TRUE;
		}
		return self;
	}

	-(void) addHero {
		NSManagedObjectContext *context		= [self.fetchedResultsController managedObjectContext];
		NSEntityDescription *entity			= [[self.fetchedResultsController fetchRequest] entity];
		NSManagedObject *newManagedObject	= [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
		[newManagedObject setValue:@"SuperDave" forKey:@"name"];
		[newManagedObject setValue:@"David Morford" forKey:@"secretIdentity"];
		[newManagedObject setValue:@"Male" forKey:@"sex"];
	}

@end

#pragma mark -

@implementation TVKPlainManagedTableTestController
	
	-(id) init {
		return [super initWithTableViewStyle:UITableViewStylePlain];
	}


	#pragma mark UIViewController

	-(void) loadView {
		[super loadView];
		self.title = @"Plain Managed";

		UIBarButtonItem *flexy = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																			   target:nil 
																			   action:nil];

		UIBarButtonItem *addy = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
																			  target:self 
																			  action:@selector(add)];
		
		UIBarButtonItem *fetchy = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh  
																				target:self 
																				action:@selector(fetchResults)];																						 
		[self setToolbarItems:[NSArray arrayWithObjects:addy, flexy, fetchy, nil]];
		self.navigationController.toolbarHidden	= FALSE;
		[flexy release];
		[fetchy release];
		[addy release];
		
		self.tableController = [[TVKPlainManagedTableController alloc] init];
	}

	-(void) viewDidLoad {
		[super viewDidLoad];
		[(TVKPlainManagedTableController *)self.tableController loadFetchedResults];
	}


	#pragma mark Actions
	
	-(void) fetchResults {
		[(TVKPlainManagedTableController *)self.tableController loadFetchedResults];
		[self.tableView reloadData];
	}

	-(void) create {

	}

	-(void) add {
		[(TVKPlainManagedTableController *)self.tableController addHero];
		[self save];
		[self fetchResults];
	}

	-(void) save {
		NSError *saveError = nil;
		[[(TVKPlainManagedTableController *)self.tableController managedObjectContext] save:&saveError];
		if (saveError) {
			NSLog(@"%@", saveError);
		}
	}

@end
