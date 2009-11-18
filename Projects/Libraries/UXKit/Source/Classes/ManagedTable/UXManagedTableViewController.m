
#import <UXKit/UXManagedTableViewController.h>

@implementation UXManagedTableViewController

	@synthesize fetchedResultsController;
	@synthesize managedObjectContext;
	@synthesize entityName;

	-(id) initWithEntityName:(NSString *)anEntityName {
		self = [super init];
		if (self != nil) {
			self.entityName = anEntityName;
		}
		return self;
	}


	#pragma mark UIViewController

	-(void) loadView {
		[super viewDidLoad];
		UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
																				   target:self 
																				   action:@selector(insertNewObject)];
		self.navigationItem.rightBarButtonItem	= addButton;
		self.navigationItem.leftBarButtonItem	= self.editButtonItem;
		[addButton release];
		NSError *error = nil;
		if (![[self fetchedResultsController] performFetch:&error]) {
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
		[super viewDidUnload];
	}


	#pragma mark New Objects

	-(void) insertNewObject {
		NSManagedObjectContext *context		= [fetchedResultsController managedObjectContext];
		NSEntityDescription *entity			= [[fetchedResultsController fetchRequest] entity];
		NSManagedObject *newManagedObject	= [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
		
		[newManagedObject setValue:@"01" forKey:@"identifier"];
		
		NSError *error = nil;
		if (![context save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}


	#pragma mark UITableViewDataSource

	-(NSInteger) numberOfSectionsInTableView:(UITableView *)aTableView {
		NSUInteger count = [[fetchedResultsController sections] count];
		return (count == 0) ? 1 : count;
	}

	-(NSInteger) tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
		id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
		return [sectionInfo numberOfObjects];
	}

	-(UITableViewCell *) tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
		static NSString *CellIdentifier = @"Cell";
		UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		NSManagedObject *managedObject	= [fetchedResultsController objectAtIndexPath:indexPath];
		cell.textLabel.text				= [[managedObject valueForKey:@"identifier"] description];
		return cell;
	}

	-(void) tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	}

	-(void) tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
		if (editingStyle == UITableViewCellEditingStyleDelete) {
			NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
			[context deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
			NSError *error = nil;
			if (![context save:&error]) {
				NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
				abort();
			}
		}
	}

	-(BOOL) tableView:(UITableView *)aTableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
		return TRUE;
	}


	#pragma mark <NSFetchedResultsControllerDelegate>

	-(NSFetchedResultsController *)fetchedResultsController {
		if (fetchedResultsController != nil) {
			return fetchedResultsController;
		}
		NSFetchRequest *fetchRequest	= [[NSFetchRequest alloc] init];
		NSEntityDescription *entity		= [NSEntityDescription entityForName:[[[fetchedResultsController fetchRequest] entity] name] 
													  inManagedObjectContext:managedObjectContext];
		[fetchRequest setEntity:entity];
		[fetchRequest setFetchBatchSize:20];
		
		NSSortDescriptor *sortDescriptor	= [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
		NSArray *sortDescriptors			= [[NSArray alloc] initWithObjects:sortDescriptor, nil];
		[fetchRequest setSortDescriptors:sortDescriptors];
		
		NSFetchedResultsController *fetchedController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
		fetchedController.delegate		= self;
		self.fetchedResultsController	= fetchedController;
		
		[fetchedController release];
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
				
				// If nested keys, need to get the related object to get the committed key value
				
				for (NSUInteger keyPartCount = 0; keyPartCount < [keyParts count] - 1; keyPartCount++) {
					NSString *onePart	= [keyParts objectAtIndex:keyPartCount];
					changedObject		= [changedObject valueForKey:onePart];
				}
				sectionKeyPath					= [keyParts lastObject];
				NSDictionary *committedValues	= [changedObject committedValuesForKeys:nil];
				
				if ([[committedValues valueForKeyPath:sectionKeyPath] isEqual:currentKeyValue]) {
					break;
				}
				
				NSUInteger tableSectionCount	= [self.tableView numberOfSections];
				NSUInteger fetchedSectionCount	= [[controller sections] count];
				
				if (tableSectionCount != fetchedSectionCount) {
					NSArray *sections				= controller.sections;
					NSInteger newSectionLocation	= -1;
					for (id oneSection in sections) {
						NSString *sectionName = [oneSection name];
						if ([currentKeyValue isEqual:sectionName]) {
							newSectionLocation = [sections indexOfObject:oneSection];
							break;
						}
					}

					if (newSectionLocation == -1) {
						return;
						
					}
					if (!((newSectionLocation == 0) && (tableSectionCount == 1)) && (([self.tableView numberOfRowsInSection:0] == 0))) {
						[self.tableView insertSections:[NSIndexSet indexSetWithIndex:newSectionLocation] 
									  withRowAnimation:UITableViewRowAnimationFade];
					}

					NSUInteger indices[2]	= {newSectionLocation, 0};
					newIndexPath			= [[[NSIndexPath alloc] initWithIndexes:indices length:2] autorelease];
				}
			}
			case NSFetchedResultsChangeMove:
				if (newIndexPath != nil) {
					[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
										  withRowAnimation:UITableViewRowAnimationFade];
					[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
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
	}

	-(void) dealloc {
		[entityName release]; entityName = nil;
		[fetchedResultsController release]; fetchedResultsController = nil;
		[managedObjectContext release]; managedObjectContext = nil;
		[super dealloc];
	}

@end
