
#import <UXKit/UXManagedModelDataSource.h>

@interface UXManagedModelDataSource ()
	@property (readwrite, nonatomic, retain) NSArray *items;
@end

#pragma mark -

@implementation UXManagedModelDataSource

	@synthesize managedObjectContext;
	@synthesize entityDescription;
	@synthesize sortDescriptors;
	@synthesize predicate;
	@synthesize items;

	#pragma mark Initializers

	-(id) initWithManagedObjectContext:(NSManagedObjectContext *)aContext entityDescription:(NSEntityDescription *)aDescription {
		if ((self = [self init]) != nil) {
			self.managedObjectContext	= aContext;
			self.entityDescription		= aDescription;
		}
		return self;
	}

	-(id) initWithManagedObjectContext:(NSManagedObjectContext *)aContext entityName:(NSString *)anEntityName {
		NSEntityDescription *description = [NSEntityDescription entityForName:anEntityName inManagedObjectContext:aContext];
		if ((self = [self initWithManagedObjectContext:aContext entityDescription:description]) != nil) {
		}
		return self;
	}

	#pragma mark -

	-(void) setPredicate:(NSPredicate *)aPredicate {
		if (predicate != aPredicate) {
			[predicate release];
			predicate = [aPredicate retain];
			self.items = nil;
		}
	}

	-(NSArray *) sortDescriptors {
		return sortDescriptors;
	}

	-(void) setSortDescriptors:(NSArray *)sortDescriptorList {
		if (sortDescriptors != sortDescriptorList) {
			[sortDescriptors release];
			sortDescriptors = [sortDescriptorList retain];
			self.items = nil;
		}
	}

	#pragma mark -

	-(NSArray *) items {
		if (items == nil) {
			[self fetch:nil];
		}
		return items;
	}

	-(void) setItems:(NSArray *)itemsArray {
		if (items != itemsArray) {
			[items release];
			items = [itemsArray retain];
		}
	}

	#pragma mark -

	-(BOOL) fetch:(NSError **)anError {
		NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
		[request setEntity:self.entityDescription];
		if (self.sortDescriptors) {
			[request setSortDescriptors:self.sortDescriptors];
		}
		if (self.predicate) {
			[request setPredicate:self.predicate];
		}
		
		NSArray *results = [self.managedObjectContext executeFetchRequest:request error:anError];
		
		self.items = results;
		return results != nil;
	}

	#pragma mark Gozer

	-(void) dealloc {
		[predicate release]; predicate = nil;
		[sortDescriptors release]; sortDescriptors = nil;
		[items release]; items = nil;
		[entityDescription release]; entityDescription = nil;
		[managedObjectContext release]; managedObjectContext = nil;
		[super dealloc];
	}

@end
