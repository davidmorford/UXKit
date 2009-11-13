
#import <UXKit/UXStoreQuery.h>`

@interface UXObjectStoreQuery ()
	@property (nonatomic, retain, readwrite) NSFetchRequest *fetchRequest;
	@property (nonatomic, retain, readwrite) UXObjectStoreContext *context;
@end

#pragma mark -

@implementation UXObjectStoreQuery

	@synthesize fetchRequest;
	@synthesize context;

	#pragma mark -

	+(UXObjectStoreQuery *) queryWithFetchRequest:(NSFetchRequest *)request context:(UXObjectStoreContext *)storeContext {
		return [[[[self class] alloc] initWithFetchRequest:request context:storeContext] autorelease];
	}

	+(UXObjectStoreQuery *) queryWithEntityName:(NSString *)entityName context:(UXObjectStoreContext *)storeContext {
		NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
		[request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:(NSManagedObjectContext *)storeContext]];
		return [[[[self class] alloc] initWithFetchRequest:request context:storeContext] autorelease];
	}

	#pragma mark -

	-(id)  initWithFetchRequest:(NSFetchRequest *)request context:(UXObjectStoreContext *)storeContext {
		self = [super init];
		if (self != nil) {
			fetchRequest	= [request retain];
			context			= [storeContext retain];
		}
		return self;
	}

	#pragma mark -

	-(NSArray *) results {
		[fetchRequest setFetchLimit:0];
		NSError *error	= nil;
		NSArray *result = [self.context executeFetchRequest:fetchRequest error:&error];
		return result;
	}
	
	-(void) appendPredicate:(NSPredicate *)aPredicate withCompoundType:(NSCompoundPredicateType)type {
		NSPredicate *currentPredicate = [fetchRequest predicate];
		if (currentPredicate) {
			NSPredicate *predicate = [[NSCompoundPredicate alloc] initWithType:type 
																 subpredicates:[NSArray arrayWithObjects:currentPredicate, aPredicate, nil]];
			[fetchRequest setPredicate:predicate];
			[predicate release];
		}
		else {
			[fetchRequest setPredicate:aPredicate];
		}
	}

	#pragma mark -

	-(void) dealloc {
		[fetchRequest release]; fetchRequest = nil;
		[context release]; context = nil;
		[super dealloc];
	}

@end
