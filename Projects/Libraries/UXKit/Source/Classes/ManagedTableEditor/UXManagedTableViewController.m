
#import "STKManagedTableViewController.h"

@implementation STKManagedTableViewController

	@synthesize fetchedResultsController,
				managedObjectContext;

	#pragma mark UIViewController

	-(void) viewDidLoad {
		[super viewDidLoad];
		
		// Set up the edit and add buttons.
		self.navigationItem.leftBarButtonItem = self.editButtonItem;
		
		UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject)];
		self.navigationItem.rightBarButtonItem = addButton;
		[addButton release];
		
		NSError *error = nil;
		if (![[self fetchedResultsController] performFetch:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}

	-(void) viewWillAppear:(BOOL)animated {
		[super viewWillAppear:animated];
	}

	-(void) viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];
	}

	-(void) viewWillDisappear:(BOOL)animated {
		[super viewWillDisappear:animated];
	}

	-(void) viewDidDisappear:(BOOL)animated {
		[super viewDidDisappear:animated];
	}

	-(void) viewDidUnload {
		// Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
		// For example: self.myOutlet = nil;
	}


	#pragma mark Add a new object

	-(void) insertNewObject {
		
		// Create a new instance of the entity managed by the fetched results controller.
		NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
		NSEntityDescription *entity = [[fetchedResultsController fetchRequest] entity];
		NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
		
		// If appropriate, configure the new managed object.
		[newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
		
		// Save the context.
		NSError *error = nil;
		if (![context save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}


	#pragma mark UITableViewDataSource

	-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
		NSUInteger count = [[fetchedResultsController sections] count];
		return (count == 0) ? 1 : count;
	}

	-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
		id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
		return [sectionInfo numberOfObjects];
	}

	-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
		
		static NSString *CellIdentifier = @"Cell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		
		// Configure the cell.
		NSManagedObject *managedObject = [fetchedResultsController objectAtIndexPath:indexPath];
		cell.textLabel.text = [[managedObject valueForKey:@"timeStamp"] description];
		
		return cell;
	}

	-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
		// Navigation logic may go here -- for example, create and push another view controller.
		/*
		 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
		 NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
		 // ...
		 // Pass the selected object to the new view controller.
		 [self.navigationController pushViewController:detailViewController animated:YES];
		 [detailViewController release];
		 */
	}

	-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
		
		if (editingStyle == UITableViewCellEditingStyleDelete) {
			// Delete the managed object for the given index path
			NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
			[context deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
			
			// Save the context.
			NSError *error = nil;
			if (![context save:&error]) {
				/*
				 Replace this implementation with code to handle the error appropriately.
				 
				 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
				 */
				NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
				abort();
			}
		}
	}

	-(BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
		// The table view should not be re-orderable.
		return NO;
	}


	#pragma mark <NSFetchedResultsControllerDelegate>

	-(NSFetchedResultsController *)fetchedResultsController {
		
		if (fetchedResultsController != nil) {
			return fetchedResultsController;
		}
		
		/*
		 Set up the fetched results controller.
		 */
		// Create the fetch request for the entity.
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		// Edit the entity name as appropriate.
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:managedObjectContext];
		[fetchRequest setEntity:entity];
		
		// Set the batch size to a suitable number.
		[fetchRequest setFetchBatchSize:20];
		
		// Edit the sort key as appropriate.
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
		
		[fetchRequest setSortDescriptors:sortDescriptors];
		
		// Edit the section name key path and cache name if appropriate.
		// nil for section name key path means "no sections".
		NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
		aFetchedResultsController.delegate = self;
		self.fetchedResultsController = aFetchedResultsController;
		
		[aFetchedResultsController release];
		[fetchRequest release];
		[sortDescriptor release];
		[sortDescriptors release];
		
		return fetchedResultsController;
	}

	-(void) controllerWillChangeContent:(NSFetchedResultsController *)controller {
		[self.tableView beginUpdates];
	}

	-(void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
		[self.tableView endUpdates];
	}

	-(void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
		switch (type) {
			case NSFetchedResultsChangeInsert:
				[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
				break;
			case NSFetchedResultsChangeDelete:
				[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
				break;
			case NSFetchedResultsChangeUpdate: {
				NSString *sectionKeyPath = [controller sectionNameKeyPath];
				if (sectionKeyPath == nil) {
					break;
				}
				NSManagedObject *changedObject = [controller objectAtIndexPath:indexPath];
				NSArray *keyParts = [sectionKeyPath componentsSeparatedByString:@"."];
				id currentKeyValue = [changedObject valueForKeyPath:sectionKeyPath];
				
				// If nested keys, need to get the related object to get
				// the committed key value
				
				for (int i = 0; i < [keyParts count] - 1; i++) {
					NSString *onePart = [keyParts objectAtIndex:i];
					changedObject = [changedObject valueForKey:onePart];
				}
				sectionKeyPath = [keyParts lastObject];
				NSDictionary *committedValues = [changedObject committedValuesForKeys:nil];
				
				
				if ([[committedValues valueForKeyPath:sectionKeyPath] isEqual:currentKeyValue]) {
					break;
				}
				
				NSUInteger tableSectionCount = [self.tableView numberOfSections];
				NSUInteger frcSectionCount = [[controller sections] count];
				if (tableSectionCount != frcSectionCount) {
					// Need to insert a section
					NSArray *sections = controller.sections;
					NSInteger newSectionLocation = -1;
					for (id oneSection in sections) {
						NSString *sectionName = [oneSection name];
						if ([currentKeyValue isEqual:sectionName]) {
							newSectionLocation = [sections indexOfObject:oneSection];
							break;
						}
					}
					if (newSectionLocation == -1) {
						return;         // uh oh
						
					}
					if (!((newSectionLocation == 0) && (tableSectionCount == 1) ) && ( [self.tableView numberOfRowsInSection:0] == 0) ) {
						[self.tableView insertSections:[NSIndexSet indexSetWithIndex:newSectionLocation] withRowAnimation:UITableViewRowAnimationFade];
					}
					NSUInteger indices[2] = {newSectionLocation, 0};
					newIndexPath = [[[NSIndexPath alloc] initWithIndexes:indices length:2] autorelease];
					
				}
			}
			case NSFetchedResultsChangeMove:
				if (newIndexPath != nil) {
					[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
					[self.tableView insertRowsAtIndexPaths: [NSArray arrayWithObject:newIndexPath]
										  withRowAnimation:UITableViewRowAnimationRight];
					
					
				}
				else {
					[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[indexPath section]] withRowAnimation:UITableViewRowAnimationFade];
				}
				
				break;
				
			default:
				break;
		}
	}

	-(void) controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
		switch (type) {
				
			case NSFetchedResultsChangeInsert:
				if (!((sectionIndex == 0) && ( [self.tableView numberOfSections] == 1) ) && ( [self.tableView numberOfRowsInSection:0] == 0) ) {
					[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
				}
				break;
			case NSFetchedResultsChangeDelete:
				if (!((sectionIndex == 0) && ( [self.tableView numberOfSections] == 1) ) && ( [self.tableView numberOfRowsInSection:0] == 0) ) {
					[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
				}
				break;
			case NSFetchedResultsChangeMove:
				break;
			case NSFetchedResultsChangeUpdate:
				break;
			default:
				break;
		}
	}


	#pragma mark Memory

	-(void) didReceiveMemoryWarning {
		[super didReceiveMemoryWarning];
		// Relinquish ownership of any cached data, images, etc that aren't in use.
	}

	-(void) dealloc {
		[fetchedResultsController release];
		[managedObjectContext release];
		[super dealloc];
	}

@end
