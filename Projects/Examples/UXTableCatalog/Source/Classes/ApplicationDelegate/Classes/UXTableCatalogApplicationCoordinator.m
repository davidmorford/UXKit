
#import "UXTableCatalogApplicationCoordinator.h"

@interface UXTableCatalogApplicationCoordinator ()
	-(void) setupStore;
@end

#pragma mark -

static UXTableCatalogApplicationCoordinator *sharedAppCoordinator = nil;

@implementation UXTableCatalogApplicationCoordinator

	@synthesize objectStore;

	#pragma mark Shared Coordinator

	+(UXTableCatalogApplicationCoordinator *) sharedCoordinator {
		if (sharedAppCoordinator == nil) {
			sharedAppCoordinator = [[super allocWithZone:NULL] init];
		}
		return sharedAppCoordinator;
	}

	+(id) allocWithZone:(NSZone *)zone {
		return [[self sharedCoordinator] retain];
	}

	-(id) copyWithZone:(NSZone *)zone {
		return self;
	}

	-(id) retain {
		return self;
	}

	-(NSUInteger) retainCount {
		return NSUIntegerMax;
	}

	-(void) release {

	}

	-(id) autorelease {
		return self;
	}


	#pragma mark Initializer

	-(id) init {
		self = [super init];
		if (self) {
			[self performSelector:@selector(start) withObject:nil afterDelay:0.5];
		}
		return self;
	}


	#pragma mark NSNotifications

	-(void) didReceiveMemoryWarning:(void *)object {
		UXLOG(@"APPLICATION MEMORY WARNING!");
	}


	#pragma mark KVO

	-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
		UXLOG(@"Coordinator Key Value Observation");
		UXLOG(@"KeyPath = %@", keyPath);
		UXLOG(@"Object  = %@", object);
		UXLOG(@"Changed = %@", change);
		UXLOG(@"================================================================================");
		/*
		if ([keyPath isEqualToString:@""] == TRUE) {
			NSString *previousValue	= [change objectForKey:NSKeyValueChangeOldKey];
			NSString *newValue		= [change objectForKey:NSKeyValueChangeNewKey];
		}
		*/
	}


	#pragma mark Coordinator Main

	-(void) start {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(didReceiveMemoryWarning:)
													 name:UIApplicationDidReceiveMemoryWarningNotification
												   object:nil];
		// KVO
		/*
		[self addObserver:self 
			   forKeyPath:@"" 
				  options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) 
				  context:nil];
		*/
		//[self setupStore];
	}
	

	#pragma mark Store
	
	-(void) setupStore {
		self.objectStore = [[STKObjectStore alloc] initWithModelName:@"TableCatalogTest" 
												 persistentStoreName:@"TableCatalog" 
														forceReplace:FALSE 
														   storeType:NSSQLiteStoreType 
														storeOptions:nil];
		self.objectStore.delegate = self;
	}


	#pragma mark <STKObjectStoreDelegate>

	-(void) store:(id <STKStore>)store didCreateNewManagedObjectContext:(NSManagedObjectContext *)context {
		UXLOG(@"%@, %@", store, context);
	}


	#pragma mark Destructor

	-(void) dealloc {
		[objectStore release]; objectStore = nil;
		[super dealloc];
	}

@end
