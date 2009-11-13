
#import <UXKit/UXObjectStore.h>

static UXObjectStore *sharedObjectStore = nil;

#pragma mark -

@interface UXObjectStore ()

@end

#pragma mark -

@implementation UXObjectStore
	
	@synthesize memoryStore;
	@synthesize memoryStoreContext;
	@synthesize fileStore;
	@synthesize fileStoreContext;
	
	#pragma mark Shared Store
	
	+(UXObjectStore *) sharedObjectStore {
		if (!sharedObjectStore) {
			sharedObjectStore = [[UXObjectStore alloc] init];
		}
		return sharedObjectStore;
	}
	
	#pragma mark Initializer
	
	-(id) init {
		self = [super init];
		if (self) {
			//self.storeURL = [NSURL fileURLWithPath:[UIApplication applicationSupportFolder] isDirectory:YES];
			//NSLog(@"%@", self.storeURL);
			self.storeIdentifier = @"UXKit.Store.Shared";
			[self storeCanMergeManagedObjectModels];
			[self storeWillCreatePersistentStoreCoordinator];
			[self storeCanAddPersistentStores];
			[self storeCanCreateManagedObjectContexts];			
		}
		return self;
	}
	

	#pragma mark Setup

	// bundle://MyModelName.mom
	// or
	// bundle://MyModelBundle.bundle/MyModelName.mom
	// or
	// bundle://MyLibraryName.bundle/MyLibraryModelName.mom
	-(void) storeCanMergeManagedObjectModels {
		NSURL *storageKitModelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"UXKit" ofType:@"mom"]];
		self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:storageKitModelURL];
	}

	-(void) storeWillCreatePersistentStoreCoordinator {
		self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
	}

	-(void) storeCanAddPersistentStores {
		self.memoryStore = [self addStoreWithIdentifier:@"UXKit.Store.Memory" storeType:NSInMemoryStoreType forModelConfiguration:@"UXKitStore.Configuration.Memory"];
		if (self.storeURL != nil) {
			self.fileStore = [self addStoreWithIdentifier:@"UXKit.Store.File" storeType:NSSQLiteStoreType forModelConfiguration:@"UXKitStore.Configuration.File"];
		}
	}

	-(void) storeCanCreateManagedObjectContexts {
		self.memoryStoreContext = [self newManagedObjectContextWithIdentifier:@"com.semantap.UXKit.memorystore.context"];
		if (self.storeURL != nil) {
			self.fileStoreContext = [self newManagedObjectContextWithIdentifier:@"com.semantap.UXKit.filestore.context"];
		}
	}

	#pragma mark KVO

	-(void) observeValueForKeyPath:(NSString *)aKeyPath ofObject:(id)anObject change:(NSDictionary *)aChange context:(void *)aContext {
		NSLog(@"%@: from: %@, to: %@", aKeyPath, anObject, aChange);
	}

@end
