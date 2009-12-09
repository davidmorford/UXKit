
#import <StorageKit/STKObjectStore.h>
#import <UIKit/UIApplication.h>

@interface STKObjectStore ()
	@property (readwrite, retain) NSURL *modelURL;
	@property (readwrite, retain) NSURL *persistentStoreURL;
	@property (readwrite, retain) NSString *storeType;
	@property (readwrite, retain) NSDictionary *storeOptions;

	+(NSString *) applicationSupportFolder;
	-(NSString *) threadStorageKey;

@end

#pragma mark -

@implementation STKObjectStore

	@synthesize delegate;
	@synthesize modelURL;
	@synthesize persistentStoreURL;
	@synthesize storeType;
	@synthesize storeOptions;
	@synthesize storeIdentifier;

	@dynamic persistentStoreCoordinator;
	@dynamic managedObjectModel;
	@dynamic managedObjectContext;


	#pragma mark Initializers

	-(id) init {
		self = [super init];
		if (self != nil) {
		}
		return self;
	}

	-(id) initWithModelURL:(NSURL *)aModelURL persistentStoreURL:(NSURL *)storeURL storeType:(NSString *)type storeOptions:(NSDictionary *)options {
		NSAssert(aModelURL != nil, @"modelURL should not be nil.");
		NSAssert(storeURL != nil, @"persistentStoreURL should not be nil.");
		
		self = [super init];
		if (self != nil) {
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:[UIApplication sharedApplication]];
			self.modelURL			= aModelURL;
			self.persistentStoreURL = storeURL;
			self.storeType			= type ? type : NSSQLiteStoreType;
			self.storeOptions		= options;
		}
		return (self);
	}

	-(id) initWithModelURL:(NSURL *)aModelURL persistentStoreName:(NSString *)storeName forceReplace:(BOOL)forceReplace storeType:(NSString *)type storeOptions:(NSDictionary *)options {
		NSURL *storeURL = [[self class] persistentStoreURLForName:storeName storeType:type forceReplace:forceReplace];
		NSAssert(storeURL != nil, @"thePersistentStoreURL should not be nil.");
		
		if ((self = [self initWithModelURL:aModelURL persistentStoreURL:storeURL storeType:type storeOptions:options]) != nil) {
			
		}
		return self;
	}

	-(id) initWithModelName:(NSString *)modelName persistentStoreName:(NSString *)storeName forceReplace:(BOOL)forceReplace storeType:(NSString *)type storeOptions:(NSDictionary *)options {
		NSURL *namedModelURL = [[self class] modelURLForName:modelName];
		NSAssert(namedModelURL != nil, @"theModelURL should not be nil.");
		NSURL *nameStoreURL = [[self class] persistentStoreURLForName:storeName storeType:type forceReplace:forceReplace];
		NSAssert(nameStoreURL != nil, @"thePersistentStoreURL should not be nil.");
		
		if ((self = [self initWithModelURL:namedModelURL persistentStoreURL:nameStoreURL storeType:type storeOptions:options]) != nil) {
			
		}
		return self;
	}

	-(id) initWithName:(NSString *)name forceReplace:(BOOL)forceReplace storeType:(NSString *)type storeOptions:(NSDictionary *)options {
		NSURL *URLForModel = [[self class] modelURLForName:name];
		NSAssert(URLForModel != nil, @"theModelURL should not be nil.");
		NSURL *URLForPersistentStore = [[self class] persistentStoreURLForName:name storeType:type forceReplace:forceReplace];
		NSAssert(URLForPersistentStore != nil, @"thePersistentStoreURL should not be nil.");
		
		if ((self = [self initWithModelURL:URLForModel persistentStoreURL:URLForPersistentStore storeType:type storeOptions:options]) != nil) {
			
		}
		return self;
	}


	#pragma mark Model

	-(NSManagedObjectModel *) managedObjectModel {
		@synchronized(@"STKObjectStore.managedObjectModel") {
			if (managedObjectModel == nil) {
				managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
			}
		}
		return (managedObjectModel);
	}

	+(NSURL *) modelURLForName:(NSString *)name {
		NSString *modelPath = [[NSBundle mainBundle] pathForResource:name ofType:@"mom"];
		if (modelPath == nil) {
			modelPath = [[NSBundle mainBundle] pathForResource:name ofType:@"momd"];
		}
		NSURL *modelFileURL = [NSURL fileURLWithPath:modelPath];
		return (modelFileURL);
	}

	+(NSString *) applicationSupportFolder {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
		NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
		
		NSString *bundleName = [[[[NSBundle mainBundle] bundlePath] lastPathComponent] stringByDeletingPathExtension];
		NSString *applicationSupportFolderPath = [basePath stringByAppendingPathComponent:bundleName];
		
		if ([[NSFileManager defaultManager] fileExistsAtPath:applicationSupportFolderPath] == NO) {
			NSError *error = nil;
			if ([[NSFileManager defaultManager] createDirectoryAtPath:applicationSupportFolderPath withIntermediateDirectories:YES attributes:nil error:&error] == NO) {
				return (nil);
			}
		}
		return (applicationSupportFolderPath);
	}

	-(NSString *) threadStorageKey {
		NSString *key = [NSString stringWithFormat:@"%@:%p", NSStringFromClass([self class]), self];
		return (key);
	}



	#pragma mark Stores

	-(NSPersistentStoreCoordinator *) persistentStoreCoordinator {
		@synchronized(@"STKObjectStore.persistentStoreCoordinator") {
			if (persistentStoreCoordinator == nil) {
				NSError *error = nil;
				NSManagedObjectModel *mom = self.managedObjectModel;
				if (mom == nil) {
					return (nil);
				}
				NSPersistentStoreCoordinator *psc = [[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom] autorelease];
				NSPersistentStore *store = [psc addPersistentStoreWithType:self.storeType configuration:nil URL:self.persistentStoreURL options:self.storeOptions error:&error];
				if (store == nil) {
					[self presentError:error];
				}
				
				persistentStoreCoordinator = [psc retain];
			}
		}
		return (persistentStoreCoordinator);
	}

	+(NSURL *) persistentStoreURLForName:(NSString *)storeName storeType:(NSString *)type forceReplace:(BOOL)forceReplace {
		type = type ? type : NSSQLiteStoreType;
		
		NSString *pathExtension = nil;
		if ([type isEqualToString:NSSQLiteStoreType]) {
			pathExtension = @"sqliteStore";
		}
		else if ([type isEqualToString:NSBinaryStoreType])  {
			pathExtension = @"store";
		}
		
		NSString *storePath = [[self applicationSupportFolder] stringByAppendingPathComponent:[storeName stringByAppendingPathExtension:pathExtension]];
		
		if (forceReplace == YES) {
			NSError *error = nil;
			if ([[NSFileManager defaultManager] fileExistsAtPath:storePath] == YES) {
				[[NSFileManager defaultManager] removeItemAtPath:storePath error:&error];
			}
		}
		
		if ([[NSFileManager defaultManager] fileExistsAtPath:storePath] == NO) {
			NSError *error = nil;
			NSString *sourceFile = [[NSBundle mainBundle] pathForResource:storeName ofType:pathExtension];
			if ([[NSFileManager defaultManager] fileExistsAtPath:sourceFile] == YES) {
				BOOL result = [[NSFileManager defaultManager] copyItemAtPath:sourceFile toPath:storePath error:&error];
				if (result == NO) {
					[self release];
					self = nil;
					return self;
				}
			}
		}
		NSURL *storeURL = [NSURL fileURLWithPath:storePath];
		
		return (storeURL);
	}

	-(NSArray *) persistentStores {
		return ([self.persistentStoreCoordinator persistentStores]);
	}
	
	-(NSPersistentStore *) persistentStoreForConfigurationName:(NSString *)configurationName {
		for (NSPersistentStore *store in self.persistentStores) {
			if ([[store configurationName] compare:configurationName] == NSOrderedSame) {
				return store;
			}
		}
		return nil;
	}
	
	-(NSPersistentStore *) persistentStoreWithIdentifer:(NSString *)identifer {
		for (NSPersistentStore *store in self.persistentStores) {
			if ([[store identifier] compare:identifer] == NSOrderedSame) {
				return store;
			}
		}
		return nil;
	}
	
	-(NSPersistentStore *) addStoreWithIdentifier:(NSString *)storeName storeType:(NSString *)type forModelConfiguration:(NSString *)modelConfiguration {
		NSPersistentStore *persistentStore = nil;
		NSError *storeSetupError;
		NSError *fileError;
		NSString *storeExtension = nil;
		
		if (type == NSBinaryStoreType) {
			storeExtension = @"store";
		}
		else if (type == NSSQLiteStoreType) {
			storeExtension = @"sqliteStore";
		}
				
		NSString *persistentStoreFileName	= [NSString stringWithFormat:@"%@.%@", storeName, storeExtension];
		NSURL *persistentStoreFileURL		= [NSURL fileURLWithPath:[[self.persistentStoreURL path] stringByAppendingPathComponent:persistentStoreFileName]];
		
		if ([[NSFileManager defaultManager] fileExistsAtPath:[persistentStoreFileURL path]] == FALSE) {
			[[NSFileManager defaultManager] createDirectoryAtPath:[self.persistentStoreURL path] 
									  withIntermediateDirectories:TRUE 
													   attributes:nil 
															error:&fileError];
		}		
		
		if ([type compare:NSInMemoryStoreType options:NSCaseInsensitiveSearch] == NSOrderedSame) {
			persistentStore = [persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType 
																	   configuration:modelConfiguration 
																				 URL:nil 
																			 options:nil 
																			   error:&storeSetupError];
		}
		else if ([type compare:NSBinaryStoreType options:NSCaseInsensitiveSearch] == NSOrderedSame) {
			persistentStore	= [persistentStoreCoordinator addPersistentStoreWithType:NSBinaryStoreType
																	   configuration:modelConfiguration 
																				 URL:persistentStoreFileURL
																			 options:nil 
																			   error:&storeSetupError];
		}
		else if ([type compare:NSSQLiteStoreType options:NSCaseInsensitiveSearch] == NSOrderedSame) {
			NSMutableDictionary * pragmaOptions = [NSMutableDictionary dictionary];
			[pragmaOptions setObject:@"OFF" forKey:@"synchronous"];
			[pragmaOptions setObject:@"0"   forKey:@"fullfsync"];
			NSDictionary *options = [NSDictionary dictionaryWithObject:pragmaOptions forKey:NSSQLitePragmasOption];
			persistentStore = [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType 
																	   configuration:modelConfiguration 
																				 URL:persistentStoreFileURL 
																			 options:options 
																			   error:&storeSetupError];
		}
		
		if (!persistentStore) {
			return nil;
		}
		
		[persistentStore setIdentifier:storeName];
		return persistentStore;
	}


	#pragma mark Contexts

	-(NSManagedObjectContext *) managedObjectContext {
		NSString *threadStorageKey = [self threadStorageKey];
		NSManagedObjectContext *moc = [[[NSThread currentThread] threadDictionary] objectForKey:threadStorageKey];
		if (moc == nil) {
			moc = [[self newManagedObjectContext] autorelease];
			if (moc == nil) {
				return (nil);
			}
			[[[NSThread currentThread] threadDictionary] setObject:moc forKey:threadStorageKey];
		}
		return moc;
	}

	-(NSManagedObjectContext *) newManagedObjectContext {
		NSPersistentStoreCoordinator *psc = self.persistentStoreCoordinator;
		if (psc == nil) {
			return (nil);
		}
		NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] init];
		[moc setPersistentStoreCoordinator:psc];
		
		[self.delegate store:self didCreateNewManagedObjectContext:moc];
		
		return moc;
	}


	#pragma mark Save

	-(void) save {
		NSError *error = nil;
		if ([self save:&error] == NO) {
			[self presentError:error];
		}
	}

	-(BOOL) save:(NSError **)saveError {
		BOOL result = NO;
		
		[self.managedObjectContext lock];
		
		if ([self.managedObjectContext hasChanges] == NO) {
			result = YES;
		}
		else {
			[self.managedObjectContext processPendingChanges];
			result = [self.managedObjectContext save:saveError];
		}
		
		[self.managedObjectContext unlock];
		
		return result;
	}

	-(BOOL) migrate:(NSError **)error {
		NSAssert(persistentStoreCoordinator == nil, @"Cannot migrate persistent store with it already open.");
		
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		NSPersistentStoreCoordinator *psc = [[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel] autorelease];
		NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, 
																		   [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, 
																		   nil];
		persistentStoreCoordinator = [psc retain];
		NSError *migrationError = nil;
		[psc addPersistentStoreWithType:self.storeType configuration:nil URL:self.persistentStoreURL options:options error:&migrationError];
		
		if (migrationError) {
			[migrationError retain];
		}
		
		[pool release];
		
		if (migrationError) {
			[migrationError autorelease];
		}
		
		if (error) {
			*error = migrationError;
		}
		
		return (migrationError == nil);
	}


	#pragma mark Errors

	-(void) presentError:(NSError *)error {
		//UXLOG(@"ERROR: %@ (%@)\n", [error description], [error.userInfo description]);
	}


	#pragma mark Managed Objects
	
	-(NSEntityDescription *) entityForObjectID:(NSManagedObjectID *)objectID {
		return ([objectID entity]);
	}	
	
	-(NSManagedObjectID *) managedObjectIDForURI:(NSURL *)objectURI {
		return [self.persistentStoreCoordinator managedObjectIDForURIRepresentation:objectURI];
	}

	-(NSPersistentStore *) persistentStoreForObjectID:(NSManagedObjectID *)objectID {
		return [objectID persistentStore];
	}


	#pragma mark Fetching

	-(NSArray *) sortDescriptorArrayWithDescriptorWithKey:(NSString *)key {
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];
		NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
		[sortDescriptor release];
		return descriptors;
	}

	-(NSArray *) fetchAllEntitiesForName:(NSString *)entityName {
		return [self fetchAllEntitiesForName:entityName sortDescriptors:nil];
	}

	-(NSArray *) fetchAllEntitiesForName:(NSString *)entityName sortDescriptors:(NSArray *)sortDescriptors {
		return [self fetchAllEntitiesForName:entityName sortDescriptors:nil batchSize:0];
	}

	-(NSArray *) fetchAllEntitiesForName:(NSString *)entityName sortDescriptors:(NSArray *)sortDescriptors batchSize:(NSUInteger)batchSize {
		NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
		NSFetchRequest *request = [[NSFetchRequest alloc] init];
		[request setEntity:entity];
		
		if (batchSize > 0) {
			[request setFetchBatchSize:batchSize];
		}
		
		if (sortDescriptors) {
			[request setSortDescriptors:sortDescriptors];
		}
		
		NSError *error = nil;
		NSArray *fetchResult = [self.managedObjectContext executeFetchRequest:request error:&error];
		[request release];
		
		if (error) {
			return nil;
		}
		return fetchResult;
	}

	-(NSManagedObject *) managedObjectOfType:(NSString *)type withPredicate:(NSPredicate *)predicate {
		NSEntityDescription *entity = [NSEntityDescription entityForName:type inManagedObjectContext:self.managedObjectContext];
		NSFetchRequest *request = [[NSFetchRequest alloc] init];
		[request setEntity:entity];
		[request setPredicate:predicate];
		
		NSError *error = nil;
		
		NSArray *fetchResult = [self.managedObjectContext executeFetchRequest:request error:&error];
		[request release];
		
		if ([fetchResult count] == 0) {
			return nil;
		}
		
		return [fetchResult objectAtIndex:0];
	}


	#pragma mark Memory

	-(void) applicationWillTerminate:(NSNotification *)note {
		[self save];
	}

	-(void) dealloc {
		[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:[UIApplication sharedApplication]];
		[self save];
		
		self.modelURL = nil;
		self.persistentStoreURL = nil;
		self.storeType = nil;
		self.storeOptions = nil;
		
		[persistentStoreCoordinator release]; persistentStoreCoordinator = nil;
		[managedObjectModel release]; managedObjectModel = nil;
		[super dealloc];
	}

@end
