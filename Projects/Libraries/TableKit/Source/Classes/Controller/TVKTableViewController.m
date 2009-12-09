
#import <TableKit/TVKTableViewController.h>
#import <TableKit/TVKTable.h>
#import <TableKit/TVKTableItem.h>
#import <TableKit/TVKTableView.h>
#import <TableKit/TVKTableViewCell.h>

NSUInteger const TVKToolbarHeight = 44;

@implementation TVKTableViewController

	@synthesize tableView;
	@synthesize tableViewStyle;

	@synthesize tableController;

	@synthesize tableHeaderView;
	@synthesize tableFooterView;

	@synthesize undoManager;
	@synthesize undoEnabled;
	@synthesize undoLevelLimit;


	#pragma mark Initializers

	-(id) initWithTableViewStyle:(UITableViewStyle)tableStyle {
		self = [super init];
		if (self != nil) {
			self.tableViewStyle = tableStyle;
		}
		return self;
	}
	
	-(id) initWithTableViewStyle:(UITableViewStyle)style controller:(TVKTableController *)controller {
		self = [self initWithTableViewStyle:style];
		if (self != nil) {
			self.tableController = controller;
		}
		return self;
	}


	#pragma mark UIViewController
	
	-(void) loadView {
		[super loadView];
		self.tableView;
		self.tableController;
		// Header and Footer Views (Subclasses)
		
		// Undo (Subclasses)
	}

	-(void) viewDidLoad {
		[super viewDidLoad];
		if ([self.tableController isEditable]) {
			self.navigationItem.rightBarButtonItem		= self.editButtonItem;
			self.tableView.allowsSelectionDuringEditing = YES;
		}
	}

	-(void) viewWillAppear:(BOOL)animated {
		[super viewWillAppear:animated];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respectKeyboard:) name:UIKeyboardWillShowNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respectKeyboard:) name:UIKeyboardWillHideNotification object:nil];
		[self.tableView reloadData];
		//[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
	}

	-(void) viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];
		[self.tableView flashScrollIndicators];
		if (self.undoEnabled) {
			[self becomeFirstResponder];
		}
	}

	-(void) viewWillDisappear:(BOOL)animated {
		[super viewWillDisappear:animated];
		if (self.undoEnabled) {
			[self resignFirstResponder];
		}
	}

	-(void) viewDidDisappear:(BOOL)animated {
		[super viewDidDisappear:animated];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	}


	#pragma mark UIInterfaceOrientation

	-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
		return UIDeviceOrientationIsValidInterfaceOrientation(interfaceOrientation);
	}


	#pragma mark UIResponder

	/*!
	@abstract The view controller must be first responder in order to be able to receive 
	shake events for undo. It should resign first responder status when it disappears.
	*/
	-(BOOL) canBecomeFirstResponder {
		return YES;
	}

	-(void) respectKeyboard:(NSNotification *)aNotification {
		CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
		NSTimeInterval keyboardAnimationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
		
		CGRect newFrame = self.tableView.frame;
		
		if ([[aNotification name] isEqualToString:UIKeyboardWillShowNotification]) {
			newFrame.size.height += (-1 * keyboardRect.size.height);
			if (!self.navigationController.toolbarHidden) {
				newFrame.size.height += TVKToolbarHeight;
			}
		}
		else if ([[aNotification name] isEqualToString:UIKeyboardWillHideNotification]) {
			newFrame.size.height += (1 * keyboardRect.size.height);
			if (!self.navigationController.toolbarHidden) {
				newFrame.size.height -= TVKToolbarHeight;
			}
		}
		
		/*
		UXLOG(@"New Frame Height = %f", newFrame.size.height);
		UXLOG(@"Keyboard Rect =  %@", NSStringFromCGRect(keyboardRect));
		UXLOG(@"New Frame =  %@", NSStringFromCGRect(newFrame));
		UXLOG(@"Table View Frame =  %@", NSStringFromCGRect(self.tableView.frame));
		*/
		
		[UIView beginAnimations:@"RespectKeyboard" context:nil];
		[UIView setAnimationDuration:keyboardAnimationDuration];
		self.tableView.frame = newFrame;
		[UIView commitAnimations];
	}


	#pragma mark Editing

	-(void) setEditing:(BOOL)editing animated:(BOOL)animated {
		[super setEditing:editing animated:animated];
		if (self.tableController.isEditable) {
			self.navigationItem.rightBarButtonItem.enabled = TRUE;
			[self.navigationItem setHidesBackButton:editing animated:animated];

			NSMutableArray *indexPaths = [NSMutableArray array];
			NSArray *sections = [NSArray arrayWithArray:self.tableController.sections];
			for (id <TVKTableSection> section in sections) {
				NSUInteger rowCount		= [section.rows count];
				NSUInteger sectionIndex = [self.tableController indexForSection:section];
				//[sections indexOfObject:section]
				[indexPaths addObject:[NSIndexPath indexPathForRow:rowCount inSection:sectionIndex]];
			}
			[tableView beginUpdates];
			self.tableController.isEditing = editing;
			[tableView setEditing:editing animated:animated];
			
			if (editing) {
				// Show the placeholder rows
				[tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
			}
			else {
				// Hide the placeholder rows.
				[tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
			}
			[tableView endUpdates];
		}
		if (self.undoEnabled) {
			/*!
			 Respond to change in editing state:
			 If editing begins, create and set an undo manager to track edits. Then register as an observer of 
			 undo manager change notifications, so that if an undo or redo operation is performed, the table view 
			 can be reloaded. If editing ends, de-register from the notification center and remove the undo manager.
			 */
			NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
			if (editing) {
				NSUndoManager *anUndoManager	= [[NSUndoManager alloc] init];
				self.undoManager				= anUndoManager;
				[anUndoManager release];
				
				[undoManager setLevelsOfUndo:self.undoLevelLimit];
				[dnc addObserver:self 
						selector:@selector(undoManagerDidUndo:) 
							name:NSUndoManagerDidUndoChangeNotification 
						  object:undoManager];
				[dnc addObserver:self 
						selector:@selector(undoManagerDidRedo:) 
							name:NSUndoManagerDidRedoChangeNotification 
						  object:undoManager];
			}
			else {
				[dnc removeObserver:self];
				self.undoManager = nil;
			}
		}
	}


	#pragma mark Undo Support

	/*!
	@abstract Methods invoked in response to undo notifications -- see setEditing:animated:. 
	Simply redisplay the table view to reflect the changed value.
	*/
	-(void) undoManagerDidUndo:(NSNotification *)notification {
		[self.tableView reloadData];
	}

	-(void) undoManagerDidRedo:(NSNotification *)notification {
		[self.tableView reloadData];
	}


	#pragma mark API

	-(UITableView *) tableView {
		if (!tableView) {
			tableView						= [[UITableView alloc] initWithFrame:self.view.bounds style:self.tableViewStyle];
			tableView.autoresizingMask		= (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
			UIColor *backgroundColor		= tableViewStyle == UITableViewStyleGrouped ? [UIColor groupTableViewBackgroundColor] : nil;
			if (backgroundColor) {
				tableView.backgroundColor	= backgroundColor;
				self.view.backgroundColor	= backgroundColor;
			}
			[self.view addSubview:tableView];
		}
		return tableView;
	}

	-(void) setTableView:(UITableView *)aTableView {
		if (tableView != aTableView) {
			[tableView release];
			tableView = [aTableView retain];
			if (!tableView) {
				self.tableHeaderView	= nil;
				self.tableFooterView	= nil;
			}
		}
	}

	-(void) setTableHeaderView:(UIView *)headerView {
		if (tableHeaderView != headerView) {
			[tableHeaderView release];
			tableHeaderView = [headerView retain];
			if (tableHeaderView) {
				CGRect tableHeaderViewFrame		= CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, tableHeaderView.frame.size.height);
				//tableHeaderView.backgroundColor = [UIColor clearColor];
				tableHeaderView.frame			= tableHeaderViewFrame;
				// overrides UITableView sectionHeaderHeight property
				self.tableView.tableHeaderView	= tableHeaderView;
			}
		}
	}

	-(void) setTableFooterView:(UIView *)footerView {
		if (tableFooterView != footerView) {
			[tableFooterView release];
			tableFooterView = [footerView retain];
			if (tableFooterView) {
				CGRect tableFooterViewFrame		= CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, tableFooterView.frame.size.height);
				//tableFooterView.backgroundColor = [UIColor clearColor];
				tableFooterView.frame			= tableFooterViewFrame;
				// overrides UITableView sectionHeaderHeight property
				self.tableView.tableFooterView = tableFooterView;
			}
		}
	}
	
	-(TVKTableController *) tableController {
		if (!tableController) {
			tableController = [[TVKTableController alloc] initWithDelegate:self];
			self.tableView.dataSource	= tableController;
			self.tableView.delegate		= tableController;
		}
		return tableController;
	}

	-(void) setTableController:(TVKTableController *)controller {
		if (tableController != controller) {
			[tableController release];
			tableController = [controller retain];
			tableController.delegate	= self;
			self.tableView.dataSource	= tableController;
			self.tableView.delegate		= tableController;
		}
	}


	#pragma mark <TVKTableControllerDelegate>

	-(UITableViewCell *) tableController:(TVKTableController *)controller editingInsertCellForIndexPath:(NSIndexPath *)indexPath {
		UITableViewCell *cell;
		static NSString * TVKTableViewControllerInsertionCellIdentifier = @"TVKTableViewControllerInsertionCellID";
		cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:TVKTableViewControllerInsertionCellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
										   reuseIdentifier:TVKTableViewControllerInsertionCellIdentifier] autorelease];
		}
		cell.textLabel.text = @"Add Row";
		return cell;
	}

	-(BOOL) tableController:(TVKTableController *)controller canInsertRowInSection:(id <TVKTableSection>)section {
		return TRUE;
	}

	-(id <TVKTableRow>) tableController:(TVKTableController *)controller rowForInsertionInSection:(id <TVKTableSection>)section {
		id <TVKTableRow> row; 
		row = [[TVKTableItem alloc] initWithText:[NSString stringWithFormat:@"Item Text %u", [section.rows count]] image:nil];
		id <TVKTableRow> addedRow = [section addRow:row];
		[row release];
		return addedRow;
	}

	-(void) tableController:(TVKTableController *)controller accessoryButtonTappedForRow:(id <TVKTableRow>)row {
		NSLog(@"Tapped Accessory Button at : %@", row);
	}


	#pragma mark Key-Value Observing

	-(void) observeValueForKeyPath:(NSString *)aKeyPath ofObject:(id)anObject change:(NSDictionary *)aChange context:(void *)aContext {
		if (anObject == self && NULL != aContext && [(NSString *)aContext isEqualToString:NSStringFromClass([self class])]) {
			//UXLog(@"Key Path = %@,\nObject = %@,\nChange = %@", aKeyPath, anObject, aChange);
		}
	}


	#pragma mark Memory

	-(void) didReceiveMemoryWarning {
		[super didReceiveMemoryWarning];
	}

	-(void) viewDidUnload {
		[[NSNotificationCenter defaultCenter] removeObserver:self];
		self.undoManager		= nil;
		self.tableHeaderView	= nil;
		self.tableFooterView	= nil;
		self.tableController	= nil;
		self.tableView = nil;
		[super viewDidUnload];
	}

	-(void) dealloc {
		[[NSNotificationCenter defaultCenter] removeObserver:self];
		[undoManager release]; undoManager = nil;
		[tableHeaderView release]; tableHeaderView = nil;
		[tableFooterView release]; tableFooterView = nil;
		[tableController release]; tableController = nil;
		[tableView release]; tableView = nil;
		[super dealloc];
	}

@end
