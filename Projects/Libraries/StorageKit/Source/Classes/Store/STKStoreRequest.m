
#import <StorageKit/STKStoreRequest.h>

@interface STKStoreRequest ()
	-(NSArray *) observableKeys;
@end

#pragma mark -

@implementation STKStoreRequest

	@synthesize entityDescription;
	@synthesize entityName;
	@synthesize predicate;
	@synthesize sortDescriptors;
	@synthesize managedObjectContext;
	@synthesize sectionNameKeyPath;
	@synthesize cacheName;
	
	#pragma mark Constructor

	+(STKStoreRequest *) storeRequest {
		return [[[[self class] alloc] init] autorelease];
	}

	+(STKStoreRequest *) storeRequestWithEntityName:(NSString *)name {
		return [[[[self class] alloc] initWithEntityName:name] autorelease];
	}	
	


	#pragma mark Initializer

	-(id) init {
		self = [super init];
		if (self != nil) {
			for (NSString *key in [self observableKeys]) {
				[self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew context:nil];
			}
		}
		return self;
	}

	-(id) initWithEntityName:(NSString *)name {
		self = [self init];
		if (self != nil) {
			self.entityName = name;
		}
		return self;
	}


	#pragma mark Entity

	-(NSEntityDescription *) entityDescription {
		if (!entityDescription) {
			if (entityName && managedObjectContext) {
				entityDescription = [[NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext] retain];
			}
		}
		return entityDescription;
	}


	#pragma mark Fetching

	-(NSFetchRequest *) fetchRequst {
		if (!fetchRequest) {
			if (!self.managedObjectContext) {
				return nil;
			}
			fetchRequest = [[NSFetchRequest alloc] init];
			[fetchRequest setEntity:self.entityDescription];
			[fetchRequest setPredicate:self.predicate];
			[fetchRequest setSortDescriptors:self.sortDescriptors];
		}
		return fetchRequest;
	}

	-(NSFetchedResultsController *) fetchedResultsController {
		if (!fetchedResultsController) {
			NSFetchRequest *request = self.fetchRequst;
			if ([[request sortDescriptors] count] < 1) {
				return nil;
			}
			fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request 
																		   managedObjectContext:managedObjectContext 
																			 sectionNameKeyPath:sectionNameKeyPath 
																					  cacheName:cacheName];
		}
		return fetchedResultsController;
	}


	#pragma mark KVO

	-(NSArray *) observableKeys {
		return [NSArray arrayWithObjects:
				@"managedObjectContext", 
				@"entity", 
				@"predicate", 
				@"sortDescriptors", 
				@"selectionNameKeyPath", 
				@"cacheName", nil];
	}

	-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
		[fetchedResultsController release];
		fetchedResultsController = nil;
		
		[fetchRequest release];
		fetchRequest = nil;
	}


	#pragma mark Gozer

	-(void) dealloc {
		for (NSString *key in [self observableKeys]) {
			[self removeObserver:self forKeyPath:key];
		}
		
		[entityName release];
		[entityDescription release];
		[predicate release];
		[sortDescriptors release];
		[managedObjectContext release];
		[sectionNameKeyPath release];
		[cacheName release];
		
		[fetchRequest release];
		[fetchedResultsController release];
		
		[super dealloc];
	}

@end
