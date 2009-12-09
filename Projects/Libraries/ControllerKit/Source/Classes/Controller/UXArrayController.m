
#import <ControllerKit/UXArrayController.h>

@interface UXArrayController ()
	@property (retain, readwrite) id arrangedObjects;
	-(void) rearrangeObjects;
	-(NSArray *) arrangeObjects:(NSArray *)arrangableObjects;
@end

#pragma mark -

@implementation UXArrayController

    @synthesize arrangedObjects;
	@synthesize sortDescriptors;
	@synthesize filterPredicate;
	@synthesize clearsFilterPredicateOnInsertion;

	#pragma mark Initializer

	-(id) init {
		self = [super initWithContent:[NSMutableArray array]];
		if (self) {
		}
		return self;
	}


	#pragma mark -

	-(void) setContent:(id)anObject {
		if (anObject != content) {
			[content release];
			content = [anObject retain];
		}
		
		if (self.clearsFilterPredicateOnInsertion) {
			filterPredicate  = nil;
		}
		
		[self rearrangeObjects];
	}

	-(NSArray *) arrangeObjects:(NSArray *)arrangableObjects {
		id sortedObjects = arrangableObjects;
		if (filterPredicate) {
			sortedObjects = [sortedObjects filteredArrayUsingPredicate:filterPredicate];
		}
		
		if (sortDescriptors) {
			sortedObjects = [sortedObjects sortedArrayUsingDescriptors:sortDescriptors];
		}
		return sortedObjects;
	}

	-(void) rearrangeObjects {
		self.arrangedObjects = [self arrangeObjects:[self content]];
	}

	-(void) setArrangedObjects:(id)objectsArranged {
		if (arrangedObjects != objectsArranged) {
			[arrangedObjects release];
			arrangedObjects = [[NSMutableArray alloc] initWithArray:objectsArranged];
		}
	}

	-(void) setSortDescriptors:(NSArray *)descriptors {
		if (sortDescriptors != descriptors) {
			[sortDescriptors release];
			sortDescriptors = [descriptors retain];
			[self rearrangeObjects];
		}
	}

	-(void) setFilterPredicate:(NSPredicate *)predicate {
		if (filterPredicate != predicate) {
			[filterPredicate release];
			filterPredicate = [predicate retain];
			[self rearrangeObjects];
		}
	}


	#pragma mark -

	-(void) addObject:(id)object {
		if (!self.isEditable) {
			return;
		}
		
		[self willChangeValueForKey:@"content"];
		[content addObject:object];
		[self didChangeValueForKey:@"content"];
		
		if (self.clearsFilterPredicateOnInsertion) {
			filterPredicate = nil;
		}
	}

	-(void) addObjects:(NSArray *)objects {
		if (!self.isEditable) {
			return;
		}
		[content addObjectsFromArray:objects]; 
	}


	#pragma mark -

	-(BOOL) canInsert  {
		return self.isEditable;
	}

	-(void) insertObject:(id)object atArrangedObjectIndex:(NSUInteger)index  {

	}

	-(void) insertObjects:(NSArray *)objects atArrangedObjectIndexes:(NSIndexSet *)indexes  {

	}
	

	#pragma mark -

	-(void) removeObject:(id)object {
		if (!self.isEditable) {
			return;
		}
		
		[self willChangeValueForKey:@"content"];
		[content removeObject:object];
		[self didChangeValueForKey:@"content"];
		[self rearrangeObjects];
	}

	-(void) removeObjectAtArrangedObjectIndex:(NSUInteger)index  {

	}
		
	-(void) removeObjects:(NSArray *)objects {
		if (!self.isEditable) {
			return;
		}
		[content removeObjectsInArray:self.content];
	}

	-(void) removeObjectsAtArrangedObjectIndexes:(NSIndexSet *)indexes  {
		[self removeObjects:[content objectsAtIndexes:indexes]];
	}


	#pragma mark Memory

	-(void) dealloc {
		[arrangedObjects release]; arrangedObjects = nil;
		[sortDescriptors release]; sortDescriptors = nil; 
		[filterPredicate release]; filterPredicate = nil;
		[super dealloc];
	}

@end
